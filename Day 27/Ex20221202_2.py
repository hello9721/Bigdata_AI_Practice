# DB 연결 실습

import sys
import pandas as pd
import pymysql as sql
from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *
import matplotlib.pyplot as pl
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from datetime import datetime as dt

class MyApp(QWidget) :
    
    def __init__(self) :        # 초기값 설정
        
        super().__init__()
        
        self.row = 7
        self.col = 7
        
        self.item_name = ""
        self.btn = "off"
        
        self.connect_db()
        self.initUI()
        
    def initUI(self) :          # 구성요소 설정
    
        layout = QHBoxLayout()
        
        left = QVBoxLayout()
        right = QVBoxLayout()
        
        lo_top = QHBoxLayout()
        lo_mid = QVBoxLayout()
        lo_bot = QVBoxLayout()
        
        lo_write = QHBoxLayout()
        
        layout.addLayout(left, stretch = 5)
        layout.addLayout(right, stretch = 1)
        left.addLayout(lo_top)
        left.addLayout(lo_mid)
        left.addLayout(lo_bot)
        lo_mid.addLayout(lo_write)
        
        self.txt_1 = QLineEdit()
        self.btn_1 = QPushButton("File Choose..")
        
        lo_top.addWidget(self.txt_1, stretch = 4)
        lo_top.addWidget(self.btn_1, stretch = 1)
        
        self.btn_1.clicked.connect(self.btn_clicked)
        
        self.txt_1.setEnabled(False)
        self.txt_1.setAlignment(Qt.AlignCenter)
        self.txt_1.setText("HOST: 127.0.0.1 | DB: STUDY")
        self.btn_1.clicked.connect(self.load_data)
        
        self.fig_2 = pl.Figure()
        self.canvas_2 = FigureCanvas(self.fig_2)
        
        lo_mid.addWidget(self.canvas_2)
        
        self.ln_2_1 = QLineEdit(f"{dt.now().strftime('%y-%m-%d %H:%M')}")
        self.ln_2_2 = QLineEdit("")
        self.ln_2_3 = QLineEdit("")
        self.ln_2_4 = QLineEdit("")
        self.ln_2_5 = QLineEdit("")
        self.ln_2_6 = QLineEdit("")
        self.ln_2_7 = QLineEdit("")
        self.btn_2 = QPushButton("WRITE")
        
        lo_write.addWidget(self.ln_2_1)
        lo_write.addWidget(self.ln_2_2)
        lo_write.addWidget(self.ln_2_3)
        lo_write.addWidget(self.ln_2_4)
        lo_write.addWidget(self.ln_2_5)
        lo_write.addWidget(self.ln_2_6)
        lo_write.addWidget(self.ln_2_7)
        lo_write.addWidget(self.btn_2)
        
        self.btn_2.clicked.connect(self.insert_line)
        
        self.tbl_3 = QTableWidget(self.row, self.col)
        
        lo_bot.addWidget(self.tbl_3)
        
        self.lst_4 = QListWidget()
        self.lst_4.addItems(self.name)
        
        right.addWidget(self.lst_4)
        
        self.lst_4.itemClicked.connect(self.load_data)
        
        self.setLayout(layout)
        self.setWindowTitle("DB CONNECT PRACTICE")
        self.setGeometry(10, 30, 930, 700)
        self.show()
        
    def connect_db(self):           # 초기 설정에서 db 연결
        
        self.con = sql.Connect(host = '127.0.0.1', user = 'root', password = 'bigdatar', db = 'study', charset = 'utf8')
        self.cursor = self.con.cursor()
        
        self.cursor.execute("SHOW TABLES")
        temp = self.cursor.fetchall()
        self.name = []
        
        for i in temp: self.name.append(i[0])
        
    def insert_line(self):          # 테이블에 값을 넣어주는 함수
        
        t2 = float(self.ln_2_2.text())
        t3 = float(self.ln_2_3.text())
        t4 = float(self.ln_2_4.text())
        t5 = float(self.ln_2_5.text())
        t6 = float(self.ln_2_6.text())
        t7 = float(self.ln_2_7.text())
        
        self.cursor.execute(f'INSERT INTO {self.item_name} VALUES (sysdate(), %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f)' % (t2, t3, t4, t5, t6, t7 ))
        self.con.commit()
        QMessageBox.about(self, "INSERT", "COMPLETE!")
        
        self.load_data()
        
    def btn_clicked(self):          # 조회 버튼이 눌리면 조회 (처음 말고는 쓸모 없음)
        
        if self.item_name == "" :
            
            self.item_name = self.name[0]
            self.btn = "on"
            
        else: self.btn = "off"
        
        self.load_data()
        
        
    def load_data(self):            # 사용자의 작동에 따라 데이터 가져오기
        
        if self.btn == "off": self.item_name = self.lst_4.currentItem().text()
        
        self.txt_1.setText(f"HOST: 127.0.0.1 | DB: STUDY | TABLE: {self.item_name.upper()}")
        
        self.cursor.execute(f"Select * from {self.item_name}")
        self.data = self.cursor.fetchall()
        
        self.row = len(self.data)
        self.col = len(self.data[0])
        
        self.tbl_3.setRowCount(self.row)
        self.tbl_3.setColumnCount(self.col)
        
        self.date = []
        self.Temp1 = []
        self.Temp2 = []
        self.Temp3 = []
        self.Temp4 = []
        self.Temp5 = []
        self.Temp6 = []
        
        self.col_list = ["date", "Temp1", "Temp2", "Temp3", "Temp4", "Temp5", "Temp6"]
        
        for i in self.data:
            
            self.date.append(i[0].strftime("%H:%M"))
            self.Temp1.append(i[1])
            self.Temp2.append(i[2])
            self.Temp3.append(i[3])
            self.Temp4.append(i[4])
            self.Temp5.append(i[5])
            self.Temp6.append(i[6])
            
        self.load_graph()
        
    def load_graph(self):               # 데이터를 토대로 그래프 그리기
        
        self.fig_2.clear()
        
        ax = self.fig_2.add_subplot(111)
        
        ax.clear()
        ax.plot(self.date, self.Temp1, 'r-', label = 'TEMP1')
        ax.plot(self.date, self.Temp2, 'g-', label = 'TEMP2')
        ax.plot(self.date, self.Temp3, 'b-', label = 'TEMP3')
        ax.plot(self.date, self.Temp4, 'm-', label = 'TEMP4')
        ax.plot(self.date, self.Temp5, 'c-', label = 'TEMP5')
        ax.plot(self.date, self.Temp6, 'y-', label = 'TEMP6')
        ax.set_ylim((-40, 70))
        ax.set_xticks([])
        ax.legend(loc = 'upper center', ncols = 6)
        
        self.canvas_2.draw()
        
        self.load_table()
        
    def load_table(self):               # 데이터를 토대로 테이블 표시
        
        self.tbl_3.setHorizontalHeaderLabels(self.col_list)
        
        for i in range(self.row):
            
            item = QTableWidgetItem(str(self.data[i][0]))
            item.setTextAlignment(Qt.AlignHCenter)
            
            self.tbl_3.setItem(i, 0, item)
                        
            for j in range(1, 7):
                
                jtem = QTableWidgetItem(str(self.data[i][j]))
                jtem.setTextAlignment(Qt.AlignHCenter)
                
                self.tbl_3.setItem(i, j, jtem)
   
    
if __name__ == '__main__' :             # 메인 루틴
    app = QApplication(sys.argv)
    ex = MyApp()
    sys.exit(app.exec_())