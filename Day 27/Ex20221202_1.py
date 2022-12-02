# 파일 다이얼로그 실습

import pandas as pd
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
import matplotlib.image as pim
import matplotlib.pyplot as pl
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

class MyApp(QWidget) :
    
    def __init__(self) :
        
        super().__init__()
        self.initUI()
        
    def initUI(self) :
    
        layout = QVBoxLayout()
        
        lo_top = QHBoxLayout()
        lo_mid = QHBoxLayout()
        lo_bot = QHBoxLayout()
        
        layout.addLayout(lo_top)
        layout.addLayout(lo_mid)
        layout.addLayout(lo_bot)
        
        self.txt_1 = QLineEdit()
        self.btn_1 = QPushButton("File Choose..")
        
        lo_top.addWidget(self.txt_1, stretch = 4)
        lo_top.addWidget(self.btn_1, stretch = 1)
        
        self.txt_1.setEnabled(False)
        self.txt_1.setAlignment(Qt.AlignCenter)
        self.btn_1.clicked.connect(self.load_data)
        
        self.lbl_2 = QLabel("")
        self.fig_2 = pl.Figure()
        self.canvas_2 = FigureCanvas(self.fig_2)
        
        lo_mid.addWidget(self.lbl_2)
        lo_mid.addWidget(self.canvas_2)
        
        self.setLayout(layout)
        self.setWindowTitle("FILE DIALOG PRACTICE")
        self.setGeometry(10, 30, 800, 650)
        self.show()
        
    def load_data(self):
        
        dir = QFileDialog.getOpenFileNames(self, "file choose..", filter = "Images (*.png *.jpg)")
        self.dir = dir[0][0]
        
        self.txt_1.setText(self.dir)
        
        self.load_img()
        
    def load_img(self):
        
        self.lbl_2.setPixmap(QPixmap(self.dir).scaledToHeight(500))
        
        self.load_graph()
        
    def load_graph(self):
        
        img = pim.imread(self.dir)
        
        self.fig_2.clear()
        ax = self.fig_2.add_subplot(111)
        ax.imshow(img)
        
        self.canvas_2.draw()
        
   
    
if __name__ == '__main__' :
    app = QApplication(sys.argv)
    ex = MyApp()
    sys.exit(app.exec_())