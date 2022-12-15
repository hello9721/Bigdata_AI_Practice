import pandas as pd
import numpy as np
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
import matplotlib.pyplot as plt
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib import font_manager, rc
import pymysql


class MyApp(QWidget) :  # 클래스 정의
    def __init__(self) :
        super().__init__()  # 부모클래스 생성자 호출(가장 위쪽 코딩)
        self.initUI()
        
    def initUI(self) :  # 윈도우 환경 구성
        font_name = font_manager.FontProperties(fname="c:/Windows/Fonts/malgun.ttf").get_name()
        rc('font', family=font_name)   
        
        self.conn = pymysql.connect(host='127.0.0.1' , user='scott', password='tiger', db='work', charset='utf8')
        self.cursor = self.conn.cursor()
        
        
        self.btnOpen = QPushButton('불러오기')
        self.btnSave = QPushButton('저장오기')
        self.tblVibOrg = QTableWidget(1000, 4)
        col_head = ['Date', 'RmsX','RmsY','RmsZ']
        self.tblVibOrg.setHorizontalHeaderLabels(col_head)
        
        self.fig = plt.Figure(figsize=(6,6))  # 그래프 영역 변수 생성
        self.canvas = FigureCanvas(self.fig)  # 그래프 그리기 영역
        
        self.figX = plt.Figure(figsize=(7,3))
        self.figY = plt.Figure(figsize=(7,3))
        self.figZ = plt.Figure(figsize=(7,3))
        self.canvasX = FigureCanvas(self.figX)  # 그래프 그리기 영역
        self.canvasY = FigureCanvas(self.figY)  # 그래프 그리기 영역
        self.canvasZ = FigureCanvas(self.figZ)  # 그래프 그리기 영역
        

        layout = QHBoxLayout() # 상자 배치관리자(최상위)
        layoutMonitor = QVBoxLayout()
        layoutML = QVBoxLayout()
        
        # 왼쪽 레이아웃
        layoutMenu = QHBoxLayout()
        layoutTbl = QVBoxLayout()
        layoutGraph = QVBoxLayout()
        
        layoutMenu.addWidget(self.btnOpen)
        layoutMenu.addWidget(self.btnSave)
        
        layoutTbl.addWidget(self.tblVibOrg)
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
        self.setWindowTitle('VibMonitor')  # 윈도우 제목
        self.setGeometry(10, 30, 1920, 1000)  # 좌상단좌표, 너비, 높이
        self.show()  # 윈도우 보이기
        
        self.dataProcess()
        self.tblDisplay()
        self.graph()
        self.graphX()
        self.graphY()
        self.graphZ()
        
    def dataProcess(self) :
        # 데이터베이스 테이블을 읽어 전역 리스트에 저장
        query = 'select * from tblvib order by s_measuretime desc limit 1000'
        self.cursor.execute(query)  # 쿼리 실행
        result = self.cursor.fetchall()  # 테이블 전체 저장
        rowCount = self.cursor.rowcount  # 행 개수 추출
        self.df = [[0] * 4 for i in range(rowCount)] # 2차원 리스트(1행에 7개의 열이 0으로 초기화)
        
        count = 0
        for item in result : # item은 1개의 행
            for j in range(4) :
                self.df[count][j] = item[j]
            count += 1

    def tblDisplay(self) :
        for i in range(1000) :
            for j in range(4) :
               self.tblVibOrg.setItem(i, j, QTableWidgetItem(str(self.df[i][j])))  # 테이블에 출력
               
    def graph(self) :
        self.fig.clear()  # 그래프 영역 초기화
        
        ax1 = self.fig.add_subplot(111)  # 그래프 영역이 1개일 경우
        ax1.clear() # 그래프 영역 초기화(subplot 각각 필요)
        
        df1 = [k[1] for k in self.df]
        df2 = [k[2] for k in self.df]
        df3 = [k[3] for k in self.df]
        df1.reverse()
        df2.reverse()
        df3.reverse()


        ax1.plot(df1, label='rmsx')
        ax1.plot(df2, label='rmsy')
        ax1.plot(df3, label='rmsz')

        ax1.legend()
        
        self.canvas.draw()  # 그래프 다시 그리기
    def graphX(self) :
        
        self.figX.clear()  # 그래프 영역 초기화
        
        ax1 = self.figX.add_subplot(111)  # 그래프 영역이 1개일 경우
        ax1.clear() # 그래프 영역 초기화(subplot 각각 필요)
        df1 = [k[1] for k in self.df] # 2차원 리스트에서 rmsx 추출
        npdf1 = np.array(df1)  # 넘파이 배열로 변환
        ax1.plot(npdf1[940:], label='rmsx')
        ax1.legend()
        
        self.canvasX.draw()  # 그래프 다시 그리기
        
    def graphY(self) :
        self.figY.clear()  # 그래프 영역 초기화
        
        ax1 = self.figY.add_subplot(111)  # 그래프 영역이 1개일 경우
        ax1.clear() # 그래프 영역 초기화(subplot 각각 필요)
        df2 = [k[2] for k in self.df] # 2차원 리스트에서 rmsx 추출
        npdf2 = np.array(df2)  # 넘파이 배열로 변환
        ax1.plot(npdf2[940:], label='rmsy')
        ax1.legend()
        
        self.canvasY.draw()  # 그래프 다시 그리기            
            
            
    def graphZ(self) :
        self.figZ.clear()  # 그래프 영역 초기화
        
        ax1 = self.figZ.add_subplot(111)  # 그래프 영역이 1개일 경우
        ax1.clear() # 그래프 영역 초기화(subplot 각각 필요)
        df3 = [k[3] for k in self.df] # 2차원 리스트에서 rmsx 추출
        npdf3 = np.array(df3)  # 넘파이 배열로 변환
        ax1.plot(npdf3[940:], label='rmsz')
        ax1.legend()
        
        self.canvasZ.draw()  # 그래프 다시 그리기                        
            
        
if __name__ == '__main__' :  # 진입점 판단(운영체제에서 프로그램 호출)
    app = QApplication(sys.argv)
    ex = MyApp() # 클래스 객체 생성
    sys.exit(app.exec_())  # 프로그램 실행상태 유지(윈도우 실행)