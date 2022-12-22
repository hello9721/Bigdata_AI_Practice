import sys
import pymysql
import numpy as np
import pandas as pd

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
        
        ### UI 구성
        
        self.btnOpen = QPushButton('LOAD')
        self.btnSave = QPushButton('SAVE')
        
        self.tblTmpOrg = QTableWidget(1000, 7)
        col_head = ['Date', 'Temp1','Temp2','Temp3','Temp4','Temp5','Temp6']
        self.tblTmpOrg.setHorizontalHeaderLabels(col_head)
        self.tblTmpOrg.setStyleSheet("font-size : 12pt;")
        
        self.tblTmpOrg.setColumnWidth(0, 200)
        
        self.txtLog = QTextEdit()
        self.txtLog.setAcceptRichText(True)
        self.txtLog.setReadOnly(True)
        self.txtLog.setStyleSheet('font-size : 12pt;'
                                  'color : blue;')
        
        self.fig = plt.Figure(figsize=(6,6))        # 그래프 영역 변수 생성
        self.canvas = FigureCanvas(self.fig)        # 그래프 그리기 영역
        
        self.fig1 = plt.Figure(figsize=(7,3))
        self.fig2 = plt.Figure(figsize=(7,3))
        self.fig3 = plt.Figure(figsize=(7,3))
        
        self.canvas1 = FigureCanvas(self.fig1)      # 그래프 그리기 영역
        self.canvas2 = FigureCanvas(self.fig2)      # 그래프 그리기 영역
        self.canvas3 = FigureCanvas(self.fig3)      # 그래프 그리기 영역
        

        layout = QHBoxLayout()                      # 상자 배치관리자(최상위)
        layoutMonitor = QVBoxLayout()
        layoutML = QVBoxLayout()        
                                                    # 왼쪽 레이아웃
        layoutMenu = QHBoxLayout()
        layoutTbl = QHBoxLayout()
        layoutGraph = QVBoxLayout()
        
        layoutMenu.addWidget(self.btnOpen)
        layoutMenu.addWidget(self.btnSave)
        
        layoutTbl.addWidget(self.tblTmpOrg, 2)
        layoutTbl.addWidget(self.txtLog, 1)
        layoutGraph.addWidget(self.canvas)
        
        layoutMonitor.addLayout(layoutMenu)
        layoutMonitor.addLayout(layoutTbl)
        layoutMonitor.addLayout(layoutGraph)
                                                    # 오른쪽 레이아웃
        layoutTmp1 = QVBoxLayout()
        layoutTmp2 = QVBoxLayout()
        layoutTmp3 = QVBoxLayout()
        
        layoutTmp1.addWidget(self.canvas1)
        layoutTmp2.addWidget(self.canvas2)
        layoutTmp3.addWidget(self.canvas3)
        
        layoutML.addLayout(layoutTmp1)
        layoutML.addLayout(layoutTmp2)
        layoutML.addLayout(layoutTmp3)
        
        layout.addLayout(layoutMonitor)
        layout.addLayout(layoutML)
        
        self.setLayout(layout)
        self.setWindowTitle('sample_TMonitor')           # 윈도우 제목
        self.setGeometry(10, 30, 1920, 1000)        # 좌상단좌표, 너비, 높이
        self.show()                                 # 윈도우 보이기
        
        self.dataProcess()
        self.tblDisplay()
        
        self.graph()
        self.graph1()
        self.graph2()
        self.graph3()
        
        self.timer = QTimer(self)
        self.timer.start(60000)
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
    
        ### DB 연결
        
        con = pymysql.connect(host='127.0.0.1' , user='root', password='bigdatar', db='bigdata_tmp', charset='utf8')
        cmd = con.cursor()
                                                    # 데이터베이스 테이블을 읽어 전역 리스트에 저장
                                                    
        query = 'select * from tmp_data order by s_time desc'
        cmd.execute(query)                  # 쿼리 실행
        result = cmd.fetchall()             # 테이블 전체 저장
        
        rowCount = cmd.rowcount             # 행 개수 추출
        self.df = [[0] * 7 for i in range(rowCount)]# 2차원 리스트(1행에 7개의 열이 0으로 초기화)
        
        count = 0
        
        for item in result :                        # item은 1개의 행
        
            for j in range(7) : self.df[count][j] = item[j]
            
            count += 1
            
        print(self.df[0])
            
        log_df1 = 'tmp1 : %.2f'%(self.df[0][1])
        log_df2 = 'tmp2 : %.2f'%(self.df[0][2])
        log_df3 = 'tmp3 : %.2f'%(self.df[0][3])
        
        self.txtLog.append(log_df1)
        self.txtLog.append(log_df2)
        self.txtLog.append(log_df3)
        
        df1 = [k[1] for k in self.df]
        df2 = [k[2] for k in self.df]
        df3 = [k[3] for k in self.df]
        
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
        
        self.model_tmp1 = tf.keras.models.load_model('./lstm_tmp1.h5')
        self.model_tmp2 = tf.keras.models.load_model('./lstm_tmp2.h5')
        self.model_tmp3 = tf.keras.models.load_model('./lstm_temp3.h5')
        
        self.pred_tmp1 = self.model_tmp1.predict(xte_f1)
        self.pred_tmp1 = scaler_f1.inverse_transform(self.pred_tmp1)
        
        self.pred_tmp2 = self.model_tmp2.predict(xte_f2)
        self.pred_tmp2 = scaler_f2.inverse_transform(self.pred_tmp2)
        
        self.pred_tmp3 = self.model_tmp3.predict(xte_f3)
        self.pred_tmp3 = scaler_f3.inverse_transform(self.pred_tmp3)
        
        self.f1_te = f1[0: , : ]
        tmp1_mape = np.mean(np.abs(self.f1_te[10: ] - self.pred_tmp1) / self.f1_te[10: ]) * 100
        
        self.f2_te = f2[0: , : ]
        tmp2_mape = np.mean(np.abs(self.f2_te[10: ] - self.pred_tmp2) / self.f2_te[10: ]) * 100
        
        self.f3_te = f3[0: , : ]
        tmp3_mape = np.mean(np.abs(self.f3_te[10: ] - self.pred_tmp3) / self.f3_te[10: ]) * 100
        
        x_mape = f"tmp1_mape : {tmp1_mape:.2f} %"
        y_mape = f"tmp2_mape : {tmp2_mape:.2f} %"
        z_mape = f"tmp3_mape : {tmp3_mape:.2f} %"
        
        self.txtLog.append(x_mape)
        self.txtLog.append(y_mape)
        self.txtLog.append(z_mape)
        
        cmd.close()
        con.close()

    def tblDisplay(self) :
        
        for i in range(len(self.df)) :
            
            for j in range(7) : self.tblTmpOrg.setItem(i, j, QTableWidgetItem(str(self.df[i][j])))
                                                   # 테이블에 출력
               
    def graph(self) :
        
        self.fig.clear()                            # 그래프 영역 초기화
        
        ax1 = self.fig.add_subplot(111)             # 그래프 영역이 1개일 경우
        ax1.clear()                                 # 그래프 영역 초기화(subplot 각각 필요)
        
        df1 = [k[1] for k in self.df]
        df2 = [k[2] for k in self.df]
        df3 = [k[3] for k in self.df]

        ax1.plot(df1, label='tmp1')
        ax1.plot(df2, label='tmp2')
        ax1.plot(df3, label='tmp3')

        ax1.legend()
        
        self.canvas.draw()                          # 그래프 다시 그리기
        
    def graph1(self) :
        
        self.fig1.clear()                           # 그래프 영역 초기화
        
        ax1 = self.fig1.add_subplot(111)            # 그래프 영역이 1개일 경우
        ax1.clear()                                 # 그래프 영역 초기화(subplot 각각 필요)
        
        df1 = [k[1] for k in self.df]               # 2차원 리스트에서 rmsx 추출
        
        # npdf1 = np.array(df1)                       # 넘파이 배열로 변환
        # ax1.plot(npdf1[1880:], label='rmsx')
        
        ax1.plot(self.f1_te[10: , 0], 'r-', label = 'tmp1')
        ax1.plot(self.pred_tmp1, 'b-', label = 'pred')
        ax1.legend()
        ax1.set_title('Temp 1', fontproperties = self.font_1)
        
        self.canvas1.draw()                         # 그래프 다시 그리기
        
    def graph2(self) :
        
        self.fig2.clear()                           # 그래프 영역 초기화
        
        ax1 = self.fig2.add_subplot(111)            # 그래프 영역이 1개일 경우
        ax1.clear()                                 # 그래프 영역 초기화(subplot 각각 필요)
        df2 = [k[2] for k in self.df]               # 2차원 리스트에서 rmsx 추출
        
        # npdf2 = np.array(df2)                       # 넘파이 배열로 변환
        # ax1.plot(npdf2[1880:], label='rmsy')
        
        ax1.plot(self.f2_te[10: , 0], 'r-', label = 'tmp2')
        ax1.plot(self.pred_tmp2, 'b-', label = 'pred')
        ax1.legend()
        ax1.set_title('Temp2', fontproperties = self.font_1)
        
        self.canvas2.draw()                         # 그래프 다시 그리기            
            
            
    def graph3(self) :
        
        self.fig3.clear()                           # 그래프 영역 초기화
        
        ax1 = self.fig3.add_subplot(111)            # 그래프 영역이 1개일 경우
        ax1.clear()                                 # 그래프 영역 초기화(subplot 각각 필요)
        df3 = [k[3] for k in self.df]               # 2차원 리스트에서 rmsx 추출
        
        # npdf3 = np.array(df3)                       # 넘파이 배열로 변환
        # ax1.plot(npdf3[1880:], label='rmsz')
        
        ax1.plot(self.f3_te[10: , 0], 'r-', label = 'tmp3')
        ax1.plot(self.pred_tmp3, 'b-', label = 'pred')
        ax1.legend()
        ax1.set_title('temp3', fontproperties = self.font_1)
        
        self.canvas3.draw()                         # 그래프 다시 그리기      

    
    def timerHandler(self):

        self.dataProcess()
        self.tblDisplay()
        self.graph()
        self.graph1()
        self.graph2()
        self.graph3()
            
        
if __name__ == '__main__' :                         # 진입점 판단(운영체제에서 프로그램 호출)

    app = QApplication(sys.argv)
    ex = MyApp()                                    # 클래스 객체 생성
    sys.exit(app.exec_())                           # 프로그램 실행상태 유지(윈도우 실행)