# 지도 공간 기법 시각화

# ggmap
# 온라인 소스로부터 가져온 정적인 지도 위에 데이터나 모형을 시각화

install.packages("ggmap")
library(ggmap)

# 1 stamen maps api
# 인증키 없이 사용할 수 있는 지도 api

# get_stamenmap(bbox = c(), zoom, maptype, crop, messaging = T/F,
#               urlonly = T/F, color = c(), force = T/F)

# bbox -> left/bottom/right/top 에 수치를 부여하여 지도 상자 위치 배치
# zoom -> 확대 비율
# maptype -> 지도 유형
# crop -> 원시 맵 타일을 크롭 한다. F이면 넘친다.
# urlonly -> URL 반환
# color -> 컬로 또는 흑백 -> "color", "bw"
# force 지도가 파일에 있으면 새지도를 찾는다 T 안찾는다 F

seoul <- c(left = 126.77, bottom = 37.40, right = 127.17, top = 37.70)

map <- get_stamenmap(seoul, zoom = 12, maptype = "terrain")
ggmap(map)                                # map에 지도 데이터를 받아 저장하고 ggmap으로 지도를 표시한다.

pop <- read.csv(file.choose(), header = T, fileEncoding = 'euc-kr')
                                          # 인구수 데이터 셋 로드
library(stringr)                          # replace_all 을 사용하기 위해 패키지 로드

region <- pop$지역명
lon <- pop$LON                            # 위도
lat <- pop$LAT                            # 경도
tot_pop <- as.numeric(str_replace_all(pop$총인구수, ',',''))
                                          # 수치에 있는 쉼표를 제거 후 num 타입으로 가져옴
df <- data.frame(region, lon, lat, tot_pop)
df <- df[1:17, ]                          # 지역 / 위도 / 경도 / 총인구수
df                                        # 마지막 행의 전체 행 삭제

daegu <- c(left = 123.4423013, bottom = 32.8528306, right = 131.601445, top = 38.8714354)
                                          # 대구를 중심으로한 내륙 지도 상자

map <- get_stamenmap(daegu, zoom = 7, maptype = "watercolor", force = T)

layer1 <- ggmap(map)                      # 지도 위에 데이터를 시각화 하기 위해 지도 이미지를 변수에 저장
layer1

layer2 <- layer1 + geom_point(data = df, aes(lon, lat, color = factor(tot_pop), size = factor(tot_pop)))
layer2                                    # layer1에 위도와 경도를 x, y 로 삼아 산점도를 그린다.

layer3 <- layer2 + geom_text(data = df, aes(lon + 0.01, lat + 0.08, label = region), size = 3)
layer3                                    # 지도 + 산점도 인 layer2에 텍스트를 더한다.

ggsave("./pop201901.png", scale = 1, width = 10.24, height = 7.68)
                                          # 사이즈를 지정하여 이미지 파일로 저장


# 연습 문제 1
# quakes를 이용하여 depth를 3개로, mag를 2개로 범주화 한 뒤
# depth와 mag를 동일한 패널해 지진의 발생지를 산점도로 시각화


library(lattice)

equal.count(quakes$depth, number = 3, overlap = 0)
                                          # 범위 확인
quakes$depth2[quakes$depth >= 39.5 & quakes$depth <= 139.5] <- 'D1'
quakes$depth2[quakes$depth >= 138.5 & quakes$depth <= 498.5] <- 'D2'
quakes$depth2[quakes$depth >= 497.5 & quakes$depth <= 680.5] <- 'D3'
                                          # 범위 나누기
equal.count(quakes$mag, number = 2, overlap = 0)

quakes$mag2[quakes$mag >= 3.95 & quakes$mag <= 4.65] <- 'M1'
quakes$mag2[quakes$mag >= 4.55 & quakes$mag <= 6.45] <- 'M2'

convert <- transform(quakes, depth2 = factor(depth2), mag2 = factor(mag2))
                                          # factor 로 변환 하여 범주화
xyplot(lat ~ long | depth2 * mag2, convert, col = c("red","blue"))
                                          # * 연산자로 같은 패널에 표시 되도록 산점도 그래프 표시\


# 연습 문제 2
#  latticeExtra 패키지에서 제공하는 SeatacWeather 데이터셋에서
# 월별 최저기온과 최고기온을 선 그래프로 표시 하시오

library(latticeExtra)
data("SeatacWeather")                     # 데이터 셋 로드

str(SeatacWeather)                        # 구조 확인

xyplot( max.temp ~ min.temp | month, SeatacWeather, type = "l")
                                          # x, y를 최고, 최저기온으로
                                          # month 별로 나누고
                                          # type = "l" 로 하여 선그래프로 표시


# 연습 문제 3
# iris 데이터 셋의 spal.Length와 Sepal.Width의 관계를 나타내는 그래프
# 품종별 다른 색상과 도형으로 표시

library(ggplot2)
data(iris)

str(iris)

layer1 <- ggplot(iris, aes(Sepal.Length, Sepal.Width, color = factor(Species), shape = factor(Species)))
layer1 + geom_point()


# 연습 문제 4
# iris 품종별 Petal.Length와 Petal.Width의 관계를 서로 다른 패널에 표시

xyplot(Petal.Length ~ Petal.Width | Species, iris)


# 연습 문제 5
# diamonds 데이터 셋에서 x에 carat, y에 price를 지정하고
# clarity를 선색으로 지정하여 산점도 그래프 주변에 부드러운 곡선이 추가 되도록 표시

data("diamonds")
str(diamonds)

layer2 <- qplot(carat, price, data = diamonds)
layer2 + geom_smooth(aes(color = clarity))

# 이게 맞나 모르겠음


# 연습문제 6
# 서울 중심 지도에 zoom = 11, maptype = "watercolor"
# 좌표 => lat, lon
# 학교명을 텍스트로 추가
# university.png로 파일 저장

uni <- read.csv(file.choose(), header = T, fileEncoding = "euc-kr")
                                              # 데이터셋 로드
str(uni)                                      # 구조 확인

df <- data.frame(region = uni$학교명, lon = uni$LON, lat = uni$LAT)

seoul <- c(left = 126.77, bottom = 37.40, right = 127.17, top = 37.70)
                                              # 서울 중심 지도 상자
library(ggmap)

map <- get_stamenmap(seoul, zoom = 11, maptype = "watercolor")
layer1 <- ggmap(map)
layer1 + geom_text(data = df, aes(lon, lat, label = region), size = 3)

ggsave(file = "./university.png", width = 10.24, height = 7.68)
