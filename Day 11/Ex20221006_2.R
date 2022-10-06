# 기술통계 연습문제

desc <- read.csv(file.choose(), header = T)

str(desc)
summary(desc)

# 명목척도인 type과 pass 에 대해 빈도분석 수행 후 막대그래프와 파이 차트로 시각화

type <- table(desc$type)                      # 빈도수 확인
type

pass <- table(desc$pass)
pass


barplot(type)                                 # 막대차트
barplot(pass)

pie(type)                                     # 파이차트
pie(pass)


# 비율척도 변수인 나이에 대해 평균, 표준편차와 비대칭도 통계량 구한 후 히스토그램 작성 비대칭도 통계량 설명
# ( + ) 나이에 대한 밀도분포 곡선과 정규분포 곡선으로 정규분포 검정

library(moments)                              # 비대칭도 패키지

age <- desc$age

summary(age)                                  # 평균은 53.88

sd(age)                                       # 표준편차는 6.813247

sk <- skewness(age)                           # 왜도는 0.380489189753946
ku <- kurtosis(age)                           # 첨도는 1.8666225878227

hist(age, freq = F)                           # 나이 밀도 그래프의 정규분포 선과 밀도 선을 비교하면
lines(density(age))                           # 왜도가 양수인 것에서 알 수 있듯이 왼쪽으로 치우친 편이고
                                              # 첨도가 0보다 큰 것으로 알 수 있듯이 좀 더 비교적 뾰족한 것을 알 수 있다.
x <- seq(40, 70, 0.1)

curve(dnorm(x, mean(age), sd(age)), col = "blue", add = T)
                                              # 정규분포 함수를 이용하여 정규분포 곡선 그리기



