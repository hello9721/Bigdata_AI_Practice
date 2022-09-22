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
# urlonly -> ㅕ기 qksghks
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

