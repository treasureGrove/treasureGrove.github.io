import os
import sys
import subprocess

def auto_install_deps():
    need = []
    try:
        import numpy
    except ImportError:
        need.append("numpy")
    try:
        import PIL
    except ImportError:
        need.append("pillow")
    try:
        import imageio
    except ImportError:
        need.append("imageio")
    try:
        import PyQt5
    except ImportError:
        need.append("pyqt5")
    try:
        import av
    except ImportError:
        need.append("imageio[pyav]")
    if need:
        print(f"[INFO] 正在为你自动安装: {' '.join(need)}")
    for pkg in need:
        subprocess.check_call([sys.executable, "-m", "pip", "install", pkg])

auto_install_deps()

import numpy as np
from PIL import Image
import imageio.v3 as iio
from PyQt5 import QtWidgets, QtCore, QtGui
import threading

face_names = ['+X', '-X', '+Y', '-Y', '+Z', '-Z']

def read_hdr(path):
    if not os.path.isfile(path):
        raise FileNotFoundError(f"No such file: '{path}'")
    try:
        img = iio.imread(path, plugin="pyav")
    except Exception:
        img = iio.imread(path)
    if img is None or not hasattr(img, 'ndim'):
        raise RuntimeError(f"文件解码失败: {path}")
    while img.ndim > 3 and img.shape[0] == 1:
        img = np.squeeze(img, axis=0)
    if img.ndim == 2:
        img = np.stack([img] * 3, axis=-1)
    if img.shape[-1] > 3:
        img = img[..., :3]
    if img.shape[-1] != 3:
        img = np.squeeze(img)
        if img.ndim == 2:
            img = np.stack([img] * 3, axis=-1)
        elif img.shape[-1] == 1:
            img = np.repeat(img, 3, axis=-1)
    if img.dtype == np.uint8:
        img = img.astype(np.float32) / 255.0
    elif img.dtype == np.uint16:
        img = img.astype(np.float32) / 65535.0
    elif img.dtype in [np.float32, np.float64]:
        img = img.astype(np.float32)
        if img.max() > 2.0:
            img = img / 65535.0
    else:
        img = img.astype(np.float32)
    return img

def face_pixel_direction(face, i, j, N):
    a = 2.0 * i / (N - 1) - 1.0
    b = 2.0 * j / (N - 1) - 1.0
    if face == 0: direction = [1.0, -b, -a]
    elif face == 1: direction = [-1.0, -b, a]
    elif face == 2: direction = [a, 1.0, b]
    elif face == 3: direction = [a, -1.0, -b]
    elif face == 4: direction = [a, -b, 1.0]
    elif face == 5: direction = [-a, -b, -1.0]
    direction = np.array(direction, dtype=np.float32)
    direction /= np.linalg.norm(direction)
    return direction

def direction_to_equirect(d, w, h):
    x, y, z = d
    theta = np.arctan2(-z, x)
    phi = np.arccos(np.clip(y, -1.0, 1.0))
    u = ((theta + np.pi) / (2 * np.pi)) * w
    v = (phi / np.pi) * h
    return int(np.clip(u, 0, w - 1)), int(np.clip(v, 0, h - 1))

def tonemap_reinhard(x):
    return x / (1.0 + x)

def srgb_gamma(x):
    return np.power(np.clip(x, 0, 1), 1 / 2.2)

def correct_rgb_shape(img):
    img = np.asarray(img)
    img = np.squeeze(img)
    if img.ndim == 2:
        img = np.stack([img] * 3, axis=-1)
    elif img.ndim == 3 and img.shape[-1] == 1:
        img = np.repeat(img, 3, axis=-1)
    if img.ndim != 3 or img.shape[-1] != 3:
        raise Exception(f"[FATAL] 图像shape异常：{img.shape}")
    return img

def generate_cube_faces(eq_img, cube_size, scale, tonemap_enabled=True, gamma_enabled=True):
    """6面CubeMap，Tonemap/Gamma任意组合，返回uint8 RGB数组"""
    eq_img = eq_img * scale
    faces = []
    h, w = eq_img.shape[:2]
    for face in range(6):
        out = np.zeros((cube_size, cube_size, 3), np.float32)
        for i in range(cube_size):
            for j in range(cube_size):
                d = face_pixel_direction(face, i, j, cube_size)
                u, v = direction_to_equirect(d, w, h)
                out[j, i, :] = eq_img[v, u, :3]
        if tonemap_enabled:
            out = tonemap_reinhard(out)
        if gamma_enabled:
            out = srgb_gamma(out)
        out = np.clip(out, 0, 1)
        out8 = (out * 255).astype(np.uint8)
        out8 = correct_rgb_shape(out8)
        faces.append(out8)
    return faces

class CubeMapGUI(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("CubeMap生成工具（Tonemap/Gamma可单独控制）")
        self.setGeometry(100, 100, 900, 590)
        self.layout = QtWidgets.QHBoxLayout(self)

        # 左侧预览
        self.preview_label = QtWidgets.QLabel()
        self.preview_label.setFixedSize(512, 512)
        self.preview_label.setStyleSheet("border: 1px solid gray; background: black")
        self.preview_label.setAlignment(QtCore.Qt.AlignCenter)
        self.layout.addWidget(self.preview_label)

        # 设置窗口接受拖放
        self.setAcceptDrops(True)

        # 右侧控制区
        vbox = QtWidgets.QVBoxLayout()
        self.layout.addLayout(vbox)

        self.input_path = QtWidgets.QLineEdit()
        self.input_path.setPlaceholderText("输入图片路径或点击浏览...")
        btn_browse = QtWidgets.QPushButton("浏览图片")
        btn_browse.clicked.connect(self.on_browse)
        hbox1 = QtWidgets.QHBoxLayout()
        hbox1.addWidget(self.input_path)
        hbox1.addWidget(btn_browse)
        vbox.addLayout(hbox1)

        self.output_path = QtWidgets.QLineEdit()
        self.output_path.setPlaceholderText("输出文件夹，不输入使用图片同目录")
        btn_outbrowse = QtWidgets.QPushButton("浏览文件夹")
        btn_outbrowse.clicked.connect(self.on_outbrowse)
        hbox2 = QtWidgets.QHBoxLayout()
        hbox2.addWidget(self.output_path)
        hbox2.addWidget(btn_outbrowse)
        vbox.addLayout(hbox2)

        self.cube_size_box = QtWidgets.QComboBox()
        self.cube_size_box.addItems(["512", "1024", "2048"])
        vbox.addWidget(QtWidgets.QLabel("CubeMap面分辨率:"))
        vbox.addWidget(self.cube_size_box)

        vbox.addWidget(QtWidgets.QLabel("亮度缩放系数（0.1~10），右侧可滑动调节或输入:"))
        self.scale_slider = QtWidgets.QSlider(QtCore.Qt.Horizontal)
        self.scale_slider.setMinimum(1)
        self.scale_slider.setMaximum(100)
        self.scale_slider.setValue(10)
        self.scale_slider.valueChanged.connect(self.on_scale_change)
        vbox.addWidget(self.scale_slider)
        self.scale_edit = QtWidgets.QLineEdit("1.00")
        self.scale_edit.setFixedWidth(60)
        self.scale_edit.editingFinished.connect(self.on_scale_edit_change)
        hbox3 = QtWidgets.QHBoxLayout()
        hbox3.addWidget(QtWidgets.QLabel("缩放系数:"))
        hbox3.addWidget(self.scale_edit)
        vbox.addLayout(hbox3)

        self.face_select = QtWidgets.QComboBox()
        self.face_select.addItems(face_names)
        self.face_select.currentIndexChanged.connect(self.update_preview)
        hbox4 = QtWidgets.QHBoxLayout()
        hbox4.addWidget(QtWidgets.QLabel("预览cube面:"))
        hbox4.addWidget(self.face_select)
        vbox.addLayout(hbox4)

        # Tonemap和Gamma勾选框（独立）
        self.tonemap_checkbox = QtWidgets.QCheckBox("Tonemap (Reinhard)")
        self.tonemap_checkbox.setChecked(True)
        self.tonemap_checkbox.stateChanged.connect(self.on_any_effect_checked)
        self.gamma_checkbox = QtWidgets.QCheckBox("Gamma校正 (sRGB)")
        self.gamma_checkbox.setChecked(True)
        self.gamma_checkbox.stateChanged.connect(self.on_any_effect_checked)
        hbox5 = QtWidgets.QHBoxLayout()
        hbox5.addWidget(self.tonemap_checkbox)
        hbox5.addWidget(self.gamma_checkbox)
        vbox.addLayout(hbox5)

        self.status = QtWidgets.QLabel("")
        vbox.addWidget(self.status)
        self.btn_save = QtWidgets.QPushButton("导出6张CubeMap PNG")
        self.btn_save.clicked.connect(self.on_save)
        vbox.addWidget(self.btn_save)

        self.btn_save_combined = QtWidgets.QPushButton("导出合成一张立方体CubeMap PNG")
        self.btn_save_combined.clicked.connect(self.on_save_combined)
        vbox.addWidget(self.btn_save_combined)

        vbox.addStretch()

        # 预览分辨率
        self.preview_cubesize = 128

        # 防抖定时器
        self.preview_timer = QtCore.QTimer()
        self.preview_timer.setSingleShot(True)
        self.preview_timer.timeout.connect(self._do_preview)

        self.eq_img = None
        self.faces = None

    def dragEnterEvent(self, event):
        if event.mimeData().hasUrls():
            event.accept()
        else:
            event.ignore()

    def dropEvent(self, event):
        if event.mimeData().hasUrls():
            url = event.mimeData().urls()[0]
            filePath = url.toLocalFile()
            if os.path.isfile(filePath):
                self.input_path.setText(filePath)
                self.load_image_and_update()

    def on_browse(self):
        fname, _ = QtWidgets.QFileDialog.getOpenFileName(self, "选取全景图片", "", "图片文件 (*.hdr *.exr *.jpg *.jpeg *.png)")
        if fname:
            self.input_path.setText(fname)
            self.load_image_and_update()

    def on_outbrowse(self):
        fname = QtWidgets.QFileDialog.getExistingDirectory(self, "选取输出文件夹")
        if fname:
            self.output_path.setText(fname)

    def on_any_effect_checked(self):
        self.preview_timer.start(80)

    def load_image_and_update(self):
        try:
            input_path = self.input_path.text().strip()
            if not os.path.isfile(input_path):
                self.status.setText("图片文件不存在")
                return
            self.eq_img = read_hdr(input_path)
            self.status.setText(f"图片读取成功: {os.path.basename(input_path)}, shape: {self.eq_img.shape}")
            self.preview_timer.start(80)
        except Exception as e:
            self.status.setText(f"读取图片失败: {e}")

    def on_scale_change(self):
        val = self.scale_slider.value() / 10.0
        self.scale_edit.setText(f"{val:.2f}")
        self.preview_timer.start(80)  # 80ms防抖

    def on_scale_edit_change(self):
        try:
            val = float(self.scale_edit.text())
            val = max(0.1, min(val, 10.0))
            idx = int(round(val * 10))
            self.scale_slider.setValue(idx)
            self.scale_edit.setText(f"{val:.2f}")
            self.preview_timer.start(80)
        except:
            self.scale_edit.setText("1.00")

    def _do_preview(self):
        if self.eq_img is None:
            return
        try:
            scale = float(self.scale_edit.text())
            tonemap = self.tonemap_checkbox.isChecked()
            gamma = self.gamma_checkbox.isChecked()
            def task():
                faces = generate_cube_faces(self.eq_img, self.preview_cubesize, scale, tonemap_enabled=tonemap, gamma_enabled=gamma)
                QtCore.QMetaObject.invokeMethod(self, "set_preview_faces", QtCore.Qt.QueuedConnection, QtCore.Q_ARG(object, faces))
            threading.Thread(target=task, daemon=True).start()
        except Exception as e:
            self.status.setText(f"生成预览失败: {e}")

    @QtCore.pyqtSlot(object)
    def set_preview_faces(self, faces):
        self.faces = faces
        self.update_preview()

    def update_preview(self):
        if self.faces is None:
            return
        idx = self.face_select.currentIndex()
        img = Image.fromarray(self.faces[idx], "RGB")
        data = img.convert("RGBA").tobytes("raw", "RGBA")
        qimg = QtGui.QImage(data, img.width, img.height, QtGui.QImage.Format_RGBA8888)
        pix = QtGui.QPixmap.fromImage(qimg)
        target_size = self.preview_label.size()
        pix = pix.scaled(target_size, QtCore.Qt.KeepAspectRatio, QtCore.Qt.SmoothTransformation)
        self.preview_label.setPixmap(pix)

    def on_save(self):
        try:
            if self.eq_img is None:
                self.status.setText("请先载入图片")
                return
            output_dir = self.output_path.text().strip()
            if output_dir == '':
                output_dir = os.path.dirname(self.input_path.text().strip())
            os.makedirs(output_dir, exist_ok=True)
            cube_size = int(self.cube_size_box.currentText())
            scale = float(self.scale_edit.text())
            tonemap = self.tonemap_checkbox.isChecked()
            gamma = self.gamma_checkbox.isChecked()
            self.status.setText("正在导出高分辨率图片，请稍候...")
            QtWidgets.QApplication.processEvents()
            faces = generate_cube_faces(self.eq_img, cube_size, scale, tonemap_enabled=tonemap, gamma_enabled=gamma)
            for i in range(6):
                fname = os.path.join(output_dir, f"cube_{face_names[i]}.png")
                Image.fromarray(faces[i], "RGB").save(fname)
            self.status.setText(f"保存完成: {output_dir}")
        except Exception as e:
            self.status.setText(f"保存失败: {e}")

    def on_save_combined(self):
        try:
            if self.eq_img is None:
                self.status.setText("请先载入图片")
                return
            output_dir = self.output_path.text().strip()
            if output_dir == '':
                output_dir = os.path.dirname(self.input_path.text().strip())
            os.makedirs(output_dir, exist_ok=True)
            cube_size = int(self.cube_size_box.currentText())
            scale = float(self.scale_edit.text())
            tonemap = self.tonemap_checkbox.isChecked()
            gamma = self.gamma_checkbox.isChecked()
            self.status.setText("正在导出合成图片，请稍候...")
            QtWidgets.QApplication.processEvents()
            faces = generate_cube_faces(self.eq_img, cube_size, scale, tonemap_enabled=tonemap, gamma_enabled=gamma)
            combined_size = cube_size * 4
            combined_height = cube_size * 3
            combined = np.zeros((combined_height, combined_size, 3), dtype=np.uint8)

            # 按特定位置放置面
            combined[0:cube_size, cube_size:cube_size*2, :] = faces[2]  # +Y
            combined[cube_size:cube_size*2, 0:cube_size, :] = faces[1] # -X
            combined[cube_size:cube_size*2, cube_size:cube_size*2, :] = faces[4] # +Z
            combined[cube_size:cube_size*2, cube_size*2:cube_size*3, :] = faces[0] # +X
            combined[cube_size:cube_size*2, cube_size*3:cube_size*4, :] = faces[5] # -Z
            combined[cube_size*2:cube_size*3, cube_size:cube_size*2, :] = faces[3] # -Y

            fname = os.path.join(output_dir, f"cubemap_combined.png")
            Image.fromarray(combined, "RGB").save(fname)
            self.status.setText(f"合成图片保存完成: {fname}")
        except Exception as e:
            self.status.setText(f"合成导出失败: {e}")

if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    gui = CubeMapGUI()
    gui.show()
    sys.exit(app.exec_())