# [1] 데이터 시각화

# 이산 변수 -> 막대, 점, 원형차트               >> ex) 이항분포...
# barplot, pie
# 보통 정수 값의 데이터

# 연속 변수 -> 상자 박스, 히스토그램, 산점도    >> ex) 정규분포, 균등분포 ...
# boxplot, hist, plot
# 이산변수에 비해 실수 값의 데이터


# 1 이산변수 시각화


# 세로 막대 그래프

chart_data <- c(222, 512, 845, 685, 375, 654, 854, 754)
                                                # 예시용 데이터
names(chart_data) <- c("2011년", "2012년", "2013년", "2014년", "2015년","2016년","2017년","2018년")
                                                # 칼럼명 지정
str(chart_data)                                 # 자료구조 확인
barplot(chart_data)                             # 세로막대그래프
barplot(chart_data, ylim = c(0, 1000))          # ylim = c(최소, 최대) -> 세로축 범위 설정
barplot(chart_data, col = rainbow(8))           # col = 색상 -> rainbow(n)은 n가지의 무지개색으로 설정
barplot(chart_data, main = "년도별 현황 비교")   # main = 제목 -> 차트 제목 지정
barplot(chart_data, ylab = "단위: 만원", xlab = "년도별 현황")
                                                # ylab = 세로축 제목, xlab = 가로축 제목

# 가로 막대 그래프

barplot(chart_data, horiz = T)                  # 가로막대그래프 -> horiz = T
barplot(chart_data, horiz = T, xlim = c(0, 1000))     
                                                # xlim = c(최소, 최대) -> 가로축 범위 설정


# 누적 막대 차트

data(VADeaths)                                  # 샘플 데이터 가져오기
VADeaths

str(VADeaths)
dim(VADeaths)

par(mfrow = c(1,2))                             # 1행에 2개의 그래프를 볼 수 있도록 한다.

barplot(VADeaths, beside = T, col = rainbow(5)) # 옆으로 나뉜다. (개별 차트) beside = T
legend(19, 71, c("50", "55", "60", "65", "70"), fill = rainbow(5))
barplot(VADeaths, beside = F, col = rainbow(5)) # 한줄로 쌓인다. (누적 차트) beside = F
legend(3.8, 200, c("50", "55", "60", "65", "70"), fill = rainbow(5))
                                                # legend는 범례를 표시해주는 함수
                                                # x좌표, y좌표, 문자열로 이루어진 범례명, 색구분

par(mfrow = c(1,2))                             # 1행에 2개의 그래프를 볼 수 있도록 한다.

barplot(VADeaths, beside = T, col = rainbow(5), ylim = c(0, 90))
legend("top", c("50", "55", "60", "65", "70"), ncol = 5, fill = rainbow(5))
barplot(VADeaths, beside = F, col = rainbow(5)) # legend에 ncol을 지정해주면 가로로 범례가 나온다.
legend("topright", c("50", "55", "60", "65", "70"), fill = rainbow(5))
                                                # 위치이름, 문자열로 이루어진 범례명, 색구분
                                                # top, bottom, left, right, topright, topleft, bottomright, bottomleft
title(main = "지역별 사망 빈도", font.main = 4)
                                                # title 함수로도 차트 제목 설정 가능, 폰트도 설정 가능


# 점 차트 그래프

chart_data <- c(222, 512, 845, 685, 375, 654, 854, 754)
names(chart_data) <- c("2011년", "2012년", "2013년", "2014년", "2015년","2016년","2017년","2018년")

dotchart(chart_data)                            # 점차트그래프

dotchart(chart_data, color = c("blue"))         # 세로축 레이블과 점 색 지정
dotchart(chart_data, lcolor = c("red"))         # 구분선 색 지정
dotchart(chart_data, labels = names(chart_data))
                                                # 이름이 지어지지 않은 데이터일 경우 레이블 이름 지정 가능
dotchart(chart_data, pch = 1:5)                 # 점 모양 지정 가능, 1:5 -> 1번부터 5번까지의 모양
                                                # 열 별로 번갈아가면서 모양 지정
dotchart(chart_data, xlab = "매출액", ylab = "분기별 현황")
                                                # 세로축과 가로축의 제목 지정
dotchart(chart_data, cex = 1.2)                 # 확대 배율


# 원형 차트 그래프

chart_data <- c(222, 512, 845, 685, 375, 654, 854, 754)
names(chart_data) <- c("2011년", "2012년", "2013년", "2014년", "2015년","2016년","2017년","2018년")

pie(chart_data)                                 # 원형차트그래프

pie(chart_data, col = rainbow(9), cex = 0.8, labels = names(chart_data), main = "분기별 매출 현황")


# 2 연속변수의 시각화


# 상자 그래프
# 데이터의 분포를 나타내는데 많이 사용.
# summary 함수의 내용을 시각화 한다고 생각하면 된다.

data(VADeaths)                                  # 샘플 데이터 가져오기
VADeaths

boxplot(VADeaths)                               # 상자그래프

boxplot(VADeaths, range = 0)                    # range = 0 은 최소값과 최대값을 점선으로 연결
                                                # 0이 디폴트
abline(h = 37, lty = 3, col = "green")          # 37 높이에 초록색으로 하여 스타일 3의 기준선을 그린다.


# 히스토그램
