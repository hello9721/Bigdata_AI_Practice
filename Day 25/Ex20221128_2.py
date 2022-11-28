# -*- coding: utf-8 -*-
# Qt5 베이스 골격

import PyQt5.QtWidgets as wgs
# import PyQt5.QtGui as gui
# import PyQt5.QtCore as cor

import sys

class MyApp(wgs.QWidget):
    
    count = [0, 0, 0, 0, 0, 0]
    
    def __init__(self):
        
        super().__init__()
        self.initUI()
        
    def signal(self):
        
        sender = self.sender()
        text = sender.text()
        self.count[int(text)] += 1
        
        if self.count[int(text)] > 1: self.signal_twice(text)
        
        self.lbl1.setText(f'This is {text}')
        
    def signal_twice(self, num):
        
        wgs.QMessageBox.warning(self, '경고', f'{num} 을 {self.count[int(num)]} 번 눌렀습니다.')
        
    def initUI(self):
        
        self.btn1 = wgs.QPushButton("000")
        self.btn2 = wgs.QPushButton("001")
        self.btn3 = wgs.QPushButton("002")
        self.btn4 = wgs.QPushButton("003")
        self.btn5 = wgs.QPushButton("004")
        self.btn6 = wgs.QPushButton("005")
        
        self.btn1.clicked.connect(self.signal)
        self.btn2.clicked.connect(self.signal)
        self.btn3.clicked.connect(self.signal)
        self.btn4.clicked.connect(self.signal)
        self.btn5.clicked.connect(self.signal)
        self.btn6.clicked.connect(self.signal)
        
        self.lbl1 = wgs.QLabel('Who is this?')
        
        layout = wgs.QHBoxLayout()
        #layout = wgs.QVBoxLayout()
        
        lyo_left = wgs.QVBoxLayout()
        lyo_right = wgs.QVBoxLayout()
        
        left_top = wgs.QHBoxLayout()
        left_bottom = wgs.QVBoxLayout()
        
        layout.addLayout(lyo_left)
        layout.addLayout(lyo_right)
        
        lyo_left.addLayout(left_top)
        lyo_left.addLayout(left_bottom)
        
        left_top.addWidget(self.btn1)
        left_top.addWidget(self.btn2)
        left_bottom.addWidget(self.btn3)
        left_bottom.addWidget(self.btn4)
        
        lyo_right.addWidget(self.btn5)
        lyo_right.addWidget(self.btn6)
        lyo_right.addWidget(self.lbl1)
        
        self.setLayout(layout)
        self.setWindowTitle("MyWindow")
        self.setGeometry(10, 30, 200, 100)
        self.show()

if __name__ == '__main__':
              
    system = wgs.QApplication(sys.argv)
    
    app = MyApp()
    
    sys.exit(system.exec_())  
    
    