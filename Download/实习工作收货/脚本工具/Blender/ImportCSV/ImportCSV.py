bl_info = {
    "name": "Import Mesh from CSV",
    "author": "treasureGrove",
    "version": (1, 0, 0),
    "blender": (4, 0, 0),
    "location": "File > Import > CSV Mesh",
    "category": "Import-Export"
}

import bpy
import csv
import os
from bpy_extras.io_utils import ImportHelper
from mathutils import Vector
import re

csv_headers_cache = []

def get_column_prefixes(headers):
    prefixes = set()
    pattern = re.compile(r"^(.*?)[.\s_-]?[xyzuvrgba]$", re.I)
    for h in headers:
        m = pattern.match(h.lower().strip())
        if m:
            prefixes.add(m.group(1))
    return sorted(list(prefixes))

def get_enum_prefix_items(self, context):
    prefixes = ["(None/Ignore)"] + get_column_prefixes(csv_headers_cache)
    return [(p, p, "") for p in prefixes]

def suggest_prefix(choices, available):
    for c in choices:
        if c in available:
            return c
    return "(None/Ignore)"

# ------------------ 前缀选择弹窗 ---------------------------------
class CSVMeshPrefixFieldDialog(bpy.types.Operator):
    bl_idname = "import_mesh.csv_mesh_prefix_field_dialog"
    bl_label = "选择每组属性前缀 (Select prefix for attributes)"
    csv_path: bpy.props.StringProperty()

    pos_prefix: bpy.props.EnumProperty(
        name="Position 前缀",
        items=get_enum_prefix_items
    )
    nrm_prefix: bpy.props.EnumProperty(
        name="Normal 前缀",
        items=get_enum_prefix_items
    )
    color_prefix: bpy.props.EnumProperty(
        name="顶点色前缀 (可选)",
        items=get_enum_prefix_items
    )
    uv0_prefix: bpy.props.EnumProperty(
        name="UV0 前缀 (可选)",
        items=get_enum_prefix_items
    )
    uv1_prefix: bpy.props.EnumProperty(
        name="UV1 前缀 (可选)",
        items=get_enum_prefix_items
    )
    uv2_prefix: bpy.props.EnumProperty(
        name="UV2 前缀 (可选)",
        items=get_enum_prefix_items
    )

    def invoke(self, context, event):
        available = get_column_prefixes(csv_headers_cache)
        self.pos_prefix = suggest_prefix(["position", "pos", "attribute0"], available)
        self.nrm_prefix = suggest_prefix(["normal", "norm"], available)
        self.color_prefix = suggest_prefix(["color", "col"], available)
        self.uv0_prefix = suggest_prefix(["texcoord", "uv", "tex", "st"], available)
        self.uv1_prefix = suggest_prefix(["texcoord1", "uv1", "tex1", "st1"], available)
        self.uv2_prefix = suggest_prefix(["texcoord2", "uv2", "tex2", "st2"], available)
        return context.window_manager.invoke_props_dialog(self, width=400)

    def draw(self, context):
        layout = self.layout
        layout.label(text="选择每组属性对应的表头前缀")
        layout.prop(self, "pos_prefix")
        layout.prop(self, "nrm_prefix")
        layout.prop(self, "color_prefix")
        layout.prop(self, "uv0_prefix")
        layout.prop(self, "uv1_prefix")
        layout.prop(self, "uv2_prefix")

    def execute(self, context):
        if self.pos_prefix == "(None/Ignore)":
            self.report({'ERROR'}, "必须选择 Position 的列前缀 / Position column prefix required")
            return {'CANCELLED'}
        field_map = {
            "position": None if self.pos_prefix == "(None/Ignore)" else self.pos_prefix,
            "normal":   None if self.nrm_prefix == "(None/Ignore)" else self.nrm_prefix,
            "color":    None if self.color_prefix == "(None/Ignore)" else self.color_prefix,
            "uv0":      None if self.uv0_prefix == "(None/Ignore)" else self.uv0_prefix,
            "uv1":      None if self.uv1_prefix == "(None/Ignore)" else self.uv1_prefix,
            "uv2":      None if self.uv2_prefix == "(None/Ignore)" else self.uv2_prefix,
        }
        bpy.ops.import_mesh.csv_mesh_prefix_fields_run('INVOKE_DEFAULT', filepath=self.csv_path, field_map=str(field_map))
        return {'FINISHED'}

# ------------------ 实际导入操作 ----------------------------------------
class ImportCSVMeshPrefixFieldsRun(bpy.types.Operator):
    bl_idname = "import_mesh.csv_mesh_prefix_fields_run"
    bl_label = "Import CSV Mesh (.xyz fields by prefix)"
    bl_options = {'REGISTER', 'UNDO'}
    filepath: bpy.props.StringProperty(subtype='FILE_PATH')
    field_map: bpy.props.StringProperty()

    def execute(self, context):
        import ast
        field_map = ast.literal_eval(self.field_map)
        filepath = self.filepath
        with open(filepath, encoding="utf-8-sig") as f:
            reader = csv.reader(f)
            header = [h.strip() for h in next(reader)]

            def find_channels(prefix, components_list):
                if not prefix: return None
                prefix = prefix.lower()
                for components in components_list:
                    ch_map = {}
                    for c in components:
                        for idx, h in enumerate(header):
                            h0 = h.lower().replace(" ", "").replace("-", "").replace("", "")
                            if h0 == prefix + c: ch_map[c] = idx
                            elif h0 == prefix + "." + c: ch_map[c] = idx
                            elif h0 == prefix + "" + c: ch_map[c] = idx
                            elif h0 == prefix + "-" + c: ch_map[c] = idx
                            elif h0 == prefix + c.upper(): ch_map[c] = idx
                        if c not in ch_map:
                            for idx, h in enumerate(header):
                                if h.lower().endswith(c) and h.lower().startswith(prefix):
                                    ch_map[c] = idx
                    if all(k in ch_map for k in components):
                        return [ch_map[c] for c in components]
                return None

            pos_map    = find_channels(field_map.get("position"), [('x','y','z')]) if field_map.get("position") else None
            nrm_map    = find_channels(field_map.get("normal"),   [('x','y','z')]) if field_map.get("normal") else None
            color_map  = find_channels(field_map.get("color"), [('x','y','z','w'),('r','g','b','a')]) if field_map.get("color") else None
            uv0_map    = find_channels(field_map.get("uv0"), [('u','v'),('x','y')]) if field_map.get("uv0") else None
            uv1_map    = find_channels(field_map.get("uv1"), [('u','v'),('x','y')]) if field_map.get("uv1") else None
            uv2_map    = find_channels(field_map.get("uv2"), [('u','v'),('x','y')]) if field_map.get("uv2") else None

            if not pos_map:
                self.report({'ERROR'}, f"{os.path.basename(filepath)} 缺失 Position 的 x/y/z 三列，请检查表头命名 / Position x/y/z fields required")
                return {'CANCELLED'}

            positions, normals, colors, uvs0, uvs1, uvs2 = [], [], [], [], [], []

            for row in reader:
                px = float(row[pos_map[0]])
                py = float(row[pos_map[1]])
                pz = float(row[pos_map[2]])
                positions.append((px, py, pz))
                if nrm_map:
                    nx = float(row[nrm_map[0]])
                    ny = float(row[nrm_map[1]])
                    nz = float(row[nrm_map[2]])
                    normals.append((nx, ny, nz))
                if color_map:
                    r = float(row[color_map[0]])
                    g = float(row[color_map[1]])
                    b = float(row[color_map[2]])
                    a = float(row[color_map[3]]) if len(color_map) > 3 else 1.0
                    # Clamp values
                    colors.append((
                        max(0.0, min(r, 1.0)),
                        max(0.0, min(g, 1.0)),
                        max(0.0, min(b, 1.0)),
                        max(0.0, min(a, 1.0))
                    ))
                if uv0_map:
                    u = float(row[uv0_map[0]])
                    v = float(row[uv0_map[1]])
                    uvs0.append((u, 1-v))
                if uv1_map:
                    u = float(row[uv1_map[0]])
                    v = float(row[uv1_map[1]])
                    uvs1.append((u, 1-v))
                if uv2_map:
                    u = float(row[uv2_map[0]])
                    v = float(row[uv2_map[1]])
                    uvs2.append((u, 1-v))

            if len(positions) < 3:
                self.report({'ERROR'}, f"{os.path.basename(filepath)} Not enough vertices (need at least 3) / 至少需要3个顶点")
                return {'CANCELLED'}

            tris = [(i, i+1, i+2) for i in range(0, len(positions) - 2 + 1, 3)]
            mesh = bpy.data.meshes.new(os.path.basename(filepath))
            mesh.from_pydata(positions, [], tris)
            mesh.update()
            obj = bpy.data.objects.new(mesh.name, mesh)
            bpy.context.collection.objects.link(obj)
            bpy.context.view_layer.objects.active = obj
            obj.select_set(True)

            # UV0
            if uvs0 and len(uvs0) >= len(mesh.vertices):
                uv_layer0 = mesh.uv_layers.new(name="UVMap")
                for poly in mesh.polygons:
                    for loop_idx in poly.loop_indices:
                        v_idx = mesh.loops[loop_idx].vertex_index
                        uv_layer0.data[loop_idx].uv = uvs0[v_idx]
            # UV1
            if uvs1 and len(uvs1) >= len(mesh.vertices):
                uv_layer1 = mesh.uv_layers.new(name="UVMap.001")
                for poly in mesh.polygons:
                    for loop_idx in poly.loop_indices:
                        v_idx = mesh.loops[loop_idx].vertex_index
                        uv_layer1.data[loop_idx].uv = uvs1[v_idx]
            # UV2
            if uvs2 and len(uvs2) >= len(mesh.vertices):
                uv_layer2 = mesh.uv_layers.new(name="UVMap.002")
                for poly in mesh.polygons:
                    for loop_idx in poly.loop_indices:
                        v_idx = mesh.loops[loop_idx].vertex_index
                        uv_layer2.data[loop_idx].uv = uvs2[v_idx]
            # Normals
            if normals and len(normals) >= len(mesh.vertices):
                custom_normals = []
                for poly in mesh.polygons:
                    for loop_idx in poly.loop_indices:
                        vi = mesh.loops[loop_idx].vertex_index
                        n = Vector(normals[vi]).normalized()
                        custom_normals.append(n)
                mesh.normals_split_custom_set(custom_normals)
            # Vertex Color
            if colors and len(colors) >= len(mesh.vertices):
                color_layer = mesh.color_attributes.new("Col", 'FLOAT_COLOR', 'CORNER')
                for poly in mesh.polygons:
                    for loop_idx in poly.loop_indices:
                        v_idx = mesh.loops[loop_idx].vertex_index
                        col = colors[v_idx] if v_idx < len(colors) else (1.0, 1.0, 1.0, 1.0)
                        color_layer.data[loop_idx].color = col

            for poly in mesh.polygons:
                poly.use_smooth = True
            mesh.update()
            layer_info = [
                f"UV0:{'Y' if uvs0 else 'N'}",
                f"UV1:{'Y' if uvs1 else 'N'}",
                f"UV2:{'Y' if uvs2 else 'N'}",
                f"Color:{'Y' if colors else 'N'}"
            ]
            self.report({'INFO'}, f"{os.path.basename(filepath)} 导入成功: {len(mesh.vertices)} 顶点, {len(mesh.polygons)} 面, " + ", ".join(layer_info))
        return {'FINISHED'}

# ------------ 单文件入口（原始保留） ---------------
class ImportCSVMeshChoosePrefixFields(bpy.types.Operator, ImportHelper):
    bl_idname = "import_mesh.csv_mesh_choose_prefix_fields"
    bl_label = "Import CSV Mesh"
    filename_ext = ".csv"
    filter_glob: bpy.props.StringProperty(default="*.csv", options={'HIDDEN'})
    def execute(self, context):
        global csv_headers_cache
        filepath = self.filepath
        with open(filepath, encoding="utf-8-sig") as f:
            reader = csv.reader(f)
            header = next(reader)
            csv_headers_cache.clear()
            csv_headers_cache.extend(header)
            bpy.ops.import_mesh.csv_mesh_prefix_field_dialog('INVOKE_DEFAULT', csv_path=filepath)
        return {'FINISHED'}

# ----------- 批量导入弹窗与执行 ---------------
class CSVMeshBatchImportDialog(bpy.types.Operator, ImportHelper):
    bl_idname = "import_mesh.csv_mesh_batch_import_dialog"
    bl_label = "批量导入 CSV Mesh (Batch Import CSV Mesh)"
    filename_ext = ".csv"
    filter_glob: bpy.props.StringProperty(default="*.csv", options={'HIDDEN'})
    files: bpy.props.CollectionProperty(type=bpy.types.PropertyGroup)
    
    require_position: bpy.props.BoolProperty(name="Position", default=True)
    require_normal: bpy.props.BoolProperty(name="Normal", default=False)
    require_color: bpy.props.BoolProperty(name="Color", default=False)
    require_uv0: bpy.props.BoolProperty(name="UV0", default=False)
    require_uv1: bpy.props.BoolProperty(name="UV1", default=False)
    require_uv2: bpy.props.BoolProperty(name="UV2", default=False)

    def draw(self, context):
        layout = self.layout
        layout.label(text="勾选必需属性 (Select required attributes):")
        layout.prop(self, "require_position")
        layout.prop(self, "require_normal")
        layout.prop(self, "require_color")
        layout.prop(self, "require_uv0")
        layout.prop(self, "require_uv1")
        layout.prop(self, "require_uv2")

    def execute(self, context):
        required_fields = []
        if self.require_position: required_fields.append("position")
        if self.require_normal: required_fields.append("normal")
        if self.require_color: required_fields.append("color")
        if self.require_uv0: required_fields.append("uv0")
        if self.require_uv1: required_fields.append("uv1")
        if self.require_uv2: required_fields.append("uv2")
        folder = os.path.dirname(self.filepath)
        filenames = [file.name for file in self.files]
        failed_list = []
        for name in filenames:
            fpath = os.path.join(folder, name)
            if not os.path.exists(fpath): continue
            try:
                with open(fpath, encoding="utf-8-sig") as f:
                    reader = csv.reader(f)
                    headers = [h.strip() for h in next(reader)]
                    csv_headers_cache.clear()
                    csv_headers_cache.extend(headers)
                    prefixes = get_column_prefixes(csv_headers_cache)
                    auto_field_map = {
                        "position": suggest_prefix(["position", "pos", "attribute0"], prefixes),
                        "normal":   suggest_prefix(["normal", "norm"], prefixes),
                        "color":    suggest_prefix(["color", "col"], prefixes),
                        "uv0":      suggest_prefix(["texcoord", "uv", "tex", "st"], prefixes),
                        "uv1":      suggest_prefix(["texcoord1", "uv1", "tex1", "st1"], prefixes),
                        "uv2":      suggest_prefix(["texcoord2", "uv2", "tex2", "st2"], prefixes),
                    }
                    # 检查每个必选字段是否自动被识别
                    need_popup = False
                    for rf in required_fields:
                        if auto_field_map[rf] == "(None/Ignore)":
                            need_popup = True
                            break
                    if need_popup:
                        # 弹窗前缀选择
                        bpy.ops.import_mesh.csv_mesh_prefix_field_dialog('INVOKE_DEFAULT', csv_path=fpath)
                        failed_list.append(name)
                    else:
                        # 直接导入
                        bpy.ops.import_mesh.csv_mesh_prefix_fields_run('INVOKE_DEFAULT', filepath=fpath, field_map=str(auto_field_map))
            except Exception as e:
                print(f"Import batch error on {name}: {e}")
                failed_list.append(name)
        if failed_list:
            self.report({'WARNING'}, "已自动导入大部分文件。部分文件需手动选择前缀（请在弹窗中选择）：\n" + "\n".join(failed_list))
        else:
            self.report({'INFO'}, "批量导入完成 (Batch import finished)")
        return {'FINISHED'}

# 菜单入口
def menu_import(self, context):
    self.layout.operator(CSVMeshBatchImportDialog.bl_idname, text="CSV Mesh 批量导入")
    self.layout.operator(ImportCSVMeshChoosePrefixFields.bl_idname, text="CSV Mesh (单文件)")

def register():
    bpy.utils.register_class(CSVMeshPrefixFieldDialog)
    bpy.utils.register_class(ImportCSVMeshPrefixFieldsRun)
    bpy.utils.register_class(ImportCSVMeshChoosePrefixFields)
    bpy.utils.register_class(CSVMeshBatchImportDialog)
    bpy.types.TOPBAR_MT_file_import.append(menu_import)

def unregister():
    bpy.types.TOPBAR_MT_file_import.remove(menu_import)
    bpy.utils.unregister_class(CSVMeshPrefixFieldDialog)
    bpy.utils.unregister_class(ImportCSVMeshPrefixFieldsRun)
    bpy.utils.unregister_class(ImportCSVMeshChoosePrefixFields)
    bpy.utils.unregister_class(CSVMeshBatchImportDialog)

if __name__ == "__main__":
    register()