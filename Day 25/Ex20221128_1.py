# -*- coding: utf-8 -*-
# Qt5 베이스 골격

from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import sys

class MyApp(QWidget):
    
    def __init__(self):
        
        super().__init__()
        self.initUI()
        
    def initUI(self):
        
        self.btn1 = QPushButton("000")
        
        layout = QHBoxLayout()
        #layout = QVBoxLayout()
        
        layout.addWidget(self.btn1)
        
        self.setLayout(layout)
        self.setWindowTitle("MyWindow")
        self.setGeometry(10, 30, 600, 600)
        self.show()

if __name__ == '__main__':
              
    system = QApplication(sys.argv)
    
    app = MyApp()
    
    sys.exit(system.exec_())  
    
    