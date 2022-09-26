# ggplot2 패키지

install.packages("ggplot2")               # 패키지 인스톨
library(ggplot2)

# 자주 쓰는 샘플 내장 데이터
# quakes, iris, VADeaths, Chem97, airquality, mpg, mtcars, diamonds ...

data(mpg)                                 # 샘플 데이터

head(mpg)
tail(mpg)

str(mpg)
summary(mpg)

# 1 qplot() (== Quick plot)
# qplot( x ~ y, data [, facets, geom, stat, position, xlim, ylim, log, main, xlab, ylab, asp])
# 점, 선, 다각형 등 기하학적 객체를 크기, 모양, 색상 등 미적요소를 맵핑하여 그래프 표시

# 변수 1개
# qplot( x, data)
# y는 갯수로 표시

qplot( hwy, data = mpg, fill = drv )      # 도수 분포를 세로 막대 그래프로 표시
                                          # fill => 그래프를 설정한 열의 데이터에 따라 색 채우기

qplot( hwy, data = mpg, fill = drv, binwidth = 3 )
                                          # binwidth => 막대의 폭 지정

qplot(hwy, data = mpg, fill = drv, facets = . ~ drv, binwidth = 3)
                                          # facets = 행 ~ 열 -> 각 행 혹은 열에 지정된 열의 종류만큼으로 패널을 나누어 표시

qplot( hwy, data = mpg, fill = drv, facets = drv ~ .)

# 변수 2개
# qplot( x, y, data )
# x와 y에 따른 그래프

qplot( displ, hwy, data = mpg, color = drv, facets = drv ~ .)
                                          # 위의 fill 역할을 color가 한다.
                                          # f는 대체로 엔진이 작아 고속도로 연비가 높고
                                          # r은 대체로 엔진이 커서 고속도로 연비가 비교적 낮고
                                          # 4은 엔진 크기가 여러 범위에 걸쳐 있고 엔진 크기가 클수로 연비가 낮아진다.

# 미적 요소 맵핑

data(mtcars)

head(mtcars)
str(mtcars)
summary(mtcars)

qplot(wt, mpg, data = mtcars, color = factor(carb), size = qsec, shape = factor(cyl))
                                          # color => 해당 열의 종류에 따라 색 다르게
                                          # ( 변수 1개 -> fill / 변수 2개 -> color)
                                          # size => 해당 열의 종류에 따라 크기 다르게
                                          # shape => 해당 열의 종류에 따라 모양 다르게

# 기하학적 객체 적용
# geom 속성으로 설정 할 수 있는데,
# 변수가 1개 일때는 bar, 2개일때는 point가 기본 설정이다.

data(diamonds)

head(diamonds)
str(diamonds)
summary(diamonds)

qplot(clarity, data = diamonds, colour = cut, geom = "bar")
                                          # 전체 색을 입히는 fill과는 달리 colour은 테두리 색만 표시

qplot(wt, mpg, data = mtcars, geom = c("point", "smooth"))
                                          # smooth는 부드러운 곡선으로 흐름, 추세선 표시
                                          # c를 이용하여 두가지 이상의 geom을 표현할수 있다.

qplot(mpg, wt, data = mtcars, color = factor(cyl), geom = c("point", "line"))
                                          # line은 직선으로 표시
                                          # color 속성으로 인해 색에 따라 (== cyl에 따라 ) 끊어진 직선으로 표시된다.
                                          

# 2 ggplot()

# ggplot(data, aes(x, y, color = col)) -> 미적 요소 맵핑
# 하나의 그래프 위에 + 연산자를 통해 새로운 레이어에 다른 그래프를 더할 수 있다.

p <- ggplot(diamonds, aes(carat, price, color = cut))
p                                         # x축 = catat, y축 = price 로 설정됨.

p + geom_point()                          # 축 설정을 한 p에다가 point 차트(산점도) 추가
                                          # 앞에서 color는 cut으로 설정 하였기에 색은 cut에 따라 표시

q <- ggplot(mtcars, aes(mpg, wt, color = factor(cyl)))
q + geom_smooth() + geom_point()          # q에 설정한 축과 색에 따라 smooth 차트와 point 차트가 표시


r <- ggplot(diamonds, aes(price))
r + stat_bin(aes(fill = cut), geom = "bar")
                                          # stat_bin 을 통해 히스토그래프 (bar) 뿐 만 아니라 미적요소도 추가 가능

r + stat_bin(aes(fill=..density..))
                                          # ..density..를 통해 밀도에 따른 색 변화를 줄수 있다.

r + stat_bin(aes(fill = cut), geom = "area")
                                          # 영역형으로 그래프 표시

r + stat_bin(aes(color = cut, size = ..density..), geom = "point")
                                          # stat_bin의 geom 속성을 이용시 x축만 주어지더라도 point 그래프 표시 가능
                                          # 이때는 fill이 아닌 color로 적용해야함

library(UsingR)
data("galton")                            # 샘플 데이터 로드 및 구조 파악

head(galton)
str(galton)

t <- ggplot(galton, aes(parent, child))
t + geom_count()                          # count => 해당 위치에 그려진 점이 많을 수록 점의 크기가 큰 산점도

t + geom_count() + geom_smooth(method = "lm")
                                          # method = "lm" => 회귀선 적용
                                          # x가 y에 영향을 미치는 정도를 회귀선과 보조선으로 표시
                                          # 보조선의 퍼짐 정도가 회귀선의 예측치와 관측치의 오차 범위

graph <- p + geom_point() + ggtitle("다이아몬드 무게와 가격의 상관관계")
print(graph)
                                          # ggtitle => 그래프 제목 지정

g <- graph + theme(title = element_text(color = "darkgreen", size = 25),
                   axis.title.x = element_text(size = 15, color = "black"),
                   axis.title.y = element_text(size = 15, color = "black"),
                   legend.title = element_text(size = 15, color = "black"))


# 3 ggsave()
# ggsave(file = "저장할 경로/저장할 파일이름.확장자" [, dpi = n])
# dpi => 해상도
# ggplot2 패키지를 통해 그린 그래프를 pdf나 이미지로 저장할수 있도록 하는 함수

setwd("c:/bigdataR")

ggsave(file = "./graph.png")              # 가장 최근에 그린 그래프 저장

ggsave(file = "./graph2.png", dpi = 72, plot = graph)
                                          # plot에 설정된 그래프 저장
