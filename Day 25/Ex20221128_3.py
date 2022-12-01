# 한국환경공단의 미세먼지 정보를 테이블에 출력하고 그래프 표시
# 500 x 650 크기 윈도우 생성

from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
import sys
import requests as req
# import urllib.request as req
# import urllib.parse as pars
import bs4 as bs
import pandas as pd


class MyApp(QWidget) :                      # 클래스 정의

    key = '%2FsB%2B4nyywlmejmA0rBxb02w%2BxrxK3P17tIQb5iDWiPsMOB1Hzpm%2BvNDN%2BYg2pBtldu9aDkNHZ9N9KKGGgf6BCw%3D%3D'

    def __init__(self) :
        
        super().__init__()                  # 부모클래스 생성자 호출(가장 위쪽 코딩)
        self.initUI()
        
    def box_1_select(self):                 # 첫번째 콤보상자의 현재 상태가 바뀔때
        
        name = self.comb_box_1.currentText()
        self.ln_1.setText(name)
        self.current_region = name
        self.tbl_2.setColumnWidth(0, 154)
        
        if name != "지역선택":              # 조회 가능한 지역 목록 불러오기
            
            url = f'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?serviceKey={self.key}&returnType=xml&numOfRows=500&pageNo=1&sidoName={name}&ver=1.0'
            
            result = req.get(url, verify=False)
            soup = bs.BeautifulSoup(result.text, 'lxml')
            
            item = soup.find_all('item')
            
            
            self.comb_lst_2 = []
            self.comb_box_2.clear()
            for i in item: self.comb_lst_2.append(i.find('stationname').get_text())
            self.comb_box_2.addItems(self.comb_lst_2)
            
        elif name == "지역선택":
            
            self.comb_lst_2 = []
            self.comb_box_2.clear()
            self.ln_1.setText("")
            
    def box_2_select(self):                 # 두번째 콤보상자의 현재 상태가 바뀔때
        
        if self.comb_lst_2 != []:           # API에서 원하는 데이터 가져오기
        
            name = self.comb_box_2.currentText()
            self.ln_1.setText(self.current_region + " " +  name)
            
            self.tbl_2.clear()
            self.tbl_2.setHorizontalHeaderLabels(self.col_head)
            
            url = f'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey={self.key}&returnType=xml&numOfRows=20&pageNo=1&stationName={name}&dataTerm=DAILY&ver=1.0'
            
            result = req.get(url, verify=False)
            soup = bs.BeautifulSoup(result.text, 'lxml')
            
            item = soup.find_all('item')
            
            num = 0
            
            for i in item:                          # 테이블에 데이터 입력
                
                date = i.find('datatime').get_text()
                pm10 = i.find('pm10value').get_text()
                pm25 = i.find('pm25value').get_text()
                o3 = i.find('o3value').get_text()
                co = i.find('covalue').get_text()
                
                self.tbl_2.setItem(num, 0, QTableWidgetItem(date))
                self.tbl_2.setItem(num, 1, QTableWidgetItem(pm10))
                self.tbl_2.setItem(num, 2, QTableWidgetItem(pm25))
                self.tbl_2.setItem(num, 3, QTableWidgetItem(o3))
                self.tbl_2.setItem(num, 4, QTableWidgetItem(co))
                
                self.tbl_2.item(num, 0).setTextAlignment(Qt.AlignVCenter | Qt.AlignHCenter)
                self.tbl_2.item(num, 1).setTextAlignment(Qt.AlignVCenter | Qt.AlignHCenter)
                self.tbl_2.item(num, 2).setTextAlignment(Qt.AlignVCenter | Qt.AlignHCenter)
                self.tbl_2.item(num, 3).setTextAlignment(Qt.AlignVCenter | Qt.AlignHCenter)
                self.tbl_2.item(num, 4).setTextAlignment(Qt.AlignVCenter | Qt.AlignHCenter)
                
                
                num += 1
        
    def initUI(self) :                      # 윈도우 환경 구성
    
        layout = QVBoxLayout()              # 상자 배치관리자(최상위)
        
        area_1 = QHBoxLayout()              # 레이아웃 설정
        area_2 = QVBoxLayout()
        area_3 = QHBoxLayout()
        area_4 = QVBoxLayout()
        
        layout.addLayout(area_1)
        layout.addLayout(area_2)
        layout.addLayout(area_3)
        layout.addLayout(area_4)
        
        self.ln_1 = QLineEdit()                     # 텍스트 라인 상자 설정
                                                    # 첫번째 콤보 상자 리스트 설정
        self.comb_lst_1 = ['지역선택', '서울', '부산', '대구', '인천', '광주', '대전',
                           '울산', '경기', '강원', '충북', '충남', '전북', '전남',
                           '경북', '경남', '제주', '세종']
        self.comb_box_1 = QComboBox()
        self.comb_box_1.addItems(self.comb_lst_1)
        
        self.comb_lst_2 = []                        # box_1_select에서 값 정의
        self.comb_box_2 = QComboBox()
        
        area_1.addWidget(self.ln_1)
        area_1.addWidget(self.comb_box_1)
        area_1.addWidget(self.comb_box_2)
                                                    # 콤보상자 변화 있을 시 함수 실행
        self.comb_box_1.currentTextChanged.connect(self.box_1_select)
        self.comb_box_2.currentTextChanged.connect(self.box_2_select)
        
        self.tbl_2 = QTableWidget(20, 5)            # 테이블 설정
        self.col_head = ['Date', 'PM10', 'PM25', 'O3', 'CO']
        self.tbl_2.setHorizontalHeaderLabels(self.col_head)
        self.tbl_2.setColumnWidth(0, 154)
        
        area_2.addWidget(self.tbl_2)
        
        self.setLayout(layout)
        self.setWindowTitle('MyWindow')     # 윈도우 제목
        self.setGeometry(10, 30, 600, 676)  # 좌상단좌표, 너비, 높이
        self.show()                         # 윈도우 보이기
        
    
if __name__ == '__main__' :                 # 진입점 판단(운영체제에서 프로그램 호출)

    app = QApplication(sys.argv)
    ex = MyApp()                            # 클래스 객체 생성
    sys.exit(app.exec_())                   # 프로그램 실행상태 유지(윈도우 실행)
