import sys
import pymysql as sql
import numpy as np
import pandas as pd

from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *

import matplotlib.pyplot as pl
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

class EventView(QDialog):
    
    def __init__(self) :
        
        super().__init__()
        self.initUI()
        
    def initUI(self):
        
        # 초기값 설정
        
        self.Qdate_one = ""
        self.Qdate_two = ""
        
        self.lbl_date = QLabel("!! SELECT DATE !!")
        
        # 레이아웃 설정
        
        layout_main = QHBoxLayout()
        
        layout_left = QVBoxLayout()
        layout_right = QVBoxLayout()
        
        layout_date = QHBoxLayout()
        layout_graph_main = QVBoxLayout()
        layout_graph_sub = QGridLayout()
        
        layout_btn = QVBoxLayout()
        layout_log = QVBoxLayout()
        
        layout_main.addLayout(layout_left, 3)
        layout_main.addLayout(layout_right, 1)
        
        layout_left.addLayout(layout_date)
        layout_left.addLayout(layout_graph_main)
        layout_left.addLayout(layout_graph_sub)
        
        layout_right.addLayout(layout_btn)
        layout_right.addLayout(layout_log)
        
        # 위젯 생성
        
        self.date_one = QCalendarWidget(self)
        self.date_two = QCalendarWidget(self)
        
        self.date_one.setDateRange(QDate(2022, 12, 1), QDate.currentDate())
        self.date_two.setDateRange(QDate(2022, 12, 1), QDate.currentDate())        
        
        self.btn_search = QPushButton("SEARCH")
        self.btn_close = QPushButton("CLOSE")
        
        self.fig_main = pl.Figure(figsize = (5, 3))
        self.canv_main = FigureCanvas(self.fig_main)
        
        self.fig_tmp = [pl.Figure(figsize = (5, 3)) for i in range(6)]
        self.canv = [FigureCanvas(self.fig_tmp[i]) for i in range(6)]
        
        self.txt_log = QTextEdit("")
        
        # 레이아웃에 위젯 추가
        
        layout_date.addWidget(self.date_one)
        layout_date.addWidget(self.date_two)
        
        layout_btn.addWidget(self.btn_search)
        layout_btn.addWidget(self.btn_close)
        
        layout_graph_main.addWidget(self.canv_main)        
        
        layout_graph_sub.addWidget(self.canv[0], 0, 0)
        layout_graph_sub.addWidget(self.canv[1], 0, 1)
        layout_graph_sub.addWidget(self.canv[2], 0, 2)
        layout_graph_sub.addWidget(self.canv[3], 1, 0)
        layout_graph_sub.addWidget(self.canv[4], 1, 1)
        layout_graph_sub.addWidget(self.canv[5], 1, 2)
        
        layout_log.addWidget(self.txt_log)
        
        # 위젯 이벤트 설정
        
        self.date_one.selectionChanged.connect(self.date_selected)
        self.date_two.selectionChanged.connect(self.date_selected)
        
        self.btn_search.clicked.connect(self.search)
        self.btn_close.clicked.connect(self.btn_reject)
        
        # 윈도우 설정
        
        self.setLayout(layout_main)
        self.setWindowTitle('Event Viewer')
        self.setGeometry(0, 30, 1000, 800)
        self.show()
        
    def search(self):
        
        self.data_loading()
        self.data_processing()
    
    def data_loading(self):                         # 데이터 불러오기
        
        # DB 연결
        
        con = sql.connect(host = "127.0.0.1", user = "root", password = "bigdatar", db = "bigdata_tmp", charset = "utf8")
        cmd = con.cursor()
        
        if self.lbl_date == "!! SELECT DATE !!":
            
            QMessageBox.about(self, "WARNING", "SELECT DATE FROM CALENDER!")
            
        else: query = f"SELECT * FROM TMP_DATA WHERE DATE(S_TIME) >= '{self.date_one}' AND DATE(S_TIME) <= '{self.date_two}' ORDER BY S_TIME DESC;"
        
        cmd.execute(query)
        self.data = cmd.fetchall()
        self.nrow = cmd.rowcount
        
        con.close()
    
    def data_processing(self):                      # 데이터 정제 및 로그 작성
        
        # 불러온 데이터 리스트로 저장
        
        self.df = [[0] * 7 for i in range(self.nrow)]
        
        cnt = 0
        
        for i in self.data:
            
            for j in range(7): self.df[cnt][j] = i[j]
            cnt += 1
        
        # 로그에 표시할 데이터를 문자열로
        
        log_tmp1 = 'TMP1 : %f' % (self.df[0][1])
        log_tmp2 = 'TMP2 : %f' % (self.df[0][2])
        log_tmp3 = 'TMP3 : %f' % (self.df[0][3])
        log_tmp4 = 'TMP4 : %f' % (self.df[0][4])
        log_tmp5 = 'TMP5 : %f' % (self.df[0][5])
        log_tmp6 = 'TMP6 : %f' % (self.df[0][6])
        
        # 로그 창에 추가 표시
        
        self.txt_log.append("")
        self.txt_log.append(str(self.df[0][0]))
        self.txt_log.append("")
        self.txt_log.append(log_tmp1)
        self.txt_log.append(log_tmp2)
        self.txt_log.append(log_tmp3)
        self.txt_log.append(log_tmp4)
        self.txt_log.append(log_tmp5)
        self.txt_log.append(log_tmp6)
        self.txt_log.append("")
        
        # 미리 훈련된 모델을 통한 예측치 추출
        
        self.pred_tmp = [0, 0, 0, 0, 0, 0]
        self.t_tmp = [0, 0, 0, 0, 0, 0]
        
        for i in range(1, 7): self.model_pred(i)
        
    def model_pred(self, n):
        
        df = [i[n] for i in self.df[0:60]]
        df = np.array(df)
        df = df.reshape(-1, 1)
        
        t_df = df[0: , : ]
        self.t_tmp[n - 1] = t_df
        
        s_tool = MMS(feature_range = (0, 1))
        s_df = s_tool.fit_transform(df)
        
        xte = self.get_data_x(s_df, 0, s_df.shape[0] - 1, 10)
        yte = self.get_data_y(s_df, 0, s_df.shape[0] - 1, 10) 
        lstm_model = tf.keras.models.load_model(f'./lstm_tmp{n}.h5')
        
        self.pred_tmp[n - 1] = lstm_model.predict(xte)
        self.pred_tmp[n - 1] = s_tool.inverse_transform(self.pred_tmp[n - 1])
        
        mape = np.mean(np.abs(t_df[10: ] - self.pred_tmp[n - 1]) / t_df[10: ]) * 100
        mape = f'TMP{n} MAPE : {mape:.3f}%'
        
        self.txt_log.append(mape)
        
    def main_graph(self):                           # 메인 그래프 그리기
        
        self.fig_main.clear()
        
        ax = self.fig_main.add_subplot(111)
        ax.clear()
        
        tmp1 = [i[1] for i in self.df]
        tmp2 = [i[2] for i in self.df]
        tmp3 = [i[3] for i in self.df]
        tmp4 = [i[4] for i in self.df]
        tmp5 = [i[5] for i in self.df]
        tmp6 = [i[6] for i in self.df]


        ax.plot(tmp1, label='TMP1')
        ax.plot(tmp2, label='TMP2')
        ax.plot(tmp3, label='TMP3')
        ax.plot(tmp4, label='TMP4')
        ax.plot(tmp5, label='TMP5')
        ax.plot(tmp6, label='TMP6')

        ax.legend()
        
        self.canv_main.draw()
        
    def sub_graph(self, n):                         # 예측치와 관측치 그리기
        
        self.fig_tmp[n].clear()
        
        ax = self.fig_tmp[n].add_subplot(111)
        ax.clear()
        
        df = [i[n + 1] for i in self.df]
        
        ax.plot(self.t_tmp[n][10: , 0], label = f'TMP{n+1}')
        ax.plot(self.pred_tmp[n], label = 'PRED')
        
        ax.legend()
        ax.set_title(f'TMP{n+1}')
        
        self.canv[n].draw()
    
    def btn_reject(self):
        
        self.reject()
        
    def date_selected(self):
        
        if self.sender() == self.date_one:
            
            self.Qdate_one = self.date_one.selectedDate()
            
            if self.Qdate_two == "": self.date_two.setDateRange(self.Qdate_one, QDate.currentDate())
            else:
                
                self.date_two.setDateRange(self.Qdate_one, self.Qdate_two)
                self.lbl_date.setText(f"{self.Qdate_one.toString('yyyy-MM-dd')} ~ {self.Qdate_two.toString('yyyy-MM-dd')}")
                
            
        elif self.sender() == self.date_two:
            
            self.Qdate_two = self.date_two.selectedDate()
            
            if self.Qdate_one == "": self.date_one.setDateRange(QDate(2022, 12, 1), self.Qdate_two)
            else:
                
                self.date_one.setDateRange(self.Qdate_one, self.Qdate_two)
                self.lbl_date.setText(f"{self.Qdate_one.toString('yyyy-MM-dd')} ~ {self.Qdate_two.toString('yyyy-MM-dd')}")
        
    def showModal(self):
        
        return super().exec_()