# 두 집단 검정


# 두집단 비율 검정
# prop.test( c(집단1 관측치, 집단2 관측치), c(집단1 총횟수, 집단2 총횟수)[, alternative, conf.level, correct])
# 두 집단의 비율이 같은지 혹은 다른지 검정

# 귀무가설 : 두가지 교육 방법에 따라 교육생의 만족율에 차이가 없다.
# 연구가설 : 두가지 교육 방법에 따라 교육생의 만족율에 차이가 있다.

data <- read.csv(file.choose(), header = T) 
str(data)                                   # survey -> 0 불만족 1 만족
summary(data)                               # method와 survey에 결측치 없음

table(data$method, data$survey)             # 교육1 교육2에 따른 만족도 빈도수

prop.test(c(110, 135), c(150, 150))         # p가 0.05보다 작으므로 차이가 있다.

prop.test(c(110, 135), c(150, 150), alternative = "greater")
                                            # 1의 만족도가 2의 만족도보다 큰가
                                            # p가 0.05보다 크므로 크지 않다.

prop.test(c(110, 135), c(150, 150), alternative = "less")
                                            # 1의 만족도가 2의 만족도보다 작은가
                                            # p가 0.05보다 작으므로 작다.


# 두집단 평균 검정 (독립 표본 T-검정)
# 두 집단의 평균이 같은지 혹은 다른지 검정

# 귀무가설 : 교육 방법에 따른 두 집단 간 점수 평균에 차이가 없다.
# 연구가설 : 교육 방법에 따른 두 집단 간 점수 평균에 차이가 있다.

summary(data)                               # score에 결측치 확인

tdata <- subset(data, !is.na(score), c(method, score))
                                            # 점수가 결측치가 아닌 데이터 중 방법과 점수 열만 저장

case1 <- subset(tdata, method == 1)         # 결측치를 제거한 데이터 중 교육방법 1만 저장
case2 <- subset(tdata, method == 2)         # 결측치를 제거한 데이터 중 교육방법 2만 저장

mean(case1$score)                           # 평균 계산
mean(case2$score)

# 동질성 검정 ( 두 집단 간 분포의 모양이 동질적이다. )
# 평균은 달라도 분포는 비슷해야 비교 가능하기에 동질성 검정 필요
# 분포가 다르면 wilcox.test() 진행

var.test(case1$score, case2$score)

# 두 집단 평균 차이 검정

t.test(case1$score, case2$score)            # p가 0.05보다 작으므로 차이가 있다.

t.test(case1$score, case2$score, alternative = "greater")
                                            # p가 0.05보다 크므로 1은 2보다 크지 않다.
t.test(case1$score, case2$score, alternative = "less")
                                            # p가 0.05보다 작으므로 1은 2보다 작다.
                                            # conf.int = F 를 하면 신뢰구간 결과는 나오지 않는다.


# 대응 두집단 평균 검정 (대응 표본 T-검정)
# 동일한 표본으로 측정된 두 변수의 평균 차이 검정

# 귀무가설 : 프로그램 적용 전 학습력과 적용 후 학습력에 차이가 없다.
# 연구가설 : 프로그램 적용 전 학습력과 적용 후 학습력에 차이가 있다.

data <- read.csv(file.choose(), header = T)
str(data)
summary(data)                               # after에 결측치 확인

data <- subset(data, !is.na(after), c(before, after))
                                            # 결측치 제거
bef <- data$before                          # 데이터 분리
aft <- data$after

mean(bef)                                   # 평균 계산
mean(aft)

# 동질성 검사

var.test(bef, aft, paired = T)              # 대응되는 집단이기에 paired = T
                                            # p가 0.7361로 0.05 보다 크므로 두 집단의 분포가 동질적이다.

# 대응 두집단 평균 차이 검정

t.test(bef, aft, paired = T)                # p가 0.05보다 작기에 학습력 차이가 있다.

t.test(bef, aft, paired = T, alternative = "greater")
                                            # p가 0.05보다 크기에 1은 2보다 크지 않다.
t.test(bef, aft, paired = T, alternative = "less")
                                            # p가 0.05보다 작기에 1은 2보다 크다.
