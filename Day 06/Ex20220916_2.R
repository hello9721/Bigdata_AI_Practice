# 고급 시각화 분석


# R의 고급 시각화 도구

# 1 격자형 기법 시각화

install.packages("lattice")
library(lattice)
install.packages("mlmRev")
library(mlmRev)
                                  # 고급 시각화와 chem97 데이터 셋을 위한 패키지 설치 및 로드

data(Chem97)
str(Chem97)
summary(Chem97)
                                  # 샘플 데이터 로드

# 히스토그램
# histogram( ~ x | 조건, data = data  ...)
# x축에 사용할 열 이름, data = 사용할 데이터셋 은 필수

histogram(~ gcsescore, data = Chem97)

histogram(~ gcsescore | factor(score), data = Chem97)
                                  # score을 factor로 나타내지 않으면 score의 범주에 따른 그래프가 아닌,
                                  # 그저 패널의 제목으로 score라는 텍스트가 나타난다.
                                  # 화학성적별 개인평균 성적

# 밀도 그래프
# densityplot( ~ x | 조건, data = data, groups = 변수)

densityplot(~ gcsescore | factor(score), data = Chem97, groups = gender, auto.key = T)
                                  # 화학 성적에 따른 성별 별 개인평균 성적 밀도

# 막대 그래프
# barchart( y ~ x | 조건, data = data, layout = c( panel, row ))

data("VADeaths")
str(VADeaths)

tab <- as.data.frame.table(VADeaths)
                                  # as.data.frame.table(data)
                                  # 데이터 프레임을 테이블 형식으로
                                  # rownames, colnames,values 순으로 데이터프레임 형식으로 변환
tab
VADeaths

barchart( Var1 ~ Freq | Var2, col = rainbow(20), data = tab, layout = c( 4, 1 ), origin = 0)
                                  # layout은 몇개의 panel을 몇개의 row에 표시할 건지 설정
                                  # origin은 x축 구간을 n부터 표시

# 점 그래프
# dotplot( y ~ x | 조건, data = data, layout = c( panel, row ))

dotplot(Var1 ~ Freq | Var2, tab)
                                  # layout = 2*2
dotplot(Var1 ~ Freq, tab, groups = Var2, type = "o", auto.key = list(space = "right", points = T, lines = T))
                                  # type => o == o와 선의 연결
                                  # 조건을 없애고 groups를 추가 하면 그래프가 하나의 패널에 표시
                                  # auto.key == 범례 => space 위치 | points 점 | lines 선 표시

# 산점도 그래프
# xyplot( y ~ x | 조건변수, data = data.frame 또는 list, layout = c( panel, row ))

library(datasets)
str(airquality)

xyplot( Ozone ~ Wind, data = airquality)

xyplot( Ozone ~ Wind | factor(Month), airquality, layout = c(5,1))
                                    # transform(data, colname = factor(colname))
                                    # 위를 사용해도 특정 col을 factor로 변환할수 있다.

str(quakes)

tplot <- xyplot( lat ~ long, data = quakes, pch=".")
                                    # pch == 점 모양 설정
                                    # 위도와 경도에 따른 지진 분포

tplot <- update(tplot, main = "1964년 이후 태평양에서 발생한 지진 위치")
print(tplot)
                                    # update = 추가적인 내용 업데이트
                                    # 변수에 저장된 그래프는 print로 출력

quakes$depth2[quakes$depth >= 40 & quakes$depth <= 150] <- 1
quakes$depth2[quakes$depth >= 151 & quakes$depth <= 250] <- 2
quakes$depth2[quakes$depth >= 251 & quakes$depth <= 350] <- 3
quakes$depth2[quakes$depth >= 351 & quakes$depth <= 450] <- 4
quakes$depth2[quakes$depth >= 451 & quakes$depth <= 550] <- 5
quakes$depth2[quakes$depth >= 551 & quakes$depth <= 680] <- 6
                                    
quakes

conv <- transform(quakes, depth2 = factor(depth2))
                                    # depth 라는 연속형 변수를 depth2라는 범주형으로 변환
                                    # depth2 만 factor로 바뀌어서 데이터 전체가 conv에 저장
xyplot(lat ~ long | depth2, data = conv)

xyplot(Ozone + Solar.R ~ Wind |factor(Month), data = airquality, layout = c(5,1))
                                    # y축 부분에 + 연산자를 사용하여 두개의 데이터를 넣으면
                                    # 동일한 패널에 두개의 변수 그래프를 표현 할 수 있다.

# 데이터 범주화

# equal.count(data, number = n, overlap = 0)
# 데이터를 겹치지 않게 n개 영역으로 범주화

# 예시
# numgroup <- equal.count(1:150, number = 4, overlap = 0)
# numgroup

depthgroup <- equal.count(quakes$depth, number = 5, overlap = 0)
depthgroup

xyplot(lat ~ long | depthgroup, quakes)
                                      # 범주화가 이루어져서 depth의 5 영역에 따라 지진 분포 표시
                                      # x, y 가 따로 데이터를 품고 있다면 원본 데이터는 작성하지 안하도 된다. 

magnitudegroup <- equal.count(quakes$mag, number = 2, overlap = 0)

xyplot(lat ~ long | magnitudegroup, quakes)

xyplot(lat ~ long | depthgroup * magnitudegroup, quakes)
                                      # mag 1 그룹에 따른 depth 5 그룹 / mag 2 그룹에 따른 depth 5 그룹

quakes$depth3[quakes$depth >= 39.5 & quakes$depth <= 80.5] <- 'D1'
quakes$depth3[quakes$depth >= 79.5 & quakes$depth <= 186.5] <- 'D2'
quakes$depth3[quakes$depth >= 185.5 & quakes$depth <= 397.5] <- 'D3'
quakes$depth3[quakes$depth >= 396.5 & quakes$depth <= 562.5] <- 'D4'
quakes$depth3[quakes$depth >= 562.5 & quakes$depth <= 680.5] <- 'D5'
                                
quakes$mag2[quakes$mag >= 3.95 & quakes$mag <= 4.65] <- 'M1'
quakes$mag2[quakes$mag >= 4.55 & quakes$mag <= 6.45] <- 'M2'
                                      # 아까 적용 시켰던 equal.count의 범위에 따라 레이블링

convert <- transform(quakes, depth3 = factor(depth3), mag2 = factor(mag2))
                                      # 원본 데이터에서 설정한 열만 다른 타입으로 변경

xyplot(lat ~ long | depth3 * mag2, convert, col = c("green", "darkblue"))


# 조건 그래프
# coplot( y ~ x | 조건 열, data)
# 조건에 의한 x에 대한 y 그래프

# row = n ( 한 행의 몇개의 패널을 표시 ) / number = n ( 패널 수 ) / overlap = n (겹치는 구간)

coplot(lat ~ long | depth, quakes, overlap = 0.1, rows = 2, number = 4)

coplot(lat ~ long | depth, quakes, overlap = 0.1, rows = 1, number = 4, panel = panel.smooth)
                                      # 패널 영역에 부드러운 곡선 추가

coplot(lat ~ long | depth, quakes, overlap = 0.1, rows = 1, col = 'orange', bar.bg = c(num = 'darkgreen'))
                                      # col => 그래프 색 / bar.bg = c(num = '') => 조건 막대 색

coplot(lat ~ long | mag, quakes, overlap = 0, number = 5, rows = 1, bar.bg = c( num = 'lightblue' ), col = 'darkgreen')


# 3차원 산점도 그래프
# cloud(z ~ y * x, data)

cloud(depth ~ lat * long, quakes, xlab = "경도", ylab = "위도", zlab ="깊이", zlim = rev(range(quakes$depth)))
                                      # zlim => z의 구간 / rev(range(data)) => 데이터의 구간을 뒤집어서(reverse) 표시

cloud(depth ~ lat * long, quakes, xlab = "경도", ylab = "위도", zlab ="깊이", screen = list(z = 45))
                                      # screen = list() => list 안쪽에서 설정한 x, y, z의 각도만큼 회전시켜서 그래프 표시
                                      # panel.aspect => 테두리 사이즈
