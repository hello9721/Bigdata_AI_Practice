# 확률 분포

# 확률변수가 가지는 확률의 구조
# 확률함수를 알기 위해서 확률분포를 알아야한다.
# 확률함수 -> 확률변수에 대해 확률을 계산하는 함수

# 이때까지의 수많은 실험과 분석에서 발견된 특정패턴을 정리한 것이 확률 분포 이론


# 이산형 확률분포

# 확률 질량 함수로 정의
# 특정한 사건이 발생할 확률
# 이항분포와 다항분포, 포아송 분포 등으로 나뉜다.


# 이항분포

# 베르누이 시행을 독립적으로 n번 반복했을 때 생성되는 분포
# 베르누이 시행 <- 배타적인 두 결과가 나오는 확률실험
# 베르누이 시행 시 관심있는 사건이 발생할 확률을 p, 다른 사건이 발생할 확률을 1-p라 정의
# ex) 동전 던지기

data <- read.csv(file.choose(), header = T)       # 샘플 데이터 로드

library(ggplot2)                                  # 시각화를 위한 패키지 로드
library(dplyr)                                    # group_by와 n()

str(data)                                         # waterfront -> 0 물 없음, 1 물 있음

p <- ggplot(data, aes( x = as.factor(waterfront), fill = as.factor(waterfront)))
                                                  # p 에 그래프 틀을 담기
                                                  # x만 설정하면 y는 자동으로 빈도수
p + geom_bar() + xlab("Water Front") + theme_bw() + labs(fill = "Water Front") + theme(legend.position = "bottom")
                                                  # 막대 그래프로 x 축 라벨은 Water Front, 범례의 라벨도 Water Front
                                                  # 블랙 앤 화이트 배경에 범례의 위치는 아래쪽

                                                  # 파이프 연산자 단축키는 ctrl + shift + M
a <- data %>% group_by(waterfront) %>% summarise(count = n()) %>% mutate(perc = count / sum(count))
                                                  # waterfront를 기준으로 그룹을 만들고 그룹별로 요약하는데 count에는 빈도수를 표시
                                                  # perc 라는 확률을 담은 파생 열을 추가


# 다항분포

# 실험결과가 3개 이상인 확률 실험을 독립적으로 반복 했을 때 각 범주에 속하는 횟수를 확률변수로 하는 분포
# A, B, C, D 가 있다면 확률은 p1, p2, p3, 1-p1-p2-p3 로 정의

p <- ggplot(data, aes( x = as.factor(floors), fill = as.factor(floors)))
                                                  # 틀 생성
p + geom_bar() + xlab("Floors") + labs( fill = "Floors" ) + theme_classic() + theme(legend.position = "bottom")
                                                  # 막대 그래프로 x 축 라벨 Floors, 범례 라벨 Floors, 클래식 테마로 범례위치는 아래쪽

b <- data %>% group_by(floors) %>% summarise(count = n()) %>% mutate(perc = count / sum(count))
                                                  # 데이터를 floors 기준으로 그룹화 한뒤 그 그룹대로 요약을 하고
                                                  # count에는 빈도수를 넣은뒤 perc 라는 확률을 담은 파생열 추가