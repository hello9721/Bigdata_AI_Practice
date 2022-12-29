import sys
import pymysql as sql
import numpy as np
import pandas as pd

from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *

import matplotlib.pyplot as pl
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

import tensorflow as tf
import tensorflow.keras as keras
from sklearn.preprocessing import MinMaxScaler as MMS
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import SimpleRNN, LSTM, GRU, Dropout, Dense

from SubWindow import DateSelect
from EventWindow import EventView

class MainWindow(QWidget) :                 # 클래스 정의

    def __init__(self) :
        
        super().__init__()
        self.initUI()
        
    def initUI(self) :                      # 윈도우 환경 구성
    
        # DB 연결 및 데이터 로딩
        
        self.search_mode = False        
        
        self.data_loading()
    
        ### 레이아웃 설정    
    
        layout_main = QHBoxLayout()
        
        layout_left = QVBoxLayout()
        layout_right = QGridLayout()
        
        # 왼쪽 레이아웃
        
        layout_btn = QGridLayout()
        layout_tbl_log = QHBoxLayout()
        layout_grph = QVBoxLayout()
        
        # 오른쪽 레이아웃
        
        layout_tmp1 = QVBoxLayout()
        layout_tmp2 = QVBoxLayout()
        layout_tmp3 = QVBoxLayout()
        layout_tmp4 = QVBoxLayout()
        layout_tmp5 = QVBoxLayout()
        layout_tmp6 = QVBoxLayout()
        
        # 레이아웃 추가
        
        layout_main.addLayout(layout_left)
        layout_main.addLayout(layout_right)
        
        layout_left.addLayout(layout_btn)
        layout_left.addLayout(layout_tbl_log)
        layout_left.addLayout(layout_grph)
        
        layout_right.addLayout(layout_tmp1, 0, 0)
        layout_right.addLayout(layout_tmp2, 0, 1)
        layout_right.addLayout(layout_tmp3, 1, 0)
        layout_right.addLayout(layout_tmp4, 1, 1)
        layout_right.addLayout(layout_tmp5, 2, 0)
        layout_right.addLayout(layout_tmp6, 2, 1)
        
        # 버튼 위젯 구성        
        # 레이아웃에 추가
        # 버튼 이벤트 추가
        
        btn_title = [["AUTO UPDATE", "DATE SELECT", "SEARCH", "EVENT"], ["REGRESSION", "SETTING", "MODEL SETTING", "EXPORT"]]
        
        self.btn_menu = []
        cnt = 0
        
        for i in range(2):
            for j in range(4):
                
                temp = QPushButton(btn_title[i][j])
                self.btn_menu.append(temp)
                
                layout_btn.addWidget(self.btn_menu[cnt], i, j)
                
                self.btn_menu[cnt].clicked.connect(self.btn_clicked)
                cnt += 1
                
        self.btn_menu[2].setEnabled(False)
        
        # 테이블과 텍스트 위젯 구성
        
        self.tbl_tmp = QTableWidget(self.nrow, 7)
        self.tbl_tmp.setStyleSheet("font-size : 12pt;")
        self.tbl_tmp.setColumnWidth(0, 200)
        
        self.txt_log = QTextEdit()
        self.txt_log.setAcceptRichText(True)
        self.txt_log.setReadOnly(True)
        self.txt_log.setStyleSheet("font-size : 12pt;" "color : blue;")
        
        # 레이아웃에 추가
        
        layout_tbl_log.addWidget(self.tbl_tmp, 3)
        layout_tbl_log.addWidget(self.txt_log, 1)
        
        # 메인 그래프 위젯 구성
        
        self.fig_main = pl.Figure(figsize = (5, 3))
        self.canv_main = FigureCanvas(self.fig_main)
        
        # 레이아웃에 추가
        
        layout_grph.addWidget(self.canv_main)
        
        # 오른쪽 그래프 위젯 구성
        
        self.fig_tmp = [pl.Figure(figsize = (5, 3)) for i in range(6)]
        self.canv = [FigureCanvas(self.fig_tmp[i]) for i in range(6)]
        
        #for i in range(6):
            
        #    self.fig_tmp[i] = pl.Figure(figsize = (5, 3))    
        #    self.canv[i] = FigureCanvas(self.fig_tmp[i])
        
        # 레이아웃에 추가
        
        layout_tmp1.addWidget(self.canv[0])
        layout_tmp2.addWidget(self.canv[1])
        layout_tmp3.addWidget(self.canv[2])
        layout_tmp4.addWidget(self.canv[3])
        layout_tmp5.addWidget(self.canv[4])
        layout_tmp6.addWidget(self.canv[5])
        
        # 타이머 제어 추가
        
        self.timer = QTimer(self)
        self.timer.setInterval(60000)
        self.timer.timeout.connect(self.timeout)
        
        self.btn_clicked()
        
        # 윈도우 설정
        
        self.setLayout(layout_main)
        self.setWindowTitle('Temp Monitor')
        self.setGeometry(0, 30, 1900, 1000)
        self.show()
        
    def btn_clicked(self):                          # 버튼 클릭 시
        
        if self.sender() == self.btn_menu[0]:
            
            self.timeout()            
            self.timer.start()
            
            self.txt_log.append("")
            self.txt_log.append("< ==== AUTO MODE ==== >")
            self.txt_log.append("")
            
            self.search_mode = False
            
            self.btn_menu[0].setEnabled(False)
            self.btn_menu[2].setEnabled(False)
                
        elif self.sender() == self.btn_menu[1]:
            
            dialog_open = DateSelect()
            re = dialog_open.showModal()
            
            if re:
                
                self.date_one = dialog_open.lbl_one.text()
                self.date_two = dialog_open.lbl_two.text()
                
                self.btn_menu[0].setEnabled(False)
                self.btn_menu[2].setEnabled(True)
                
                if (self.date_one == "")|(self.date_two == ""):
                    
                    self.btn_menu[0].setEnabled(True)
                    self.btn_menu[2].setEnabled(False)
                
            else:
                
                self.btn_menu[0].setEnabled(True)
                self.btn_menu[2].setEnabled(False)
            
                
        elif self.sender() == self.btn_menu[2]:
            
            self.timer.stop()
            
            self.btn_menu[0].setEnabled(True)
            self.btn_menu[2].setEnabled(False)
            
            self.txt_log.append("")
            self.txt_log.append("< ==== SEARCH MODE ==== >")
            self.txt_log.append("")
            
            self.search_mode = True
            self.timeout()
        
        elif self.sender() == self.btn_menu[3]:
            
            dialog_open = EventView()
            re = dialog_open.showModal()
        
        elif self.sender() == self.btn_menu[4]:
            
            pass
        
        elif self.sender() == self.btn_menu[5]:
            
            pass
        
        elif self.sender() == self.btn_menu[6]:
            
            pass
        
        elif self.sender() == self.btn_menu[7]:
            
            pass
        
        else: 
            
            self.timeout()            
            self.timer.start()
            
            self.txt_log.append("")
            self.txt_log.append("< ==== AUTO MODE ==== >")
            self.txt_log.append("")
            
            self.search_mode = False
            
            self.btn_menu[0].setEnabled(False)
            self.btn_menu[2].setEnabled(False)
        
    def get_data_x(self, item, start, to, size):    # 데이터를 원하는 형태로 반환
    
        lst = []
        
        for i in range(start, to - (size - 1)) : lst.append(item[i:i + size, 0])
        
        result = np.array(lst)
        result = np.reshape(result, (result.shape[0], result.shape[1], 1))
        
        return result 
        
    def get_data_y(self, item, start, to, size):
        
        lst = []
        
        for i in range(start + size, to + 1) : lst.append(item[i, 0])
        
        result = np.array(lst)
        
        return result
    
    def data_loading(self):                         # 데이터 불러오기
        
        # DB 연결
        
        con = sql.connect(host = "127.0.0.1", user = "root", password = "bigdatar", db = "bigdata_tmp", charset = "utf8")
        cmd = con.cursor()
        
        if self.search_mode:
            
            query = f"SELECT * FROM TMP_DATA WHERE DATE(S_TIME) >= '{self.date_one}' AND DATE(S_TIME) <= '{self.date_two}' ORDER BY S_TIME DESC;"
            
        else: query = "SELECT * FROM TMP_DATA ORDER BY S_TIME DESC;"
        
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
        
    def tbl_setting(self):                          # 데이터를 테이블에 표시
    
        self.tbl_tmp.clear()
        
        col_name = ['Date', 'Temp1','Temp2','Temp3','Temp4','Temp5','Temp6']
        
        self.tbl_tmp.setHorizontalHeaderLabels(col_name)
        
        for i in range(self.nrow):
            for j in range(7): self.tbl_tmp.setItem(i, j, QTableWidgetItem(str(self.df[i][j])))
            
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
        
    def timeout(self):
        
        self.data_loading()
        self.data_processing()
        self.tbl_setting()
        self.main_graph()
        
        for i in range(6): self.sub_graph(i)
        
        
if __name__ == '__main__' :
    
    app = QApplication(sys.argv)
    ex = MainWindow()
    sys.exit(app.exec_())