# 연습 문제

# 프로모션을 진행 전 후 구매비율이 15% 향상되었는가

# 귀무가설 : 구매비율이 차이가 없다.
# 연구가설 : 구매비율이 차이가 있다.

tv <- read.csv(file.choose(), header = T)
str(tv)                                         # buy 1 구매하지 않음 2 구매함
table(tv$buy)

binom.test(10, 50, p = 0.15)                    # 이항 분포 비율 검정

# P가 0.321 이므로 0.05보다 크기에 차이가 없다고 볼 수 있다.


# 중학교 2학년 여학생의 평균 키가 148.5 로 알려져 있는데,
# 50명을 표본으로 선정하여 평균 차이를 비교하시오

# 단일 집단간 평균 차이 검정 ( 단일 표본 T-검정 )

height <- read.csv(file.choose(), header = T)

h <- height$height

summary(h)                                      # 결측치 확인

mean(h)                                         # 평균 : 149.4

shapiro.test(h)                                 # p : 0.0001853 이므로 정규분포를 따른다.

t.test(h, mu = 148.5)                           # p : 0.1212 이므로 모집단과 차이가 있다.


# 대학에 진학한 남 여 별 대학에 대해 만족도 차이가 있는가

cam <- read.csv(file.choose(), header = T)
str(cam)
summary(cam)

table(cam$gender)
table(cam$gender, cam$survey)

prop.test(c(138, 107), c(174, 126))             # p : 0.2765 이므로 차이가 없다.


# 교육 방법에 따른 성적 차이가 있는가

tm <- read.csv(file.choose(), header = T)
str(tm)
summary(tm)                                     # 결측치 확인

t <- subset(tm, !is.na(score), c(method, score))

t1 <- t$score[t$method == 1]
t2 <- t$score[t$method == 2]

var.test(t1, t2)                                # p : 0.8494 이므로 동질적이다.

t.test(t1, t2)                                  # p : 1.303e-06 이므로 방법 1과 방법 2에 대한 성적 평균에는 차이가 있다.
t.test(t1, t2, alternative = "less")
                                                # p : 6.513e-07 이므로 방법 1 보다 방법 2 에 대한 성적 평균이 높다.