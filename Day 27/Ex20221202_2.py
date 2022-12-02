# DB 연결 실습

import sys
import pandas as pd
import pymysql as sql
from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *
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
        
        self.load_data()
        
        self.setLayout(layout)
        self.setWindowTitle("DB CONNECT PRACTICE")
        self.setGeometry(10, 30, 800, 650)
        self.show()
        
    def load_data(self):
        
        con = sql.Connect(host = '127.0.0.1', user = 'hana', password = 'bigdatar', db = 'work', charset = 'utf8')
        
        '''
        self.load_graph()
        
    def load_graph(self):
        
        self.fig_2.clear()
        
        self.canvas_2.draw()
        
   '''
    
if __name__ == '__main__' :
    app = QApplication(sys.argv)
    ex = MyApp()
    sys.exit(app.exec_())