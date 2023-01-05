import sys
import pymysql as sql
import numpy as np
from datetime import datetime as dt

from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *

import matplotlib.pyplot as pl
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

import tensorflow as tf
from sklearn.preprocessing import MinMaxScaler as MMS

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

        layout_log = QVBoxLayout()
        
        # 오른쪽 레이아웃
        
        layout_tmp1 = QVBoxLayout()
        layout_tmp2 = QVBoxLayout()
        layout_tmp3 = QVBoxLayout()
        layout_tmp4 = QVBoxLayout()
        layout_tmp5 = QVBoxLayout()
        layout_tmp6 = QVBoxLayout()
        
        # 레이아웃 추가
        
        layout_main.addLayout(layout_left, 3)
        layout_main.addLayout(layout_right, 2)
        
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
                self.btn_menu[cnt].setStyleSheet("QPushButton\n"
                                                    "{\n"
                                                    "background-color: white;\n"
                                                    "border: 1px solid rgb(100, 100, 100);\n"
                                                    "height: 30px;\n"
                                                    "}\n"
                                                 "QPushButton:hover\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "background-color: rgb(150, 150, 150);\n"
                                                    "border: 1px solid rgb(150, 150, 150);\n"
                                                    "}"
                                                    "QPushButton:pressed\n"
                                                    "{\n"
                                                    "color: white;\n"
                                                    "border: 1px solid rgb(100, 100, 100);\n"
                                                    "background-color: rgb(100, 100, 100);\n"
                                                    "}")
                cnt += 1
                
        self.btn_menu[2].setEnabled(False)
        
        # 테이블과 텍스트 위젯 구성
        
        self.tbl_tmp = QTableWidget(self.nrow, 7)

        tbl_width = int((self.tbl_tmp.width()-190)/(self.tbl_tmp.columnCount()-1)*1.3)

        self.tbl_tmp.setColumnWidth(0, 190)
        for i in range(1, self.tbl_tmp.columnCount()): self.tbl_tmp.setColumnWidth(i, tbl_width)
        
        self.tbl_tmp.setStyleSheet("QTableWidget{\n"
                                        "selection-background-color: #EBB34A;\n"
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
        
        self.txt_log = QTextEdit()
        self.txt_log.setAcceptRichText(True)
        self.txt_log.setReadOnly(True)

        self.txt_log.setStyleSheet("QTextEdit {"
                                        "font-size : 12pt;"
                                        "color : rgba(0, 89, 253, 200);"
                                        "font-weight: 400;"
                                        "}"
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

        self.prb_loading = QProgressBar()

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
        
        self.lbl_timer = QLabel("60")
        
        self.lbl_timer.setAlignment(Qt.AlignRight)
        self.lbl_timer.setStyleSheet("font-weight: 700;" "font-size: 12px;")
        
        # 레이아웃에 추가
        
        layout_tbl_log.addWidget(self.tbl_tmp, 3)
        layout_tbl_log.addLayout(layout_log, 1)

        layout_log.addWidget(self.txt_log)
        layout_log.addWidget(self.lbl_timer)
        layout_log.addWidget(self.prb_loading)
        
        # 메인 그래프 위젯 구성
        
        self.fig_main = pl.Figure(figsize = (5, 3))
        self.canv_main = FigureCanvas(self.fig_main)

        self.fig_main.set_facecolor("#ececec")
        
        # 레이아웃에 추가
        
        layout_grph.addWidget(self.canv_main)
        
        # 오른쪽 그래프 위젯 구성
        
        self.fig_tmp = [pl.Figure(figsize = (5, 3)) for i in range(6)]
        self.canv = [FigureCanvas(self.fig_tmp[i]) for i in range(6)]

        for i in self.fig_tmp: i.set_facecolor("#ececec")
        
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

        # 윈도우 설정

        self.setStyleSheet("background-color: white;")
        
        self.setLayout(layout_main)
        self.setWindowTitle('Temp Monitor')
        self.setGeometry(0, 30, 1900, 1000)
        self.show()
        
        # 타이머 제어 추가

        self.sec = 59
        
        self.timer = QTimer(self)            
        self.timer.start()
        self.timer.setInterval(1000)
        self.timer.timeout.connect(self.timeout)
        
        self.btn_menu[0].setEnabled(False)

        self.timeout()
        
        
    def btn_clicked(self):                          # 버튼 클릭 시
        
        if self.sender() == self.btn_menu[0]:
            
            self.sec = 59
            self.timeout()            
            if not self.timer.isActive(): self.timer.start()
            
            self.txt_log.append("")
            self.txt_log.append("< ==== AUTO MODE ==== >")
            
            self.search_mode = False
            
            self.btn_menu[0].setEnabled(False)
            self.btn_menu[2].setEnabled(False)
                
        elif self.sender() == self.btn_menu[1]:
            
            dialog_open = DateSelect()
            re = dialog_open.showModal()
            
            if re:
                
                self.date_one = dialog_open.Qdate_one
                self.date_two = dialog_open.Qdate_two

                if self.date_one > self.date_two: self.date_one, self.date_two = self.date_two, self.date_one

                self.date_one = self.date_one.toString('yyyy-MM-dd')
                self.date_two = self.date_two.toString('yyyy-MM-dd')
                
                self.txt_log.append("")
                self.txt_log.append("< ==== SEARCH MODE ==== >")
                self.txt_log.append("")
                self.txt_log.append("***")
                self.txt_log.append(f"{self.date_one} ~ {self.date_two}")
                self.txt_log.append("***")
                self.txt_log.append("")
                
                self.btn_menu[0].setEnabled(False)
                self.btn_menu[2].setEnabled(True)

                self.search_mode = True
                self.timer.stop()
                self.lbl_timer.setText("-")
                
            else:
                
                self.btn_menu[0].setEnabled(True)
                self.btn_menu[2].setEnabled(False)
            
                
        elif self.sender() == self.btn_menu[2]:
            
            self.timer.stop()
            
            self.btn_menu[0].setEnabled(True)
            self.btn_menu[2].setEnabled(False)
            
            self.search_mode = True
            self.sec = 59
            self.timeout()
            self.lbl_timer.setText("-")
        
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
        
        self.prb_loading.setValue(0)
        
        for i in range(1, 7):
            
            self.model_pred(i)
            self.prb_loading.setValue(round(i/6 * 100))
            
            if i == 6: self.prb_loading.setValue(100)
        
    def model_pred(self, n):                                # 미리 훈련된 모델을 이용한 예측치 추출 및 MAPE 추출

        df = [i[n] for i in self.df[0:60]]
        df = np.array(df)
        df = df.reshape(-1, 1)
        
        t_df = df[0: , : ]
        self.t_tmp[n - 1] = t_df
        
        s_tool = MMS(feature_range = (0, 1))
        s_df = s_tool.fit_transform(df)
        
        xte = self.get_data_x(s_df, 0, s_df.shape[0] - 1, 10)
        lstm_model = tf.keras.models.load_model(f'lstm_tmp{n}.h5')
        
        self.pred_tmp[n - 1] = lstm_model.predict(xte)
        self.pred_tmp[n - 1] = s_tool.inverse_transform(self.pred_tmp[n - 1])
        
        mape = np.mean(np.abs(t_df[10: ] - self.pred_tmp[n - 1]) / t_df[10: ]) * 100
        mape_txt = f'TMP{n} MAPE : {mape:.3f}%'
        
        self.txt_log.append(mape_txt)

        if n == 1:
            
            self.today = dt.now().strftime("%Y-%m-%d %H:%M:%S")
            query = f"INSERT INTO TMP_EVT_DATA (S_TIME, S_TMP1_MAPE) VALUES ('{self.today}', {mape:0.3f})"

        else : query = f"UPDATE TMP_EVT_DATA SET S_TMP{n}_MAPE = {mape:0.3f} WHERE S_TIME = '{self.today}'"

        con = sql.connect(host = "127.0.0.1", user = "root", password = "bigdatar", db = "bigdata_tmp", charset = "utf8")
        cmd = con.cursor()
        cmd.execute(query)
        cmd.fetchall()
        con.commit()
        con.close()
        
    def tbl_setting(self):                          # 데이터를 테이블에 표시
    
        self.tbl_tmp.clear()
        
        col_name = ['Date', 'Temp1','Temp2','Temp3','Temp4','Temp5','Temp6']
        
        self.tbl_tmp.setHorizontalHeaderLabels(col_name)
        
        for i in range(self.nrow):
            for j in range(7):
                
                item = QTableWidgetItem(str(self.df[i][j]))
                item.setTextAlignment(Qt.AlignCenter)
                
                self.tbl_tmp.setItem(i, j, item)
            
    def main_graph(self):                           # 메인 그래프 그리기
        
        self.fig_main.clear()
        
        ax = self.fig_main.add_subplot(111)
        ax.clear()
        
        self.fig_main.set_facecolor("#f8f8f8")

        tmp1 = [i[1] for i in self.df]
        tmp2 = [i[2] for i in self.df]
        tmp3 = [i[3] for i in self.df]
        tmp4 = [i[4] for i in self.df]
        tmp5 = [i[5] for i in self.df]
        tmp6 = [i[6] for i in self.df]

        # 2, 3, 4, 1, 6, 5

        ax.plot(tmp1, label='TMP1', color = '#939CAE')
        ax.plot(tmp2, label='TMP2', color = '#EBB34A')
        ax.plot(tmp3, label='TMP3', color = '#CFAC6A')
        ax.plot(tmp4, label='TMP4', color = '#B2A48B')
        ax.plot(tmp5, label='TMP5', color = '#5E8EE9')
        ax.plot(tmp6, label='TMP6', color = '#7D96C6')

        ax.legend(fontsize = 8, ncols = 6, loc = 'upper center')
        ax.set_ylim(20, 37)
        ax.tick_params(axis = 'both', labelsize = 8.0)
        
        self.canv_main.draw()
        
    def sub_graph(self, n):                         # 예측치와 관측치 그리기
        
        self.fig_tmp[n].clear()
        
        ax = self.fig_tmp[n].add_subplot(111)
        ax.clear()
        
        self.fig_tmp[n].set_facecolor("#f8f8f8")
        
        ax.plot(self.t_tmp[n][10: , 0], label = f'TMP{n+1}', color = '#EBB34A')
        ax.plot(self.pred_tmp[n], label = 'PRED', color = '#5E8EE9')
        
        ax.legend(fontsize = 8)
        ax.set_title(f'TMP{n+1}', fontsize = 8)
        ax.tick_params(axis = 'both', labelsize = 8.0)
        
        self.canv[n].draw()
        
    def timeout(self):                              # 60초가 될때 함수들 실행 및 1초마다 UI의 타이머 숫자 업데이트

        self.sec += 1
        
        if self.sec != 60: self.lbl_timer.setText(f"{60 - self.sec}")

        else:

            self.lbl_timer.setText("0")

            self.data_loading()
            self.data_processing()
            self.tbl_setting()
            self.main_graph()
        
            for i in range(6): self.sub_graph(i)
            
            self.lbl_timer.setText("60")
            self.sec = 0

        
if __name__ == '__main__' :
    
    app = QApplication(sys.argv)
    ex = MainWindow()
    sys.exit(app.exec_())