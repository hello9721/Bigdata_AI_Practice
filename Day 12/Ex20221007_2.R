# 단일집단 검정
# 한개의 집단과 기존 집단과의 비율이나 평균 차이 검정
# 비율 차이 겁정은 빈도수에 대한 비율에 의미
# 평균 차이 검정은 표본 평균에 의미


# 귀무가설 : 기존 비율과 현재 비율에 차이가 없다.
# 연구가설 : 기존 비율과 현재 비율에 차이가 있다.

# 기존 불만율이 20% 라면 이번 불만율은 낮아졌는가?


# 단일 집단 비율 검정

data <- read.csv(file.choose(), header = T)
str(data)                                                   # survery -> 0 불만족 1 만족
summary(data$survey)                                        # 결측치 없음

t <- table(data$survey)                                     # 빈도수

install.packages("prettyR")                                 # freq()
library(prettyR)

freq(data$survey)                                           # 빈도수
                                                            # NA 포함 비율
                                                            # NA 제외 비율

# 불만율이 9.3% 이므로 낮아졌다고 말할 수 있다.

# 이항 분포 비율 검정
# binom.test( 관측치, 전체 횟수, p = 비교할 비율[, alternative, conf.level] )
# alternative -> "two.sided" 양측검정(작은지큰지보다는 단지 차이가 있는가), "less" 비교비율보다 작은가, "greater" 비교비율보다 큰가
# conf.level -> 0.95 95% 신뢰수준

t                                                           # 빈도수 - 불만족 14명

binom.test(14, 150, p = 0.2)

# number of successes = 14, number of trials = 150, p-value = 0.0006735
# 기본 값인 양측검정을 실행해 p가 0.05보다 작으므로 기존 불만율과 차이가 있다.

binom.test(14, 150, p = 0.2, alternative = "less", conf.level = 0.95)
                                                            # 신뢰수준 95%로 단측 검정 시행

# number of successes = 14, number of trials = 150, p-value = 0.0003179
# p가 0.05보다 작기에 기존 불만율보다 낮다는 것을 알 수 있다.

binom.test(14, 150, p = 0.2, alternative = "greater", conf.level = 0.95)
                                                            # 신뢰수준 95%로 단측 검정 시행

# number of successes = 14, number of trials = 150, p-value = 0.9999
# p가 0.05보다 크기에 기존 불만율보다 크지 않다는 것을 알 수 있다.


# 단일 집단 간 평균 검정 ( 단일 표본 T-검정 )
# t.test(표본, mu = 비교 평균[, alternative, paired, var.equal, conf.level])
# 단일 집단의 평균이 어떤 특정한 집단의 평균과 차이가 있는지를 검정
# 정규분포 여부를 판정후 결과에 따라 정규분포인 경우 모수 검정인 T-검정을 시행, 아닌경우 비모수 검정인 웰콕스 검정을 시행


# 귀무가설 : 국내생산노트북과 회사생산노트북의 평균 사용시간에는 차이가 없다.
# 연구가설 : 국내생산노트북과 회사생산노트북의 평균 사용시간에는 차이가 있다.

# 국내생산노트북 평균 사용시간 = 5.2

summary(data$time)                                          # 결측치 확인

x <- na.omit(data$time)

mean(x)

shapiro.test(x)                                             # 정규분포 검정
                                                            # 정규분포와 다르지 않다라는 귀무 가설을 채택
# W = 0.99137, p-value = 0.7242 
# p가 0.05보다 높기에 정규분포를 따른다.

par(mfrow = c(1,2))

hist(x)                                                     # 데이터 분포 확인
qqnorm(x)                                                   # 
qqline(x, lty = 1, col = "blue")                            # 추세선

t.test(x, mu = 5.2)                                         # 양측검정

# t = 3.9461, df = 108, p-value = 0.0001417
# p가 0.05보다 작으므로 차이가 있다.

t.test(x, mu = 5.2, alternative = "greater")                # 비교 평균보다 큰가

# t = 3.9461, df = 108, p-value = 7.083e-05
# p가 0.05보다 작으므로 크다.

t.test(x, mu = 5.2, alternative = "less")                   # 비교 평균보다 작은가

# t = 3.9461, df = 108, p-value = 0.9999
# p가 0.05보다 크므로 작지 않다.

# p 값과 df를 이용하여 귀무가설의 임계값(절대값)을 얻을 수 있다. ( t 검정의 t 값)
# qt(p, df)

abs(qt(7.083e-05, 108))                                     # t.test(x, mu = 5.2, alternative = "greater")
                                                            # 의 t 값과 비교

# t 값이 귀무가설 절대값보다 클 경우 귀무가설을 기각
