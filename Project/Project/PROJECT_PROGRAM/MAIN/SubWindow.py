from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *

import numpy as np
import pandas as pd
import pymysql as sql
import seaborn as sns

import matplotlib as mpl
import matplotlib.pyplot as pl
from matplotlib.figure import Figure as fig
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as fic

from PairPlotWindow import PairPlot

class DateSelect(QDialog):
    
    def __init__(self) :
        
        super().__init__()
        self.initUI()
        
    def initUI(self):

        self.Qdate_one = QDate.currentDate()                        # 아무것도 선택 안하고 SEARCH 시 적용되는 기본값
        self.Qdate_two = QDate.currentDate()
        
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

        self.date_one.setStyleSheet("selection-background-color: #EBB34A")
        self.date_two.setStyleSheet("selection-background-color: #EBB34A")

        self.date_one.setVerticalHeaderFormat(0)
        self.date_two.setVerticalHeaderFormat(0)
        
        self.lbl_one = QLabel("")
        self.lbl_two = QLabel("")
        
        self.lbl_one.setAlignment(Qt.AlignCenter)
        self.lbl_two.setAlignment(Qt.AlignCenter)
        
        self.btn_yes = QPushButton("Confirm")
        self.btn_no = QPushButton("Cancel")

        self.btn_yes.setStyleSheet("QPushButton\n"
                                                    "{\n"
                                                    "background-color: white;\n"
                                                    "border: 1px solid rgb(100, 100, 100);\n"
                                                    "height: 30px;\n"
                                                    "color: #a87921;\n"
                                                    "}\n"
                                                 "QPushButton:hover\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "background-color: #EBB34A;\n"
                                                    "border: 1px solid #EBB34A;\n"
                                                    "}"
                                                    "QPushButton:pressed\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "border: 1px solid #a87921;\n"
                                                    "background-color: #a87921;\n"
                                                    "}")

        self.btn_no.setStyleSheet("QPushButton\n"
                                                    "{\n"
                                                    "background-color: white;\n"
                                                    "border: 1px solid rgb(100, 100, 100);\n"
                                                    "height: 30px;\n"
                                                    "color: #a87921;\n"
                                                    "}\n"
                                                 "QPushButton:hover\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "background-color: #EBB34A;\n"
                                                    "border: 1px solid #EBB34A;\n"
                                                    "}"
                                                    "QPushButton:pressed\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "border: 1px solid #a87921;\n"
                                                    "background-color: #a87921;\n"
                                                    "}")

        # 위젯 이벤트 설정
        
        self.date_one.clicked.connect(self.date_selected)
        self.date_two.clicked.connect(self.date_selected)
        
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
        
    def date_selected(self):                    # 달력 날짜 선택시
        
        if self.sender() == self.date_one:
            
            self.Qdate_one = self.date_one.selectedDate()
            
            date_one = self.Qdate_one.toString('yyyy-MM-dd')
            self.lbl_one.setText(date_one)
            
        elif self.sender() == self.date_two:
            
            self.Qdate_two = self.date_two.selectedDate()
            
            date_two = self.Qdate_two.toString('yyyy-MM-dd')
            self.lbl_two.setText(date_two)
        
    def btn_confirm(self):
        
        self.accept()                           # 다이얼로그 내용을 저장하여 전달
        
    def btn_cancel(self):
        
        self.reject()                           # 다이얼로그 내용 전달없이 종료
        
    def showModal(self):
        
        return super().exec_()


class Correlation(QDialog):
    
    def __init__(self) :
        
        super().__init__()
        self.initUI()
        
    def initUI(self):

        ## 레이아웃 설정

        layout_main = QHBoxLayout()

        layout_left = QVBoxLayout()

        layout_graph = QHBoxLayout()
        layout_menu = QHBoxLayout()
        layout_cont = QHBoxLayout()

        layout_main.addLayout(layout_left)

        layout_left.addLayout(layout_menu, 1)
        layout_left.addLayout(layout_cont, 4)
        layout_left.addLayout(layout_graph, 5)

        ### 위젯
        
        ## 버튼

        self.btn_start = QPushButton('ANALYZE')
        self.btn_start.clicked.connect(self.btn_analyze)

        self.btn_pplot = QPushButton('VIEW PAIRPLOT')
        self.btn_pplot.clicked.connect(self.btn_view)
        self.btn_pplot.setEnabled(False)

        self.btn_reject = QPushButton('CLOSE')
        self.btn_reject.clicked.connect(self.btn_cancel)

        self.btn_start.setStyleSheet("QPushButton\n"
                                                    "{\n"
                                                    "background-color: white;\n"
                                                    "border: 1px solid rgb(100, 100, 100);\n"
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

        self.btn_reject.setStyleSheet("QPushButton\n"
                                                    "{\n"
                                                    "background-color: white;\n"
                                                    "border: 1px solid rgb(100, 100, 100);\n"
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
        self.btn_pplot.setStyleSheet("QPushButton\n"
                                                    "{\n"
                                                    "background-color: white;\n"
                                                    "border: 1px solid rgb(100, 100, 100);\n"
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

        layout_menu.addWidget(self.btn_start)
        layout_menu.addWidget(self.btn_pplot)
        layout_menu.addWidget(self.btn_reject)
        
        ## 테이블

        self.col_name = ['Date', 'TMP1','TMP2','TMP3','TMP4','TMP5','TMP6']

        self.tbl_tmp = QTableWidget(100, 7)
        self.tbl_tmp.setHorizontalHeaderLabels(self.col_name)
        
        tbl_width = int((self.tbl_tmp.width()-190)/(self.tbl_tmp.columnCount()-1) * 1.1)

        self.tbl_tmp.setColumnWidth(0, 190)
        for i in range(1, self.tbl_tmp.columnCount()): self.tbl_tmp.setColumnWidth(i, tbl_width)

        self.tbl_tmp.setStyleSheet("QTableWidget{\n"
                                        "selection-background-color: #5E8EE9;\n"
                                        "font-size : 12pt;\n"
                                        "}\n"
                                   "QScrollBar:vertical {\n"              
                                    "    border: 1px solid #999999;\n"
                                    "    background:white;\n"
                                    "    width:10px;\n"
                                    "    margin: 0px 0px 0px 0px;\n"
                                        "}\n"
                                    "QScrollBar::handle:vertical {\n"
                                    "    background-color: #3059a7;\n"
                                    "    height: 50px;\n"
                                    "}\n"
                                    "QScrollBar::add-line:vertical {\n"
                                    "    height: 0px;\n"
                                    "}\n"
                                    "QScrollBar::sub-line:vertical {\n"
                                    "    height: 0 px;\n"
                                    "}")

        ## 텍스트 상자
        
        self.txt_log = QTextEdit()
        self.txt_log.setAcceptRichText(True)
        self.txt_log.setReadOnly(True)

        self.txt_log.setStyleSheet("QTextEdit {"
                                        "font-size : 10pt;"
                                        "color : rgba(0, 89, 253, 200);"
                                        "font-weight: 400;"
                                        "}"
                                    "QScrollBar:vertical {\n"              
                                    "    border: 1px solid #999;\n"
                                    "    background:white;\n"
                                    "    width:10px;\n"
                                    "    margin: 0px;\n"
                                        "}\n"
                                    "QScrollBar::handle:vertical {\n"
                                    "    background-color: #3059a7;\n"
                                    "    height: 50px;\n"
                                    "}\n"
                                    "QScrollBar::add-line:vertical {\n"
                                    "    height: 0px;\n"
                                    "}\n"
                                    "QScrollBar::sub-line:vertical {\n"
                                    "    height: 0 px;\n"
                                    "}")

        layout_cont.addWidget(self.txt_log, 1)
        layout_cont.addWidget(self.tbl_tmp, 3)
        
        ## 그래프

        self.fig_main = pl.Figure(figsize=(6,6))    # 그래프 영역 변수 생성
        self.canv_main = fic(self.fig_main)         # 그래프 그리기 영역

        layout_graph.addWidget(self.canv_main)
        
        ## 히트맵

        self.canv_hmap = fic(fig())

        layout_graph.addWidget(self.canv_hmap)

        self.setLayout(layout_main)
        self.setWindowTitle('Correlation analysis')
        self.setGeometry(0, 30, 1010, 800)
        self.show()

    def btn_view(self):

        dialog_open = PairPlot(self)
        dialog_open.showModal()

    def data_loading(self):                         # DB 연결 및 원하는 데이터 추출

        con = sql.connect(host = "127.0.0.1", user = "root", password = "bigdatar", db = "bigdata_tmp", charset = "utf8")
        cmd = con.cursor()

        today = QDate.currentDate()

        ten_days_ago = today.addDays(-10)

        self.txt_log.append("")                     # 범위 로그에 기록
        self.txt_log.append(f"{ten_days_ago.toString('yyyy-MM-dd')} ~ {today.toString('yyyy-MM-dd')}")
        self.txt_log.append("")

        query = f"SELECT * FROM TMP_DATA WHERE DATE(S_TIME) >= '{ten_days_ago.toString('yyyy-MM-dd')}' AND DATE(S_TIME) <= '{today.toString('yyyy-MM-dd')}' ORDER BY S_TIME DESC;"
        
        cmd.execute(query)
        self.data = cmd.fetchall()
        self.nrow = cmd.rowcount

        query = f"SELECT * FROM TMP_DATA WHERE DATE(S_TIME) = '{today.toString('yyyy-MM-dd')}' ORDER BY S_TIME;"

        cmd.execute(query)
        self.today_data = cmd.fetchall()

        self.today_data = pd.DataFrame(self.today_data, columns = self.col_name)
        self.today_data.index = self.today_data['Date']
        self.today_data.drop(['Date'], axis = 1, inplace = True)
        
        con.close()

    def tbl_setting(self):                          # 데이터를 테이블에 표시
    
        self.tbl_tmp.clear()
        
        self.tbl_tmp.setHorizontalHeaderLabels(self.col_name)
        self.tbl_tmp.setRowCount(self.nrow)
        
        for i in range(self.nrow):

            for j in range(7):
                
                item = QTableWidgetItem(str(self.data[i][j]))
                item.setTextAlignment(Qt.AlignCenter)
                
                self.tbl_tmp.setItem(i, j, item)

    def corr_process(self):                         # 데이터프레임 생성 및 상관분석 실행

        self.df = pd.DataFrame(self.data, columns = self.col_name)

        self.df.index = self.df['Date']
        self.df.drop(['Date'], axis = 1, inplace = True)
        self.df.sort_index(inplace = True)

        self.df_corr = self.df.corr(method = 'pearson')
        self.df_corr =  self.df_corr.apply(lambda x: round(x, 2))

    def draw_heatmap(self):                         # 히트맵 그리기

        ax = self.canv_hmap.figure.subplots()

        sns.heatmap(self.df_corr, annot=True, annot_kws=dict(color = '#a87921'), ax = ax, cmap = mpl.colormaps['Blues'])
        ax.set_title("Correlation Analyze")
        
        self.canv_hmap.draw()

    def main_graph(self):                           # 메인 그래프 그리기
        
        self.fig_main.clear()
        
        ax = self.fig_main.add_subplot(111)
        ax.clear()
        
        self.fig_main.set_facecolor("#f8f8f8")

        tmp1 = list(self.df['TMP1'])
        tmp2 = list(self.df['TMP2'])
        tmp3 = list(self.df['TMP3'])
        tmp4 = list(self.df['TMP4'])
        tmp5 = list(self.df['TMP5'])
        tmp6 = list(self.df['TMP6'])

        # 2, 3, 4, 1, 6, 5

        ax.plot(tmp1, label='TMP1', color = '#939CAE')
        ax.plot(tmp2, label='TMP2', color = '#EBB34A')
        ax.plot(tmp3, label='TMP3', color = '#CFAC6A')
        ax.plot(tmp4, label='TMP4', color = '#B2A48B')
        ax.plot(tmp5, label='TMP5', color = '#5E8EE9')
        ax.plot(tmp6, label='TMP6', color = '#7D96C6')

        ax.legend(fontsize = 8, ncols = 3, loc = 'upper center')
        ax.set_ylim(20, 37)
        ax.tick_params(axis = 'both', labelsize = 8.0)
        
        self.canv_main.draw()

    def btn_analyze(self):                          # analyze 라는 버튼을 눌렀을 때 전체 루틴 실행
        
        self.data_loading()
        self.tbl_setting()
        self.corr_process()
        self.draw_heatmap()
        self.main_graph()
        self.btn_pplot.setEnabled(True)
        
    def btn_cancel(self):                           # close 버튼 클릭 시 창 닫기
        
        self.reject()                               # 다이얼로그 내용 전달없이 종료
        
    def showModal(self):
        
        return super().exec_()