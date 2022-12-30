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

class EventView(QDialog):
    
    def __init__(self) :
        
        super().__init__()
        self.initUI()
        
    def initUI(self):
        
        # 초기값 설정
        
        self.Qdate_one = QDate.currentDate()                        # 아무것도 선택 안하고 SEARCH 시 적용되는 기본값
        self.Qdate_two = QDate.currentDate()
        
        self.lbl_date = QLabel("!! SELECT DATE !!")                 # 선택한 날짜가 표시되는 라벨 기본 값
        self.lbl_date.setAlignment(Qt.AlignCenter)
        
        self.prb_loading = QProgressBar()                           # 데이터 로딩 상태를 표시하는 상태바
        
        # 레이아웃 설정
        
        layout_main = QHBoxLayout()                                 # 최상위 레이아웃
        
        layout_left = QVBoxLayout()                                 # 달력 -> 전체 그래프 -> 개별 예측치 그래프
        layout_right = QVBoxLayout()                                # 상태바 -> 버튼 -> 라벨 -> 로그
        
        layout_date = QHBoxLayout()                                 # 시작일 달력 -> 종료일 달력
        layout_graph_main = QVBoxLayout()                           # 전체 그래프
        layout_graph_sub = QGridLayout()                            # 예측치 그래프
        
        layout_btn = QVBoxLayout()                                  # 버튼
        layout_log = QVBoxLayout()                                  # 로그

        # 레이아웃에 추가
        
        layout_main.addLayout(layout_left, 5)
        layout_main.addLayout(layout_right, 1)
        
        layout_left.addLayout(layout_date, 1)
        layout_left.addLayout(layout_graph_main, 1.5)
        layout_left.addLayout(layout_graph_sub, 2)
        
        layout_right.addWidget(self.prb_loading)
        layout_right.addLayout(layout_btn)
        layout_right.addWidget(self.lbl_date)
        layout_right.addLayout(layout_log)
        
        # 위젯 생성
        
        self.date_one = QCalendarWidget(self)                       # 시작일 달력
        self.date_two = QCalendarWidget(self)                       # 종료일 달력

        self.date_one.setStyleSheet("selection-background-color: #5E8EE9")
        self.date_two.setStyleSheet("selection-background-color: #5E8EE9")
        
        self.date_one.setDateRange(QDate(2022, 12, 1), QDate.currentDate())
        self.date_two.setDateRange(QDate(2022, 12, 1), QDate.currentDate())
                                                                    # 달력 선택 가능 범위 설정        
        
        self.btn_search = QPushButton("SEARCH")                     # SEARCH 버튼
        self.btn_close = QPushButton("CLOSE")                       # CLOSE 버튼
        
        self.fig_main = pl.Figure(figsize = (4, 2))                 # 전체 그래프
        self.canv_main = FigureCanvas(self.fig_main)
                                                                    # 개별 그래프 ( 리스트 형태 )
        self.fig_tmp = [pl.Figure(figsize = (4, 2)) for i in range(6)]
        self.canv = [FigureCanvas(self.fig_tmp[i]) for i in range(6)]
        
        self.txt_log = QTextEdit("")                                # 로그

        self.btn_search.setStyleSheet("QPushButton\n"
                                                    "{\n"
                                                    "background-color: white;\n"
                                                    "border: 1px solid rgb(100, 100, 100);\n"
                                                    "color: #5E8EE9;\n"
                                                    "height: 30px;\n"
                                                    "}\n"
                                                 "QPushButton:hover\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "background-color: #5E8EE9;\n"
                                                    "border: 1px solid #5E8EE9;\n"
                                                    "}"
                                                    "QPushButton:pressed\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "border: 1px solid #3059a7;\n"
                                                    "background-color: #3059a7;\n"
                                                    "}")

        self.btn_close.setStyleSheet("QPushButton\n"
                                                    "{\n"
                                                    "background-color: white;\n"
                                                    "border: 1px solid rgb(100, 100, 100);\n"
                                                    "height: 30px;\n"
                                                    "color: #5E8EE9;\n"
                                                    "}\n"
                                                 "QPushButton:hover\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "background-color: #5E8EE9;\n"
                                                    "border: 1px solid #5E8EE9;\n"
                                                    "}"
                                                    "QPushButton:pressed\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "border: 1px solid #3059a7;\n"
                                                    "background-color: #3059a7;\n"
                                                    "}")

        self.txt_log.setStyleSheet("color : rgba(0, 89, 253, 200);" "font-weight: 400;")

        self.prb_loading.setStyleSheet("QProgressBar{\n"
                                        "    background-color: white;\n"
                                        "    color: black;\n"
                                        "    font-weight: 800;\n"
                                        "    text-align: center;\n"
                                        "}\n"
                                        "QProgressBar::chunk{\n"
                                        "    border: solid 2px rgba(20, 20, 20, 255);\n"
                                        "    background-color: qlineargradient(spread:pad, x1:0, y1:0.511364, x2:1, y2:0.523, stop:0 rgba(236, 179, 73, 255), stop:1 rgba(92, 142, 235, 255));\n"
                                        "}\n"
                                        "\n"
                                        "")
        
        # 레이아웃에 위젯 추가
        
        layout_date.addWidget(self.date_one)
        layout_date.addWidget(self.date_two)
        
        layout_btn.addWidget(self.btn_search)
        layout_btn.addWidget(self.btn_close)
        
        layout_graph_main.addWidget(self.canv_main)        
        
        layout_graph_sub.addWidget(self.canv[0], 0, 0)              # 개별 그래프 2행 3열
        layout_graph_sub.addWidget(self.canv[1], 0, 1)
        layout_graph_sub.addWidget(self.canv[2], 0, 2)
        layout_graph_sub.addWidget(self.canv[3], 1, 0)
        layout_graph_sub.addWidget(self.canv[4], 1, 1)
        layout_graph_sub.addWidget(self.canv[5], 1, 2)
        
        layout_log.addWidget(self.txt_log)
        
        # 위젯 이벤트 설정
        
        # self.date_one.selectionChanged.connect(self.date_selected)# 현재 선택중인 날짜 클릭 안됨 ( 오늘날짜를 선택시 다른날짜 선택 후 다시 선택해야 함 )
        # self.date_two.selectionChanged.connect(self.date_selected)
        
        self.date_one.clicked.connect(self.date_selected)           # 오늘날짜도 바로 선택 가능
        self.date_two.clicked.connect(self.date_selected)           # 달력 클릭시 date_selected 함수 실행 ( Qdate_one, Qdate_two 에 선택 날짜 값 부여 및 라벨 텍스트 변화 )
        
        self.btn_search.clicked.connect(self.search)                # 버튼 클릭시 search 함수 실행 ( 데이터 로딩, 예측값 추출, 그래프 그리기 )
        self.btn_close.clicked.connect(self.btn_reject)             # 버튼 클릭시 btn_reject 함수 실행 ( 창 닫기 )
        
        # 윈도우 설정
        
        self.setLayout(layout_main)                                 # 레이아웃 셋팅
        self.setWindowTitle('Event Viewer')                         # 창 이름
        self.setGeometry(0, 30, 1200, 900)                          # 창 크기
        self.show()                                                 # 창 표시
        
    def search(self):

        if (self.Qdate_one == self.Qdate_two == QDate.currentDate()): self.lbl_date.setText(f"{self.Qdate_one.toString('yyyy-MM-dd')} ~ {self.Qdate_two.toString('yyyy-MM-dd')}")
        
        if self.Qdate_two < self.Qdate_one:
            
            self.Qdate_one, self.Qdate_two = self.Qdate_two, self.Qdate_one
            self.lbl_date.setText(f"{self.Qdate_one.toString('yyyy-MM-dd')} ~ {self.Qdate_two.toString('yyyy-MM-dd')}")
            
        self.data_loading()
        self.data_processing()
        self.main_graph()
        
        for i in range(6): self.sub_graph(i)
        
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
            
        query = f"SELECT * FROM TMP_DATA WHERE DATE(S_TIME) >= '{self.Qdate_one.toString('yyyy-MM-dd')}' AND DATE(S_TIME) <= '{self.Qdate_two.toString('yyyy-MM-dd')}' ORDER BY S_TIME DESC;"
        
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
        
        self.prb_loading.setValue(0)
        
        for i in range(1, 7):
            
            self.model_pred(i)
            self.prb_loading.setValue(round(i/6 * 100,))
            
            if i == 6: self.prb_loading.setValue(100)
        
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
        lstm_model = tf.keras.models.load_model(f'Desktop/lstm_tmp{n}.h5')
        
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

        ax.plot(tmp1, label='TMP1', color = '#939CAE')
        ax.plot(tmp2, label='TMP2', color = '#EBB34A')
        ax.plot(tmp3, label='TMP3', color = '#CFAC6A')
        ax.plot(tmp4, label='TMP4', color = '#B2A48B')
        ax.plot(tmp5, label='TMP5', color = '#5E8EE9')
        ax.plot(tmp6, label='TMP6', color = '#7D96C6')

        ax.set_ylim(20, 37)
        ax.tick_params(axis = 'both', labelsize = 6.5)

        ax.legend(fontsize = 8, ncols = 6, loc = 'upper center')
        
        self.canv_main.draw()
        
    def sub_graph(self, n):                         # 예측치와 관측치 그리기
        
        self.fig_tmp[n].clear()
        
        ax = self.fig_tmp[n].add_subplot(111)
        ax.clear()
        
        df = [i[n + 1] for i in self.df]
        
        ax.plot(self.t_tmp[n][10: , 0], label = f'TMP{n+1}', color = '#EBB34A')
        ax.plot(self.pred_tmp[n], label = 'PRED', color = '#5E8EE9')
        
        ax.legend(fontsize = 8)
        ax.set_title(f'TMP{n+1}', fontsize = 8)

        ax.tick_params(axis = 'both', labelsize = 6.5)
        
        self.canv[n].draw()
    
    def btn_reject(self):
        
        self.reject()
        
    def date_selected(self):
        
        if self.sender() == self.date_one:
            
            self.Qdate_one = self.date_one.selectedDate()
            
            if self.Qdate_two == QDate.currentDate(): self.lbl_date.setText(f"{self.Qdate_one.toString('yyyy-MM-dd')} ~ {QDate.currentDate().toString('yyyy-MM-dd')}")
            else: self.lbl_date.setText(f"{self.Qdate_one.toString('yyyy-MM-dd')} ~ {self.Qdate_two.toString('yyyy-MM-dd')}")
                
            
        elif self.sender() == self.date_two:
            
            self.Qdate_two = self.date_two.selectedDate()
            
            if self.Qdate_one == QDate.currentDate(): self.lbl_date.setText(f"{QDate.currentDate().toString('yyyy-MM-dd')} ~ {self.Qdate_two.toString('yyyy-MM-dd')}")
            else: self.lbl_date.setText(f"{self.Qdate_one.toString('yyyy-MM-dd')} ~ {self.Qdate_two.toString('yyyy-MM-dd')}")
        
    def showModal(self):
        
        return super().exec_()