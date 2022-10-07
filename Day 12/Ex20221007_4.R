# 세 집단 검정


# 세 집단 비율 검정
# 세 집단 간의 비율이 같은지 혹은 다른지 검정

# 귀무가설 : 세 가지 교육 방법에 따른 만족율 차이가 없다.
# 연구가설 : 세 가지 교육 방법에 따른 만족율 차이가 있다.

data <- read.csv(file.choose(), header = T)
str(data)                                         # survey -> 0 불만족 1 만족
summary(data)                                     # 결측치 확인

m <- data$method
s <- data$survey

table(m)                                          # 1, 2, 3 모두 50개의 관측치
table(m, s)                                       # 방법에 따른 만족도 빈도수

# prop.test(c(집단1 관측치, 집단2 관측치, 집단3 관측치), c(집단1 총 횟수, 집단2 총 횟수, 집단3 총 횟수))\

prop.test(c(34, 37, 39), c(50, 50, 50))           # p가 0.05보다 높기에 만족율 차이가 없다.


# 분산 분석 (ANOVA Analysis / F-검정)

# T-검정과 동일하게 평균 차이 검정 방법
# 차이점은 T-검정은 두 집단 이었다면, F-검정은 세 집단 이상의 평균 차이를 검정한다.
# 가설 검정을 위해 F 분포를 따르는 F 통계량을 검정 통계량으로 사용하기 때문에 F-검정이라고 한다.

# 분류 >

# 일원 분산분석
# 1개의 범주형 독립변수와 종속변수 간의 관계 분석

# 이원 분산분석
# 두개 이상의 독립변수가 종속 변수에 미치는 효과 분석


str(data)
summary(data)

# 귀무가설 : 교육 방법에 따른 세 집단 간 점수 평균에 차이가 없다.
# 연구가설 : 교육 방법에 따른 세 집단 간 점수 평균에 차이가 있다.

data <- subset(data, !is.na(score), c(method, score))
                                                  # 결측치 제거

par(mfrow = c(1, 2))
plot(data$score)                                  # 그래프를 이용하여 이상치 확인
barplot(data$score)

data <- subset(data, score <= 20)                 # 이상치 제거
summary(data)                                     # 이상치 제거 확인

boxplot(data$score)

data$method[data$method == 1] <- "방법1"          # 리코딩
data$method[data$method == 2] <- "방법2"          # 사후검정에서 보기 쉽게 하기 위해해
data$method[data$method == 3] <- "방법3"

x <- table(data$method)                           # 교육 방법 별 빈도수
y <- tapply(data$score, data$method, mean)        # tapply(수치, 분류, 적용함수)

df <- data.frame(Method = x, Mean = y)            # 데이터프레임 생성
df

# 세 집단 동질성 검정
# bartlett.test(종속변수 ~ 독립변수, data = dataset)

bartlett.test(score ~ method, data = data)        # p가 0.05보다 크기에 동질적이다.

# 분산분석
# 동질적 -> aov() / 비동질적 -> kruskal.test()

# aov(종속 ~ 독립, data = dataset)

test <- aov(score ~ method, data = data)
summary(test)                                     # p 확인
                                                  # p 가 0.05보다 작으므로 차이가 있다.

# 사후 검정
# 분산분석의 결과로 집단별 평균 차에 대한 비교를 통해 사후검정 수행

TukeyHSD(test)
plot(TukeyHSD(test))

# 그래프를 보면 방법2-방법1 일때 평균의 차이가 2~3 으로 가장 크게 나타난다.

