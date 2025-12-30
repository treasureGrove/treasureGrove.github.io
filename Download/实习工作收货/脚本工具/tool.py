import sys
import os
from PyQt6.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QHBoxLayout,
    QLabel, QLineEdit, QPushButton, QFileDialog,
    QTextEdit, QComboBox, QFrame
)
from PyQt6.QtGui import QPixmap, QFont, QPalette, QColor, QIcon, QPainter
from PyQt6.QtCore import Qt


class MikuApp(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("初音未来脚本工具箱")
        self.resize(960, 680)
        self.setWindowIcon(QIcon(MIKU_PNG if os.path.exists(MIKU_PNG) else BG_PIC))
        
        # 背景壁纸
        self.bg_pixmap = QPixmap(BG_PIC)
        
        main_layout = QHBoxLayout(self)
        main_layout.setContentsMargins(0,0,0,0)
        
        # 初音立绘
        if os.path.exists(MIKU_PNG):
            miku_label = QLabel()
            pix = QPixmap(MIKU_PNG).scaled(210, 510, Qt.AspectRatioMode.KeepAspectRatio, Qt.TransformationMode.SmoothTransformation)
            miku_label.setPixmap(pix)
            miku_label.setStyleSheet("background:transparent;")
            main_layout.addWidget(miku_label)
        else:
            main_layout.addSpacing(210)
        
        # 半透明主面板
        panel = QFrame()
        panel.setStyleSheet('''
            QFrame {
                background:rgba(255,255,255,0.80); 
                border-radius: 24px; 
                border: 2.5px solid #39c5bb;
                padding:16px
            }
        ''')
        main_layout.addWidget(panel)
        vlayout = QVBoxLayout(panel)
        
        # 标题
        title = QLabel("初音未来·二次元工具箱")
        font = QFont("霞鹜文楷等宽", 19, QFont.Weight.Bold)
        title.setFont(font)
        title.setStyleSheet('color: #39c5bb; text-shadow:2px 2px 4px #B6E3EE;')
        title.setAlignment(Qt.AlignmentFlag.AlignCenter)
        vlayout.addWidget(title)
        
        # 源/目标文件夹选择
        form_layout = QVBoxLayout()
        # 源文件夹
        row1 = QHBoxLayout()
        self.src_edit = QLineEdit()
        self.src_edit.setPlaceholderText("请选择源文件夹")
        row1.addWidget(QLabel("源路径："))
        row1.addWidget(self.src_edit)
        btn_src = QPushButton("选择")
        btn_src.setStyleSheet("background:#39c5bb;color:white;font-weight:bold;border-radius:10px;")
        btn_src.clicked.connect(self.select_src_folder)
        row1.addWidget(btn_src)
        form_layout.addLayout(row1)
        # 目标文件夹
        row2 = QHBoxLayout()
        self.dst_edit = QLineEdit()
        self.dst_edit.setPlaceholderText("请选择输出文件夹")
        row2.addWidget(QLabel("目标路径："))
        row2.addWidget(self.dst_edit)
        btn_dst = QPushButton("选择")
        btn_dst.setStyleSheet("background:#E3B6EE;color:#39C5BB;font-weight:bold;border-radius:10px;")
        btn_dst.clicked.connect(self.select_dst_folder)
        row2.addWidget(btn_dst)
        form_layout.addLayout(row2)
        vlayout.addLayout(form_layout)

        # 模式下拉框
        row3 = QHBoxLayout()
        row3.addWidget(QLabel("执行模式："))
        self.combo = QComboBox()
        self.combo.addItems(["分辨率统计", "贴图内存消耗", "Cube-to-Equi(HDR)"])
        self.combo.setStyleSheet("QComboBox {background:#b6e3ee;border-radius:8px;padding:2px 10px;color:#167e95;}")
        row3.addWidget(self.combo)
        vlayout.addLayout(row3)

        # 运行按钮
        btn_run = QPushButton("启动~♪")
        btn_run.setStyleSheet("background:#39c5bb;font-size:17px;color:white;font-weight:bold;border-radius:16px;padding:8px 30px;")
        btn_run.clicked.connect(self.run)
        vlayout.addWidget(btn_run, alignment=Qt.AlignmentFlag.AlignHCenter)
        vlayout.addSpacing(8)

        # LOG输出区
        log_title = QLabel("运行日志 Log：")
        log_title.setStyleSheet('color:#39C5BB')
        log_title.setFont(QFont("霞鹜文楷等宽", 13, QFont.Weight.Bold))
        vlayout.addWidget(log_title)
        self.log_edit = QTextEdit()
        self.log_edit.setStyleSheet(
            "background:rgba(255,255,255,0.83);border-radius:10px;font-size:13px;color:#21A8B0;")
        self.log_edit.setReadOnly(True)
        vlayout.addWidget(self.log_edit)

        vlayout.addStretch()

    def paintEvent(self, event):
        # 渲染背景
        painter = QPainter(self)
        painter.drawPixmap(self.rect(), self.bg_pixmap)
        super().paintEvent(event)

    def select_src_folder(self):
        path = QFileDialog.getExistingDirectory(self, "选择源文件夹")
        if path:
            self.src_edit.setText(path)
            self.log("已选择源目录: " + path)

    def select_dst_folder(self):
        path = QFileDialog.getExistingDirectory(self, "选择输出文件夹")
        if path:
            self.dst_edit.setText(path)
            self.log("已选择输出目录: " + path)

    def log(self, msg):
        self.log_edit.append(msg)
        self.log_edit.verticalScrollBar().setValue(self.log_edit.verticalScrollBar().maximum())

    def run(self):
        src, dst, mode = self.src_edit.text(), self.dst_edit.text(), self.combo.currentText()
        self.log("【初音启动】" + "模式: " + mode)
        # 下面把你的业务逻辑集成进来，例如解析、统计、输出文件等
        # 这里只是演示，建议将前面tkinter逻辑代码封装为函数后搬进来
        if not os.path.isdir(src):
            self.log("→ 请先选择【源文件夹】")
            return
        if not os.path.isdir(dst):
            self.log("→ 请先选择【输出文件夹】")
            return
        self.log("processing...")   # 业务处理代码放在这里
        # 运行后，log可实时输出进度和返回

if __name__ == '__main__':
    app = QApplication(sys.argv)
    miku = MikuApp()
    miku.show()
    sys.exit(app.exec())
