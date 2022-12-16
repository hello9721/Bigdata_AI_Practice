import sys
import pymysql
import numpy as np
import pandas as pd
import pyinstaller as pin

from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *

import matplotlib.pyplot as plt
from matplotlib import font_manager, rc
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

import tensorflow as tf
import tensorflow.keras as keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import SimpleRNN, LSTM, GRU, Dropout, Dense
from sklearn.preprocessing import MinMaxScaler

class MyApp(QWidget) :                  # 클래스 정의

    def __init__(self) :
        
        super().__init__()              # 부모클래스 생성자 호출(가장 위쪽 코딩)
        self.initUI()
        
    def initUI(self) :                  # 윈도우 환경 구성
    
        self.font_1 = font_manager.FontProperties(fname="c:/Windows/Fonts/malgun.ttf", size = 20)
        
        ### DB 연결
        
        self.conn = pymysql.connect(host='127.0.0.1' , user='root', password='bigdatar', db='vib', charset='utf8')
        self.cursor = self.conn.cursor()
        
        ### UI 구성
        
        self.btnOpen = QPushButton('LOAD')
        self.btnSave = QPushButton('SAVE')
        
        self.tblVibOrg = QTableWidget(1000, 4)
        col_head = ['Date', 'RmsX','RmsY','RmsZ']
        self.tblVibOrg.setHorizontalHeaderLabels(col_head)
        self.tblVibOrg.setStyleSheet("font-size : 12pt;")
        
        self.txtLog = QTextEdit()
        self.txtLog.setAcceptRichText(True)
        self.txtLog.setReadOnly(True)
        self.txtLog.setStyleSheet('font-size : 12pt;'
                                  'color : blue;')
        
        self.fig = plt.Figure(figsize=(6,6))        # 그래프 영역 변수 생성
        self.canvas = FigureCanvas(self.fig)        # 그래프 그리기 영역
        
        self.figX = plt.Figure(figsize=(7,3))
        self.figY = plt.Figure(figsize=(7,3))
        self.figZ = plt.Figure(figsize=(7,3))
        
        self.canvasX = FigureCanvas(self.figX)      # 그래프 그리기 영역
        self.canvasY = FigureCanvas(self.figY)      # 그래프 그리기 영역
        self.canvasZ = FigureCanvas(self.figZ)      # 그래프 그리기 영역
        

        layout = QHBoxLayout()                      # 상자 배치관리자(최상위)
        layoutMonitor = QVBoxLayout()
        layoutML = QVBoxLayout()
        
                                                    # 왼쪽 레이아웃
        layoutMenu = QHBoxLayout()
        layoutTbl = QHBoxLayout()
        layoutGraph = QVBoxLayout()
        
        layoutMenu.addWidget(self.btnOpen)
        layoutMenu.addWidget(self.btnSave)
        
        layoutTbl.addWidget(self.tblVibOrg)
        layoutTbl.addWidget(self.txtLog)
        layoutGraph.addWidget(self.canvas)
        
        layoutMonitor.addLayout(layoutMenu)
        layoutMonitor.addLayout(layoutTbl)
        layoutMonitor.addLayout(layoutGraph)
        
                                                    # 오른쪽 레이아웃
        layoutRmsX = QVBoxLayout()
        layoutRmsY = QVBoxLayout()
        layoutRmsZ = QVBoxLayout()
        
        layoutRmsX.addWidget(self.canvasX)
        layoutRmsY.addWidget(self.canvasY)
        layoutRmsZ.addWidget(self.canvasZ)
        
        layoutML.addLayout(layoutRmsX)
        layoutML.addLayout(layoutRmsY)
        layoutML.addLayout(layoutRmsZ)
        
        layout.addLayout(layoutMonitor)
        layout.addLayout(layoutML)
        
        self.setLayout(layout)
        self.setWindowTitle('VibMonitor')           # 윈도우 제목
        self.setGeometry(10, 30, 1920, 1000)        # 좌상단좌표, 너비, 높이
        self.show()                                 # 윈도우 보이기
        
        self.dataProcess()
        self.tblDisplay()
        
        self.graph()
        self.graphX()
        self.graphY()
        self.graphZ()
        
        self.timer = QTimer(self)
        self.timer.start(10000)
        self.timer.timeout.connect(self.timerHandler)
        
    
    def getDataSetX(self, item, start, to, size) : # 원시데이터, 데이터 시작, 데이터 끝, 입력데이터 개수
    
        arr = []  # 공백 리스트 생성
        
        for i in range(start, to - (size-1)) : arr.append(item[i:i+size , 0])
        
        nparr = np.array(arr)  # 넘파이 배열로 변환
        nparr = np.reshape(nparr, (nparr.shape[0], nparr.shape[1], 1)) # 차원 확장
        
        return (nparr)
        
    
    def getDataSetY(self, item, start, to, size) :
        
        arr = []
        
        for i in range(start + size, to + 1) : arr.append(item[i, 0])
        
        nparr = np.array(arr) # 넘파이 배열로 변환(차원변경 없음)
        
        return (nparr)
    
    
    def dataProcess(self) :
                                                    # 데이터베이스 테이블을 읽어 전역 리스트에 저장
                                                    
        query = 'select * from tblvib order by s_measuretime desc limit 2000'
        self.cursor.execute(query)                  # 쿼리 실행
        result = self.cursor.fetchall()             # 테이블 전체 저장
        
        rowCount = self.cursor.rowcount             # 행 개수 추출
        self.df = [[0] * 4 for i in range(rowCount)]# 2차원 리스트(1행에 7개의 열이 0으로 초기화)
        
        count = 0
        
        for item in result :                        # item은 1개의 행
        
            for j in range(4) : self.df[count][j] = item[j]
            
            count += 1
            
        log_df1 = 'rmsx : %f'%(self.df[0][1])
        log_df2 = 'rmsy : %f'%(self.df[0][2])
        log_df3 = 'rmsz : %f'%(self.df[0][3])
        
        self.txtLog.append(log_df1)
        self.txtLog.append(log_df2)
        self.txtLog.append(log_df3)
        
        df1 = [k[1] for k in self.df[:120]]
        df2 = [k[2] for k in self.df[:120]]
        df3 = [k[3] for k in self.df[:120]]
        
        f1 = np.array(df1)
        f1 = f1.reshape(-1, 1)
        scaler_f1 = MinMaxScaler(feature_range=(0, 1))
        scaled_f1 = scaler_f1.fit_transform(f1)
        
        f2 = np.array(df2)
        f2 = f2.reshape(-1, 1)
        scaler_f2 = MinMaxScaler(feature_range=(0, 1))
        scaled_f2 = scaler_f2.fit_transform(f2)
        
        f3 = np.array(df3)
        f3 = f3.reshape(-1, 1)
        scaler_f3 = MinMaxScaler(feature_range=(0, 1))
        scaled_f3 = scaler_f3.fit_transform(f3)
        
        xte_f1 = self.getDataSetX(scaled_f1, 0, scaled_f1.shape[0] - 1, 10)
        yte_f1 = self.getDataSetY(scaled_f1, 0, scaled_f1.shape[0] - 1, 10)
        
        xte_f2 = self.getDataSetX(scaled_f2, 0, scaled_f2.shape[0] - 1, 10)
        yte_f2 = self.getDataSetY(scaled_f2, 0, scaled_f2.shape[0] - 1, 10)
        
        xte_f3 = self.getDataSetX(scaled_f3, 0, scaled_f3.shape[0] - 1, 10)
        yte_f3 = self.getDataSetY(scaled_f3, 0, scaled_f3.shape[0] - 1, 10)
        
        self.model_rmsx = tf.keras.models.load_model('./lstm_model.h5')
        self.model_rmsy = tf.keras.models.load_model('./lstm_model_rmsy.h5')
        self.model_rmsz = tf.keras.models.load_model('./lstm_model_rmsz.h5')
        
        self.pred_rmsx = self.model_rmsx.predict(xte_f1)
        self.pred_rmsx = scaler_f1.inverse_transform(self.pred_rmsx)
        
        self.pred_rmsy = self.model_rmsy.predict(xte_f2)
        self.pred_rmsy = scaler_f2.inverse_transform(self.pred_rmsy)
        
        self.pred_rmsz = self.model_rmsz.predict(xte_f3)
        self.pred_rmsz = scaler_f3.inverse_transform(self.pred_rmsz)
        
        self.f1_te = f1[0: , : ]
        rmsx_mape = np.mean(np.abs(self.f1_te[10: ] - self.pred_rmsx) / self.f1_te[10: ]) * 100
        
        self.f2_te = f2[0: , : ]
        rmsy_mape = np.mean(np.abs(self.f2_te[10: ] - self.pred_rmsy) / self.f2_te[10: ]) * 100
        
        self.f3_te = f3[0: , : ]
        rmsz_mape = np.mean(np.abs(self.f3_te[10: ] - self.pred_rmsz) / self.f3_te[10: ]) * 100
        
        x_mape = f"rmsx_mape : {rmsx_mape:.2f} %"
        y_mape = f"rmsy_mape : {rmsy_mape:.2f} %"
        z_mape = f"rmsz_mape : {rmsz_mape:.2f} %"
        
        self.txtLog.append(x_mape)
        self.txtLog.append(y_mape)
        self.txtLog.append(z_mape)
        

    def tblDisplay(self) :
        
        for i in range(1000) :
            
            for j in range(4) : self.tblVibOrg.setItem(i, j, QTableWidgetItem(str(self.df[i][j])))
                                                   # 테이블에 출력
               
    def graph(self) :
        
        self.fig.clear()                            # 그래프 영역 초기화
        
        ax1 = self.fig.add_subplot(111)             # 그래프 영역이 1개일 경우
        ax1.clear()                                 # 그래프 영역 초기화(subplot 각각 필요)
        
        df1 = [k[1] for k in self.df]
        df2 = [k[2] for k in self.df]
        df3 = [k[3] for k in self.df]

        ax1.plot(df1, label='rmsx')
        ax1.plot(df2, label='rmsy')
        ax1.plot(df3, label='rmsz')

        ax1.legend()
        
        self.canvas.draw()                          # 그래프 다시 그리기
        
    def graphX(self) :
        
        self.figX.clear()                           # 그래프 영역 초기화
        
        ax1 = self.figX.add_subplot(111)            # 그래프 영역이 1개일 경우
        ax1.clear()                                 # 그래프 영역 초기화(subplot 각각 필요)
        
        df1 = [k[1] for k in self.df]               # 2차원 리스트에서 rmsx 추출
        
        # npdf1 = np.array(df1)                       # 넘파이 배열로 변환
        # ax1.plot(npdf1[1880:], label='rmsx')
        
        ax1.plot(self.f1_te[10: , 0], 'r-', label = 'rmsx')
        ax1.plot(self.pred_rmsx, 'b-', label = 'pred')
        ax1.legend()
        ax1.set_title('RMS X', fontproperties = self.font_1)
        
        self.canvasX.draw()                         # 그래프 다시 그리기
        
    def graphY(self) :
        
        self.figY.clear()                           # 그래프 영역 초기화
        
        ax1 = self.figY.add_subplot(111)            # 그래프 영역이 1개일 경우
        ax1.clear()                                 # 그래프 영역 초기화(subplot 각각 필요)
        df2 = [k[2] for k in self.df]               # 2차원 리스트에서 rmsx 추출
        
        # npdf2 = np.array(df2)                       # 넘파이 배열로 변환
        # ax1.plot(npdf2[1880:], label='rmsy')
        
        ax1.plot(self.f2_te[10: , 0], 'r-', label = 'rmsy')
        ax1.plot(self.pred_rmsy, 'b-', label = 'pred')
        ax1.legend()
        ax1.set_title('RMS Y', fontproperties = self.font_1)
        
        self.canvasY.draw()                         # 그래프 다시 그리기            
            
            
    def graphZ(self) :
        
        self.figZ.clear()                           # 그래프 영역 초기화
        
        ax1 = self.figZ.add_subplot(111)            # 그래프 영역이 1개일 경우
        ax1.clear()                                 # 그래프 영역 초기화(subplot 각각 필요)
        df3 = [k[3] for k in self.df]               # 2차원 리스트에서 rmsx 추출
        
        # npdf3 = np.array(df3)                       # 넘파이 배열로 변환
        # ax1.plot(npdf3[1880:], label='rmsz')
        
        ax1.plot(self.f3_te[10: , 0], 'r-', label = 'rmsz')
        ax1.plot(self.pred_rmsz, 'b-', label = 'pred')
        ax1.legend()
        ax1.set_title('RMS Z', fontproperties = self.font_1)
        
        self.canvasZ.draw()                         # 그래프 다시 그리기      

    
    def timerHandler(self):

        self.dataProcess()
        self.tblDisplay()
        self.graph()
        self.graphX()
        self.graphY()
        self.graphZ()
            
        
if __name__ == '__main__' :                         # 진입점 판단(운영체제에서 프로그램 호출)

    app = QApplication(sys.argv)
    ex = MyApp()                                    # 클래스 객체 생성
    sys.exit(app.exec_())                           # 프로그램 실행상태 유지(윈도우 실행)