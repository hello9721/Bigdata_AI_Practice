import sys
import pymysql as sql
import numpy as np
import pandas as pd

from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *

import matplotlib.pyplot as pl
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

class DateSelect(QDialog):
    
    def __init__(self) :
        
        super().__init__()
        self.initUI()
        
    def initUI(self):
        
        # 레이아웃 설정
        
        layout_main = QVBoxLayout()
        
        layout_date = QHBoxLayout()
        layout_date_one = QVBoxLayout()
        layout_date_two = QVBoxLayout()
        
        layout_check = QHBoxLayout()
        
        layout_main.addLayout(layout_date)
        layout_main.addLayout(layout_check)
        
        layout_date.addLayout(layout_date_one)
        layout_date.addLayout(layout_date_two)
        
        # 위젯 설정
        
        self.date_one = QCalendarWidget(self)
        self.date_two = QCalendarWidget(self)
        
        self.date_one.setDateRange(QDate(2022, 12, 1), QDate.currentDate())
        self.date_two.setDateRange(QDate(2022, 12, 1), QDate.currentDate())
        
        self.lbl_one = QLabel("")
        self.lbl_two = QLabel("")
        
        self.lbl_one.setAlignment(Qt.AlignCenter)
        self.lbl_two.setAlignment(Qt.AlignCenter)
        
        self.btn_yes = QPushButton("Confirm")
        self.btn_no = QPushButton("Cancel")
        
        # 위젯 이벤트 설정
        
        self.date_one.selectionChanged.connect(self.date_selected)
        self.date_two.selectionChanged.connect(self.date_selected)
        
        self.btn_yes.clicked.connect(self.btn_confirm)
        self.btn_no.clicked.connect(self.btn_cancel)
        
        # 위젯 레이아웃 추가
        
        layout_date_one.addWidget(self.date_one)
        layout_date_one.addWidget(self.lbl_one)
        
        layout_date_two.addWidget(self.date_two)
        layout_date_two.addWidget(self.lbl_two)
        
        layout_check.addWidget(self.btn_yes)
        layout_check.addWidget(self.btn_no)
        
        # 윈도우 설정
        
        self.setLayout(layout_main)
        self.setWindowTitle('Date Selector')
        self.setGeometry(0, 30, 700, 300)
        self.show()
        
    def date_selected(self):
        
        if self.sender() == self.date_one:
            
            self.Qdate_one = self.date_one.selectedDate()
            
            date_one = self.Qdate_one.toString('yyyy-MM-dd')
            self.lbl_one.setText(date_one)
            
            if self.lbl_two.text() == "": self.date_two.setDateRange(self.Qdate_one, QDate.currentDate())
            else: self.date_two.setDateRange(self.Qdate_one, self.Qdate_two)
            
        elif self.sender() == self.date_two:
            
            self.Qdate_two = self.date_two.selectedDate()
            
            date_two = self.Qdate_two.toString('yyyy-MM-dd')
            self.lbl_two.setText(date_two)
            
            if self.lbl_one.text() == "": self.date_one.setDateRange(QDate(2022, 12, 1), self.Qdate_two)
            else: self.date_one.setDateRange(self.Qdate_one, self.Qdate_two)
        
    def btn_confirm(self):
        
        self.accept()                           # 다이얼로그 내용을 저장하여 전달
        
    def btn_cancel(self):
        
        self.reject()                           # 다이얼로그 내용 전달없이 종료
        
    def showModal(self):
        
        return super().exec_()