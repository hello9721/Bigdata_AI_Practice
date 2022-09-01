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