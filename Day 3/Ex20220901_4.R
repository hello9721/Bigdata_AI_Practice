# 6 주요 내장함수

# 기술 통계량 처리 관련

x <- c(55,62,57,11,24,8,6,8,95,44,100)

min(x)            # 최소값
max(x)            # 최대값

mean(x)           # 평균
median(x)         # 중앙값

sum(x)            # 총 합계
sd(x)             # 표준 편차
sample(x, 3)      # 3개의 샘플데이터를 뽑음음 
table(x)          # 빈도수
summary(x)        #기초 통계량

library(RSADBE)
data("Bug_Metrics_Software")
                  # 샘플 데이터셋 불러오기

rowSums(Bug_Metrics_Software[ , , 1])
                  # 행 기준 합계
rowMeans(Bug_Metrics_Software[ , , 1])
                  # 행 기준 평균
colSums(Bug_Metrics_Software[ , , 1])
                  # 열 기준 합계
colMeans(Bug_Metrics_Software[ , , 1])
                  # 열 기준 평균

# rnorm(변량수, 평균, 표준편차) -> 정규분포의 난수 생성
# runif(변량수, 최소, 최대) -> 균등분포의 난수 생성
# rbinom(변량수, 범위, 확률) -> 이항분포의 난수 생성

data <- rnorm(1000, mean = 5, sd = 1)
                  # 1000개의 평균이 5이고 표준편차가 1인 데이터들
hist(data)        # 그래프를 나타내는 함수. 해당 함수는 정규분포를 띄게 된다.

data <- runif(1000, 0, 10)
                  # 1000개의 최소가 0이고 최대가 10인 데이터들
hist(data)        # 균등 분포

data <- rbinom(1000, 2, 0.5)
                  # 1000개의 0이나 1이나 2인 데이터들
                  # 확률이 작아질 수록 0이 더 많이 나오고
                  # 확률이 커질 수록 2가 더 많이 나온다.
hist(data)        # 이항 분포

# set.seed(임의의 정수) -> 정수를 종자값으로 동일한 난수 생성

set.seed(100)
rnorm(3, mean = 5, sd = 1)
                  # 4.497808 5.131531 4.921083
set.seed(100)
rnorm(3, mean = 5, sd = 1)
                  # 4.497808 5.131531 4.921083
                  # 종자값이 같으면 난수가 같다.


# 수학 관련

abs(x)            # 절대값
sqrt(x)           # 제곱근
ceiling(x)        # 올림
floor(x)          # 내림
round(x)          # 반올림


# 행렬연산 관련

cbind(x, y)       # 열 기준으로 병합
rbind(x, y)       # 행 기준으로 병합
