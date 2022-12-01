# 와인 데이터셋 분류

import sys

import numpy as np
import pandas as pd

from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *

import matplotlib.pyplot as pl
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

class MyApp(QWidget) :
    
    def __init__(self) :
        
        super().__init__()
        
        self.load_data()
        
        self.row = 100
        self.col = self.rw_data.shape[1]
        self.row_name = self.rw_data.index
        self.col_name = self.rw_data.columns
        self.col_head = list(self.col_name)
        
        for i in range(self.col):
            
            self.col_head[i] = self.col_head[i].upper()
        
        self.initUI()
        
    def initUI(self) :
    
        layout = QHBoxLayout()
        
        lo_left = QVBoxLayout()
        lo_right = QVBoxLayout()
        
        lo_1 = QHBoxLayout()
        lo_2 = QVBoxLayout()
        lo_3 = QHBoxLayout()
        lo_4 = QVBoxLayout()
        
        layout.addLayout(lo_left)
        layout.addLayout(lo_right)
        lo_left.addLayout(lo_1)
        lo_left.addLayout(lo_2)
        lo_right.addLayout(lo_3)
        lo_right.addLayout(lo_4)
        
        self.rdo_1_1 = QRadioButton('Red Wine')
        self.rdo_1_2 = QRadioButton('White Wine')
        
        self.rdo_1_1.clicked.connect(self.radio_checked)
        self.rdo_1_2.clicked.connect(self.radio_checked)
        
        lo_1.addWidget(self.rdo_1_1)
        lo_1.addWidget(self.rdo_1_2)
        
        self.tbl_2 = QTableWidget(self.row, self.col)
        self.tbl_2.setHorizontalHeaderLabels(self.col_head)
        # self.tbl_2.setColumnWidth(0, 150)
        
        lo_2.addWidget(self.tbl_2)
        
        self.rdo_3_1 = QRadioButton('GraphType 01')
        self.rdo_3_2 = QRadioButton('GraphType 02')
        self.rdo_3_3 = QRadioButton('GraphType 03')
        
        self.rdo_3_1.clicked.connect(self.graph_checked)
        self.rdo_3_2.clicked.connect(self.graph_checked)
        self.rdo_3_3.clicked.connect(self.graph_checked)
        
        lo_3.addWidget(self.rdo_3_1)
        lo_3.addWidget(self.rdo_3_2)
        lo_3.addWidget(self.rdo_3_3)
        
        self.fig_4 = pl.Figure()  
        self.canvas_4 = FigureCanvas(self.fig_4)
        
        lo_4.addWidget(self.canvas_4)

        self.setLayout(layout)
        self.setWindowTitle('MyWindow')
        self.setGeometry(10, 30, 1312, 500)
        self.show()
        
    def load_data(self):
        
        self.rw_data = pd.read_csv("http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv", sep = ";")
        
        self.rw_data = self.rw_data.loc[ : ,['fixed acidity', 'citric acid', 'residual sugar', 'chlorides', 'density', 'pH', 'alcohol', 'quality']]
        
        self.ww_data = pd.read_csv("http://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv", sep = ";")
        
        self.ww_data = self.ww_data.loc[ : ,['fixed acidity', 'citric acid', 'residual sugar', 'chlorides', 'density', 'pH', 'alcohol', 'quality']]
        
    def radio_checked(self):
        
        if self.rdo_1_1.isChecked():
            
            self.row = self.rw_data.shape[0]
            self.tbl_2.setRowCount(self.row)
            
            self.wine_data(self.rw_data)
            
        else:
            
            self.row = self.ww_data.shape[0]
            self.tbl_2.setRowCount(self.row)
            
            self.wine_data(self.ww_data)
        
    def reset_list(self):
        
        # 'fixed acidity', 'citric acid', 'residual sugar', 'chlorides', 'density', 'pH', 'alcohol', 'quality'
        
        self.df_fa = []
        self.df_ca = []
        self.df_sugar = []
        self.df_chlo = []
        self.df_dens = []
        self.df_ph = []
        self.df_alcohol = []
        self.df_qual = []
            
    def wine_data(self, df):
        
        self.reset_list()
        
        for i in range(self.row):
            
            for j in range(self.col):
                
                temp = df.loc[self.row_name[i], self.col_name[j]]
                
                self.tbl_2.setItem(i, j, QTableWidgetItem(str(float(temp))))
                
            self.df_fa.append(df.loc[self.row_name[i], 'fixed acidity'])
            self.df_ca.append(df.loc[self.row_name[i], 'citric acid'])
            self.df_sugar.append(df.loc[self.row_name[i], 'residual sugar'])
            self.df_dens.append(df.loc[self.row_name[i], 'density'])
            self.df_ph.append(df.loc[self.row_name[i], 'pH'])
            self.df_alcohol.append(df.loc[self.row_name[i], 'alcohol'])
            self.df_qual.append(df.loc[self.row_name[i], 'quality'])
        
                
    def graph_checked(self):
        
        if self.rdo_3_1.isChecked(): self.graph_1()
        elif self.rdo_3_2.isChecked(): self.graph_2()
        else: self.graph_3()
            
                
    def graph_1(self):
        
        self.fig_4.clear()
        
        ax_1 = self.fig_4.add_subplot(211)
        ax_1.clear()
        
        ax_1.plot(self.df_fa, self.df_ca, 'ro', label='citric acid')
        ax_1.set_title('fixed acidity')
        
        ax_1.legend()
        
        ax_2 = self.fig_4.add_subplot(212)
        ax_2.clear()
        
        ax_2.plot(self.df_fa, self.df_ph, 'bo', label='pH')
        
        ax_2.legend()
        
        self.canvas_4.draw()
        
    def graph_2(self):
        
        self.fig_4.clear()
        
        ax_1 = self.fig_4.add_subplot(211)
        ax_1.clear()
        
        ax_1.plot(self.df_alcohol, self.df_ph, 'ro', label='ph')
        ax_1.set_title('alcohol')
        
        ax_1.legend()
        
        ax_2 = self.fig_4.add_subplot(212)
        ax_2.clear()
        
        ax_2.plot(self.df_alcohol, self.df_fa, 'bo', label='fixed acidity')
        ax_2.set_title('alcohol')
        
        ax_2.legend()
        
        self.canvas_4.draw()
        
    def graph_3(self):
        
        self.fig_4.clear()
        
        ax = self.fig_4.add_subplot(111)
        ax.clear()
        
        ax.plot(self.df_dens, self.df_sugar, 'mo', label='sugar')
        ax.plot(self.df_dens, self.df_ph, 'yo', label='pH')
        ax.plot(self.df_dens, self.df_qual, 'go', label='density')
        
        ax.legend()
        
        self.canvas_4.draw()
        
        
if __name__ == '__main__' :
    
    app = QApplication(sys.argv)
    ex = MyApp()
    sys.exit(app.exec_())