def estimate_mesh_memory(face_count, vertex_size=32, index_size=2, vertex_share_factor=0.7):
    """
    face_count: 三角面总数（int）
    vertex_size: 每个顶点字节数，默认为32（常见：位置+法线+UV）
    index_size: 每个索引字节数，默认为2（16位无符号）
    vertex_share_factor: 顶点共用经验因子 [0~1]，默认0.7    
    """
    total_triangle_vertices = face_count * 3
    estimated_vertex_count = int(total_triangle_vertices * vertex_share_factor)
    vertex_mem = estimated_vertex_count * vertex_size
    index_mem = face_count * 3 * index_size

    total_mb = (vertex_mem + index_mem) / (1024 * 1024)
    print(f"面数: {face_count}")
    print(f"估算顶点数: {estimated_vertex_count}")
    print(f"顶点数据: {vertex_mem / 1024:.2f} KB")
    print(f"索引数据: {index_mem / 1024:.2f} KB")
    print(f"总消耗: {total_mb:.2f} MB")
    return total_mb

# 用法示例
if __name__ == "__main__":
    face_count = int(input("请输入三角面数量: "))
    estimate_mesh_memory(face_count)