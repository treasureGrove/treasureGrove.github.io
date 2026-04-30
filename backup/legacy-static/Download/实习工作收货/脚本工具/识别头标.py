import cv2
import os
import sys
import csv
import math
import argparse
import numpy as np

try:
    from tqdm import tqdm
    USE_TQDM = True
except Exception:
    USE_TQDM = False

def ensure_dir(p):
    os.makedirs(p, exist_ok=True)

def parse_hsv_ranges(spec: str):
    """
    解析 HSV 范围字符串，返回[(lower(np.array[3]), upper(np.array[3]))...]
    格式示例：
      "80,80,80-130,255,255"                  一段范围
      "35,60,60-85,255,255;0,120,120-10,255,255"  多段范围用分号分隔
    注意：OpenCV HSV 的 H 范围是 [0,179]
    """
    if not spec:
        return []
    parts = [p.strip() for p in spec.split(";") if p.strip()]
    ranges = []
    for p in parts:
        if "-" not in p:
            continue
        a, b = p.split("-", 1)
        l = [int(x) for x in a.split(",")]
        u = [int(x) for x in b.split(",")]
        if len(l) != 3 or len(u) != 3:
            continue
        l = np.array([max(0, min(179, l[0])), max(0, min(255, l[1])), max(0, min(255, l[2]))], dtype=np.uint8)
        u = np.array([max(0, min(179, u[0])), max(0, min(255, u[1])), max(0, min(255, u[2]))], dtype=np.uint8)
        ranges.append((l, u))
    return ranges

def color_mask_hsv(img_bgr, hsv_ranges, blur_ksize=3, roi=None):
    """
    基于 HSV 范围生成掩码。多段范围按 OR 合并。
    """
    H, W = img_bgr.shape[:2]
    x0, y0, x1, y1 = 0, 0, W, H
    if roi is not None:
        x0, y0, x1, y1 = roi
        x0 = max(0, x0); y0 = max(0, y0); x1 = min(W, x1); y1 = min(H, y1)
    crop = img_bgr[y0:y1, x0:x1]
    if blur_ksize and blur_ksize >= 3 and blur_ksize % 2 == 1:
        crop = cv2.GaussianBlur(crop, (blur_ksize, blur_ksize), 0)
    hsv = cv2.cvtColor(crop, cv2.COLOR_BGR2HSV)
    mask = None
    for lo, hi in hsv_ranges:
        m = cv2.inRange(hsv, lo, hi)
        mask = m if mask is None else cv2.bitwise_or(mask, m)
    if mask is None:
        mask = np.zeros((y1 - y0, x1 - x0), dtype=np.uint8)
    return mask, (x0, y0)

def find_circles_by_contour(mask, offset_xy, min_r, max_r, min_circularity=0.65, min_area=10, open_iter=1, close_iter=1, kernel=5):
    """
    在单通道二值 mask 上基于轮廓的圆形检测，返回[(cx,cy,r,score)]
    score 用面积或圆度作为简单置信度。
    """
    if kernel % 2 == 0:
        kernel += 1
    kernel = max(kernel, 3)
    k = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (kernel, kernel))
    if open_iter > 0:
        mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, k, iterations=open_iter)
    if close_iter > 0:
        mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, k, iterations=close_iter)

    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    xoff, yoff = offset_xy
    out = []
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if area < max(min_area, math.pi * (min_r ** 2) * 0.3):  # 粗略过滤
            continue
        peri = max(1.0, cv2.arcLength(cnt, True))
        circularity = 4.0 * math.pi * area / (peri * peri)
        if circularity < min_circularity:
            continue
        (x, y), radius = cv2.minEnclosingCircle(cnt)
        if radius < min_r or radius > max_r:
            continue
        cx = xoff + x
        cy = yoff + y
        score = float(circularity * area)
        out.append((float(cx), float(cy), float(radius), score))
    return out

def is_square_like(cnt, ar_tol=0.35):
    """
    判断轮廓是否近似正方形（允许旋转）。
    使用 minAreaRect 的长宽比判断是否接近 1。
    """
    rect = cv2.minAreaRect(cnt)
    (cx, cy), (w, h), _ = rect
    w = max(1e-3, w); h = max(1e-3, h)
    ratio = max(w, h) / min(w, h)
    return ratio <= (1.0 + ar_tol), rect

def find_squares(mask, offset_xy, min_side, max_side, ar_tol=0.35, min_area=20, open_iter=1, close_iter=1, kernel=5):
    """
    在二值 mask 上寻找近似方形（包含旋转正方形/菱形），返回[(cx,cy,side,score)]
    side 使用 min(w,h)
    """
    if kernel % 2 == 0:
        kernel += 1
    kernel = max(kernel, 3)
    k = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (kernel, kernel))
    if open_iter > 0:
        mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, k, iterations=open_iter)
    if close_iter > 0:
        mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, k, iterations=close_iter)

    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    xoff, yoff = offset_xy
    out = []
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if area < min_area:
            continue
        approx = cv2.approxPolyDP(cnt, 0.04 * cv2.arcLength(cnt, True), True)
        if len(approx) < 4:  # 放宽：有时轮廓更复杂，但要求矩形特性
            continue
        ok, rect = is_square_like(cnt, ar_tol=ar_tol)
        if not ok:
            continue
        (cx, cy), (w, h), _ = rect
        side = min(w, h)
        if side < min_side or side > max_side:
            continue
        cx += xoff
        cy += yoff
        score = float(area)
        out.append((float(cx), float(cy), float(side), score))
    return out

def nms_points(points, scores, min_dist):
    """
    简单点级别 NMS，按分数从高到低保留，距离阈值内的视为重复。
    points: Nx2
    scores: N
    """
    if len(points) == 0:
        return []
    idx = np.argsort(scores)[::-1]
    kept = []
    pts = np.array(points, dtype=np.float32)
    for i in idx:
        p = pts[i]
        if all(np.linalg.norm(p - pts[j]) > min_dist for j in kept):
            kept.append(i)
    return kept

def overlay_heatmap(base_bgr, heatmap, alpha=0.6):
    hmap = heatmap.copy()
    if hmap.max() > 0:
        hmap = hmap / (hmap.max() + 1e-9)
    hmap_u8 = np.uint8(np.clip(hmap * 255, 0, 255))
    hmap_color = cv2.applyColorMap(hmap_u8, cv2.COLORMAP_JET)
    out = cv2.addWeighted(base_bgr, 1.0, hmap_color, alpha, 0)
    return out, hmap_color

def add_points_to_heatmap(heatmap, points):
    H, W = heatmap.shape[:2]
    for (x, y) in points:
        xi = int(round(x))
        yi = int(round(y))
        if 0 <= xi < W and 0 <= yi < H:
            heatmap[yi, xi] += 1.0

def main():
    ap = argparse.ArgumentParser(description="统计FPS视频中圆形/方形头标的出现区域，输出热力图与遮罩图")
    ap.add_argument("--video", required=True, help="视频路径")
    ap.add_argument("--out", default="out_shape_stats", help="输出目录")
    ap.add_argument("--sample_step", type=int, default=1, help="抽帧步长，1=每帧")
    ap.add_argument("--start", type=float, default=0.0, help="开始时间(秒)")
    ap.add_argument("--end", type=float, default=-1.0, help="结束时间(秒)，-1表示到末尾")
    ap.add_argument("--roi", type=str, default="", help="限定检测区域 x0,y0,x1,y1（可选）")

    # 颜色阈值（示例默认：圆形偏蓝青，方形偏绿色；请按实际 UI 调整）
    ap.add_argument("--hsv_circle", type=str, default="80,80,80-130,255,255", help="圆形HSV范围，多段分号分隔")
    ap.add_argument("--hsv_square", type=str, default="35,60,60-85,255,255", help="方形HSV范围，多段分号分隔")

    # 圆检测阈值
    ap.add_argument("--circle_circularity", type=float, default=0.65, help="圆度阈值 4πA/P^2 的下限")
    ap.add_argument("--circle_min_r_ratio", type=float, default=0.006, help="最小半径占 min(H,W) 的比例")
    ap.add_argument("--circle_max_r_ratio", type=float, default=0.06, help="最大半径占 min(H,W) 的比例")

    # 方形检测阈值
    ap.add_argument("--square_ar_tol", type=float, default=0.35, help="正方形长宽比容忍度，ratio<=1+tol")
    ap.add_argument("--square_min_side_ratio", type=float, default=0.01, help="最小边长占 min(H,W) 的比例")
    ap.add_argument("--square_max_side_ratio", type=float, default=0.12, help="最大边长占 min(H,W) 的比例")

    # 形态学与平滑
    ap.add_argument("--hsv_blur", type=int, default=3, help="HSV前的高斯核(奇数)")
    ap.add_argument("--morph_kernel", type=int, default=5, help="形态学核(奇数)")
    ap.add_argument("--circle_open", type=int, default=1)
    ap.add_argument("--circle_close", type=int, default=1)
    ap.add_argument("--square_open", type=int, default=1)
    ap.add_argument("--square_close", type=int, default=1)

    # 合并/去重
    ap.add_argument("--merge_dist_ratio", type=float, default=0.02, help="点去重距离占 min(H,W) 的比例")

    # 热力图/遮罩输出
    ap.add_argument("--heatmap_sigma", type=int, default=15, help="热力图高斯模糊核(奇数)")
    ap.add_argument("--mask_percentile", type=float, default=85.0, help="遮罩阈值分位数(针对非零热力值)")
    ap.add_argument("--mask_min_count", type=float, default=-1, help="遮罩绝对阈值(>=0优先)")
    ap.add_argument("--mask_kernel", type=int, default=7, help="遮罩形态学核(奇数)")
    ap.add_argument("--mask_open", type=int, default=0, help="遮罩开运算次数")
    ap.add_argument("--mask_close", type=int, default=1, help="遮罩闭运算次数")

    # 调试/可视化
    ap.add_argument("--save_preview_every", type=int, default=0, help="每N帧保存一张检测预览(0=不保存)")

    args = ap.parse_args()

    ensure_dir(args.out)

    roi = None
    if args.roi:
        try:
            x0, y0, x1, y1 = [int(v) for v in args.roi.split(",")]
            roi = (x0, y0, x1, y1)
        except Exception:
            print("[WARN] ROI 解析失败，忽略")

    cap = cv2.VideoCapture(args.video)
    if not cap.isOpened():
        print(f"[ERR] 无法打开视频: {args.video}")
        sys.exit(1)

    fps = cap.get(cv2.CAP_PROP_FPS) or 30.0
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT) or 0)
    W = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH) or 0)
    H = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT) or 0)
    minHW = float(min(W, H))

    start_f = int(max(0, args.start) * fps)
    end_f = total_frames - 1 if args.end < 0 else int(min(total_frames - 1, args.end * fps))

    # 读取参考帧（用于叠加热力图）
    cap.set(cv2.CAP_PROP_POS_FRAMES, max(0, start_f))
    ok, ref = cap.read()
    if not ok:
        print("[ERR] 无法读取参考帧")
        sys.exit(1)
    ref_bgr = ref.copy()

    # 参数换算（像素）
    circle_min_r = max(2.5, args.circle_min_r_ratio * minHW)
    circle_max_r = max(circle_min_r + 1.0, args.circle_max_r_ratio * minHW)
    square_min_side = max(3.0, args.square_min_side_ratio * minHW)
    square_max_side = max(square_min_side + 1.0, args.square_max_side_ratio * minHW)
    merge_dist = max(2.0, args.merge_dist_ratio * minHW)

    hsv_circle_ranges = parse_hsv_ranges(args.hsv_circle)
    hsv_square_ranges = parse_hsv_ranges(args.hsv_square)

    # 统计容器
    heatmap = np.zeros((H, W), dtype=np.float32)
    heatmap_circle = np.zeros((H, W), dtype=np.float32)
    heatmap_square = np.zeros((H, W), dtype=np.float32)
    det_rows = []

    frame_indices = range(start_f, end_f + 1, max(1, args.sample_step))
    iterator = tqdm(frame_indices, desc="Processing") if USE_TQDM else frame_indices

    preview_idx = 0

    for fi in iterator:
        cap.set(cv2.CAP_PROP_POS_FRAMES, fi)
        ok, frame = cap.read()
        if not ok:
            continue

        # 圆形颜色掩码
        circle_mask, (xoff_c, yoff_c) = color_mask_hsv(frame, hsv_circle_ranges, blur_ksize=args.hsv_blur, roi=roi)
        # 方形颜色掩码
        square_mask, (xoff_s, yoff_s) = color_mask_hsv(frame, hsv_square_ranges, blur_ksize=args.hsv_blur, roi=roi)

        # 圆形检测
        circles = find_circles_by_contour(
            circle_mask, (xoff_c, yoff_c),
            min_r=circle_min_r, max_r=circle_max_r,
            min_circularity=args.circle_circularity,
            min_area=10,
            open_iter=args.circle_open, close_iter=args.circle_close, kernel=args.morph_kernel
        )
        if len(circles) > 0:
            pts_c = [(c[0], c[1]) for c in circles]
            sc_c = [c[3] for c in circles]
            keep_c = nms_points(pts_c, sc_c, min_dist=merge_dist)
            circles = [circles[i] for i in keep_c]
        # 方形检测
        squares = find_squares(
            square_mask, (xoff_s, yoff_s),
            min_side=square_min_side, max_side=square_max_side,
            ar_tol=args.square_ar_tol,
            min_area=20,
            open_iter=args.square_open, close_iter=args.square_close, kernel=args.morph_kernel
        )
        if len(squares) > 0:
            pts_s = [(s[0], s[1]) for s in squares]
            sc_s = [s[3] for s in squares]
            keep_s = nms_points(pts_s, sc_s, min_dist=merge_dist)
            squares = [squares[i] for i in keep_s]

        # 合并两类再做一次点级别NMS避免同点重复
        all_pts = [(c[0], c[1]) for c in circles] + [(s[0], s[1]) for s in squares]
        all_sc = [c[3] for c in circles] + [s[3] for s in squares]
        if len(all_pts) > 0:
            keep_all = nms_points(all_pts, all_sc, min_dist=merge_dist)
            kept_set = set(keep_all)
        else:
            kept_set = set()

        t_sec = fi / max(1e-6, fps)
        # 累加热力图与导出行
        c_count, s_count = 0, 0
        for i, c in enumerate(circles):
            if i in kept_set:
                add_points_to_heatmap(heatmap, [(c[0], c[1])])
                add_points_to_heatmap(heatmap_circle, [(c[0], c[1])])
                det_rows.append([fi, f"{t_sec:.3f}", f"{c[0]:.1f}", f"{c[1]:.1f}", "circle", f"r={c[2]:.1f}", f"{c[3]:.1f}"])
                c_count += 1
        offset = len(circles)
        for j, s in enumerate(squares):
            idx = offset + j
            if idx in kept_set:
                add_points_to_heatmap(heatmap, [(s[0], s[1])])
                add_points_to_heatmap(heatmap_square, [(s[0], s[1])])
                det_rows.append([fi, f"{t_sec:.3f}", f"{s[0]:.1f}", f"{s[1]:.1f}", "square", f"side={s[2]:.1f}", f"{s[3]:.1f}"])
                s_count += 1

        # 可选预览
        if args.save_preview_every and args.save_preview_every > 0 and (fi - start_f) % args.save_preview_every == 0:
            vis = frame.copy()
            for (cx, cy, r, _) in circles:
                cv2.circle(vis, (int(round(cx)), int(round(cy))), int(round(r)), (0, 255, 255), 2)
            for (cx, cy, side, _) in squares:
                cv2.circle(vis, (int(round(cx)), int(round(cy))), int(max(3, round(side / 2))), (0, 165, 255), 2)
            if roi is not None:
                cv2.rectangle(vis, (roi[0], roi[1]), (roi[2], roi[3]), (255, 0, 0), 2)
            cv2.putText(vis, f"C:{c_count} S:{s_count}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0,255,0), 2)
            cv2.imwrite(os.path.join(args.out, f"preview_{preview_idx:05d}.png"), vis)
            preview_idx += 1

    cap.release()

    # 若无检测
    total_det = int(np.sum(heatmap))
    if len(det_rows) == 0 or total_det == 0:
        print("未检测到头标。建议：1) 调整 --hsv_circle / --hsv_square 色域；2) 放宽尺寸阈值；3) 指定更合理的 ROI。")
        sys.exit(0)

    # 导出 CSV
    csv_path = os.path.join(args.out, "detections.csv")
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["frame_idx", "time_sec", "x", "y", "type", "size", "score"])
        w.writerows(det_rows)
    print(f"已保存检测明细: {csv_path}")

    # 热力图平滑
    k = args.heatmap_sigma
    if k % 2 == 0:
        k += 1
    k = max(3, k)
    heatmap_blur = cv2.GaussianBlur(heatmap, (k, k), 0)
    heatmap_circle_blur = cv2.GaussianBlur(heatmap_circle, (k, k), 0)
    heatmap_square_blur = cv2.GaussianBlur(heatmap_square, (k, k), 0)

    # 叠加参考帧 + 独立热力图
    overlay, heat_color = overlay_heatmap(ref_bgr, heatmap_blur, alpha=0.6)
    overlay_path = os.path.join(args.out, "heatmap_overlay.png")
    heat_color_path = os.path.join(args.out, "heatmap_color.png")
    
    cv2.imwrite(overlay_path, overlay)
    cv2.imwrite(heat_color_path, heat_color)
    print(f"已保存热力图叠加图: {overlay_path}")
    print(f"已保存热力图颜色图: {heat_color_path}")
    
    # 分类型（可选）
    _, heat_circle_color = overlay_heatmap(ref_bgr, heatmap_circle_blur, alpha=0.6)
    _, heat_square_color = overlay_heatmap(ref_bgr, heatmap_square_blur, alpha=0.6)
    
    circle_path = os.path.join(args.out, "heatmap_circle_color.png")
    square_path = os.path.join(args.out, "heatmap_square_color.png")
    
    cv2.imwrite(circle_path, heat_circle_color)
    cv2.imwrite(square_path, heat_square_color)
    
    print(f"已保存圆形热力图: {circle_path}")
    print(f"已保存方形热力图: {square_path}")
    
    np.save(os.path.join(args.out, "heatmap_raw.npy"), heatmap)
    print("已保存热力图/原始矩阵。")

    # 遮罩阈值
    if args.mask_min_count is not None and args.mask_min_count >= 0:
        thr = float(args.mask_min_count)
        thr_mode = f"绝对阈值({thr:.3f})"
    else:
        nonzero = heatmap_blur[heatmap_blur > 0]
        if nonzero.size > 0:
            thr = float(np.percentile(nonzero, args.mask_percentile))
        else:
            thr = 0.0
        thr_mode = f"分位数P{args.mask_percentile:.1f} -> {thr:.3f}"

    mask = (heatmap_blur >= thr).astype(np.uint8) * 255
    mk = args.mask_kernel if args.mask_kernel % 2 == 1 else args.mask_kernel + 1
    mk = max(3, mk)
    ker = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (mk, mk))
    if args.mask_open > 0:
        mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, ker, iterations=int(args.mask_open))
    if args.mask_close > 0:
        mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, ker, iterations=int(args.mask_close))
    
    mask_path = os.path.join(args.out, "mask.png")
    success = cv2.imwrite(mask_path, mask)
    if success:
        print(f"已保存遮罩图: {mask_path}（阈值模式: {thr_mode}）")
    else:
        print(f"警告：遮罩图保存失败: {mask_path}")

    # 生成头标范围边界图
    boundary_img = ref_bgr.copy()
    
    # 绘制ROI区域边界（如果有指定）
    if roi is not None:
        cv2.rectangle(boundary_img, (roi[0], roi[1]), (roi[2], roi[3]), (0, 255, 0), 3)
        cv2.putText(boundary_img, "检测区域 (ROI)", (roi[0], roi[1]-10), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 255, 0), 2)
    
    # 在mask上找到轮廓，绘制头标集中区域的边界
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    # 绘制所有检测到的头标区域轮廓
    cv2.drawContours(boundary_img, contours, -1, (0, 0, 255), 2)
    
    # 找到最大的几个轮廓区域并高亮显示
    if len(contours) > 0:
        # 按面积排序，取前5个最大区域
        contours_sorted = sorted(contours, key=cv2.contourArea, reverse=True)[:5]
        for i, cnt in enumerate(contours_sorted):
            area = cv2.contourArea(cnt)
            if area > 50:  # 只显示足够大的区域
                # 用不同颜色标记不同的主要区域
                colors = [(255, 0, 0), (255, 165, 0), (255, 255, 0), (0, 255, 255), (255, 0, 255)]
                color = colors[i % len(colors)]
                cv2.drawContours(boundary_img, [cnt], -1, color, 3)
                
                # 计算轮廓的外接矩形并标注
                x, y, w, h = cv2.boundingRect(cnt)
                cv2.rectangle(boundary_img, (x, y), (x+w, y+h), color, 2)
                cv2.putText(boundary_img, f"区域{i+1} 面积:{int(area)}", (x, y-5), 
                           cv2.FONT_HERSHEY_SIMPLEX, 0.6, color, 2)
    
    # 添加总体统计信息
    total_detections = len(det_rows)
    cv2.putText(boundary_img, f"总检测数: {total_detections}", (10, 30), 
               cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255), 2)
    cv2.putText(boundary_img, f"主要头标区域边界图", (10, 70), 
               cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 255, 255), 2)
    
    # 保存边界图
    cv2.imwrite(os.path.join(args.out, "头标范围边界图.png"), boundary_img)
    print(f"已保存头标范围边界图: {os.path.join(args.out, '头标范围边界图.png')}")

if __name__ == "__main__":
    main()