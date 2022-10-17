
# 1 기계 학습

# 지도 학습 : 사람의 개입에 의한 학습 ( 확률과 통계기반 추론통계 )
# 비지도 학습 : 컴퓨터에 의한 기계학습 ( 패턴분석 기반 데이터 마이닝 )
# 시계열 분석


# 2 지도 학습

# 지도 학습의 절차
# 알고리즘 적용 > 학습데이터 > 모델 생성 > 검정데이터 > 평가 > 학습데이터 > ...


# 혼돈 매트릭스

# 기계학습에 의해 생성된 분류분석 모델의 성능을 지표화 시킨 테이블
# 관측치 -> 행 / 예측치 -> 열

# Y / Y -> TP ( 참 긍정 )
# Y / N -> FN ( 거짓 부정 )
# N / Y -> FP ( 거짓 긍정 )
# N / N -> TN ( 참 부정 )

# 정분류율 -> ( TP + TN ) / 전체합
# 오분류율 -> ( FN + FP ) / 전체합
# 정확률 -> TP / ( TP + FP )
# 재현율 -> TP / ( TP + FN )
# F1 -> 2 * (( 정확률*재현율 ) / ( 정확률+재현율 ))


# 회귀분석

# 특정 변수 ( 독립변수 ) 가 다른 변수 ( 종속변수 ) 에 어떠한 영항을 미치는 가를 분석
# 상관관계 분석 : 변수 간의 관련성 분석 / 회귀분석 : 변수 간의 인과관계 분석

# 독립변수와 종속변수 모두 등간척도 혹은 비율척도 여야함

# 회귀분석의 기본가정
# 1. 선형성 : 독립변수와 종속변수가 선형적. [ 회귀선 확인 ]
# 2. 잔차 정규성 : 잔차 ( 오차, 관측값과 회귀모델의 예측값 간의 차이 ) 의 기대값이 0
#                  정규분포를 이룸. [ 정규성 검정 확인 ]
# 3. 잔차 독립성 : 잔차들이 서로 독립적. [ 더빈-왓슨 값 확인 ]
# 4. 잔차 등분산성 : 잔차의 분산이 일정. [ 표준잔차와 표준예측치 도표 ]
# 5. 다중 공선성 : 다중 회귀분석을 수행할 시 3개 이상의 독립변수 간의 강한 상관관계로
#                  인한 문제가 발생하지 않아야함. [ 분산팽창요인(VIF) 확인 ]

# 회귀분석의 절차
# 1. 기본가정이 충족 하는지 확인
# 2. 분산분석의 F값으로 유의성 여부 판단
# 3. 독립변수와 종속변수 간의 상관관계와 회귀모형의 설명력 확인
# 4. t-값에 대한 유의확률을 통해 가설 채택 여부 결정
# 5. 회귀방정식을 적용하여 회귀식 수립 및 결과 해석


# 연구가설 : 제품적절성은 제품만족도에 영향을 미친다.
# 귀무가설 : 제품적절성은 제품만족도에 영향을 미치지 않는다.

product <- read.csv(file.choose(), header = T, fileEncoding = "euc-kr")
str(product)                                              # 샘플데이터 로드 및 구성확인

x <- product$제품_적절성                                  # 독립변수
y <- product$제품_만족도                                  # 종속변수

df <- data.frame(x, y)                                    # 데이터 프레임 생성

r <- lm(formula = y ~ x, data = df)                       # 단순 선형회귀 분석
r                                                         # 절편 = 0.7789
                                                          # 기울기 = 0.7393

# Intercept -> 절편( x가 0일때 y의 값 ) 
# x -> 기울기 ( x의 변화에 따른 y의 변화 정도)

# 회귀방정식 => Y = a + b * X
#                         == ( (종속변수) = (절편) + (기울기) * (독립변수) )

names(r)                                                  # 회귀분석 결과변수 목록

fitted.values(r)[1:2]                                     # 적합값 원소 2개 표시
                                                          # 회귀분석 적합값 함수
head(df, 1)                                               # 관측값 1개 표시

Y <- 0.7789 + 0.7393 * 4                                  # x가 4 일때 회귀방정식 적용하여 모델의 적합값 계산
                                                          # Y = 3.7361
                                                          # fitted.values 로 본 첫번째 적합값과 비슷
3 - 3.7361                                                # 잔차 = Y 관측값 - Y 적합값
                                                          # 잔차 = - 0.7361
residuals(r)[1:2]                                         # 모델의 잔차 확인 함수
                                                          # 계산한 잔차와 함수로 계산된 첫번째 잔차가 비슷함
-0.7359630 + 3.7359630                                    # 잔차 + 적합값 = 관측값
                                                          # 관측값 = 3
                                                          # 관측된 값과 같다.

plot(y ~ x, data = df)                                    # 산점도

r <- lm(formula = y ~ x, data = df)                       # 선형 회귀모델 생성
abline(r, col = "blue")                                   # 회귀선 그리기
                                                          # 시각화 완료

summary(r)                                                # 회귀분석 결과 확인
                                                          # residual standard error = 표준오차
                                     # Model Summary : R  # Multiple R-squared = 설명력 => 0.5881 = 58.81%
                                     # Model Summary : R2 # Adjusted R-squared = 오차 감안 조정된 R 값
                                                  # ANOVA # F-statistic => 374
                                                          # DF = 자유도 => 262
                                                  # ANOVA # p-value = F 값에 대한 유의확률
                                                          #           => 0.05 이하이기에 회귀선이 모델에 적합
                                                          # Coefficients의 x에 대한 t value => 19.340
                                                          # p-value = t 값에 대한 유의 확률
                                                          #           => 0.05 이하이기에 연구가설 채택


# 다중 회귀 분석

# 여러 개의 독립변수가 동시에 한개의 종속변수에 미치는 영향을 분석
# 공차한계와 분산팽창요인으로 인한 다중 공선성의 문제가 없는지 확인해야함

# 다중 공선성 : 한 독립변수의 값의 변화가 다른 독립변수에 관련되어 영향을 미치는 현상

# 어느 정도 상관관계의 다중 공선성을 대부분의 회귀분석에서 존재하지만,
# 강한 상관관계를 보이는 경우 회귀분석의 결과를 신뢰하기가 어려워진다.

# 이 경우 상관관계가 높은 독립변수 중 하나 혹은 일부를 제거 하거나 변수를 변형시켜 해결.


# 연구가설 : 제품적절성과 제품친밀도는 제품만족도에 영향을 미친다.
# 귀무가설 : 제품적절성과 제품친밀도는 제품만족도에 영향을 미치지 않는다.

x1 <- product$제품_적절성                                 # 독립변수 1
x2 <- product$제품_친밀도                                 # 독립변수 2
y <- product$제품_만족도                                  # 종속변수

df <- data.frame(x1, x2, y)                               # 데이터 프레임 생성

r <- lm( y ~ x1 + x2, df)                                 # 회귀분석
r                                                         # 절편 = 0.66731
                                                          # x1 기울기 = 0.68522
                                                          # x2 기울기 = 0.09593

install.packages("car")
library(car)                                              # 다중 공선성 문제 확인을 위한 패키지

vif(r)                                                    # x1 = 1.331929 / x2 = 1.331929
                                                          # 값이 10 이상이면 다중 공선성 문제를 의심

summary(r)


# 회귀분석 결과 분석

# 회귀방정식 => 제품만족도 = 0.6673 + 0.6852 * 제품적절성 + 0.0959 * 제품친밀도

# 제품적절성과 제품친밀도의 F 값에 대한 유의수준이 0.05 이하 이기에 회귀선이 모델에 적합
# 제품적절성과 제품친밀도의 t 값에 대한 유의수준이 0.05 이하 이기에 연구가설 채택

# 회귀분석의 설명력 => 0.5975 = 59.75%

# 두 독립변수 중 제품적절성이 0.68522로 제품친밀도보다 높은 값을 보이는 것으로 보아
# 제품적절성이 제품만족도에 더 큰 영향을 미친다고 할 수 있다.



# 다중 공선성 문제 확인 시 해결방법

data("iris")
str(iris)

# 연구가설 : 꽃잎의 넓이와 꽃받침의 길이와 꽃받침의 넒이는 꽃잎의 길이에 영향을 미친다.
# 대립가설 : 꽃잎의 넓이와 꽃받침의 길이와 꽃받침의 넒이는 꽃잎의 길이에 영향을 미치지 않는다.

model <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data = iris)
                                                          # 회귀 분석 시행
vif(model)                                                # 다중 공선성 확인
                                                          # Sepal.Width = 1.27 / Petal.Length = 15.10 / Petal.Width = 14.23
                                                          # Petal 데이터 끼리 다중공선성이 의심되는 수치
sqrt(vif(model)) > 2                                      # root(VIF) 가 2 이상인 것 확인 ( 다중 공선성 문제 의심 )

cor(iris[ , -5])                                          # 5열 (species) 제외한 나머지 변수간 상관계수

                                                          # Petal 데이터들 간의 강한 상관관계 확인
                                                          # 둘 중 하나 제외 후 회귀분석 실시

x <- sample(1:nrow(iris), 0.7*nrow(iris))                 # 전체 중 70%를 추출

train <- iris[x, ]                                        # 학습데이터 선정 ( 70% )
test <- iris[-x, ]                                        # 검정데이터 선정 ( 30% )

model <- lm(Sepal.Length ~ Sepal.Width + Petal.Length, data = train)
model                                                     # 학습 데이터로 회귀분석
                                                          # 절편 = 2.22 / S.W = 0.60 / P.L = 0.47
summary(model)

# 회귀 분석 결과 분석

# 회귀식 => Sepal.Length = 2.22 + 0.60*Sepal.Width + 0.47*Petal.Length

# F 값의 유의수준이 0.05 이하 이기에 회귀식이 적합
# t 값의 유의수준이 0.05 이하 이기에 연구가설 채택

# 이 회귀분석의 설명력은 83.89% 이고,
# 꽃받침의 길이보다 꽃잎의 넓이가 더 큰 영향을 미친다고 할 수 있다.

pre <- predict(model, test)                               # 예측치를 생성하는 함수에 검정데이터를 넣어 생성
pre

cor(pre, test$Sepal.Length)                               # 예측치와 검정데이터의 상관계수 확인
                                                          # 약 92% 로 높은 수치가 나타남.
                                                          # 분류 정확도가 매우 높다고 볼 수 있다.

# 기본 가정 충족으로 회귀분석

model <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, iris)
model

install.packages("lmtest")                                # 더빈-왓슨 값 확인을 위한 패키지
library(lmtest)

dwtest(model)                                             # DW = 2.0604 / p = 0.6013
                                                          # DW 가 1이상 3이하, p가 0.05 이상일때
                                                          # 독립성과 차이가 없다.

plot(model, which = 1)                                    # 등분산성 검정 -> 잔차와 적합값의 분포
                                                          # residuals의 0을 기준으로 fitted values의 분포가 좌우 균등하면
                                                          # 등분산성과 차이가 없다.

# which => 1 = 등분산성 그래프 / 2 = Normal Q-Q / 3 = Scale-Location /
#          4 = Cook's distance / 5 = Residuals vs Leverage / 6 = Cook's dist vs Leverage*hii/(1-hii)


re <- residuals(model)                                    # 잔차를 변수에 담고
shapiro.test(re)                                          # 정규성 검정
hist(re, freq = F)                                        # p = 0.93 이므로 0.05보다 크기에 정규성과 차이가 없다.

sqrt(vif(model)) > 2                                      # Petal 끼리 다중 공선성 문제 확인

model <- lm(Sepal.Length ~ Sepal.Width + Petal.Length, iris)
summary(model)

# 회귀분석 결과 분석

# 회귀식 => Sepal.Length = 2.2491 + 0.5955*Sepal.Width + 0.4719*Petal.Length

# F 값의 유의수준이 0.05 이하이므로 회귀식이 적합
# t 값의 유의수준이 0.05 이하이므로 연구가설 채택

# 이 회귀분석의 설명력은 84.02% 이고,
# 꽃받침 길이보다 꽃잎의 넓이가 더 큰 영향을 미친다.



# 로지스틱 회귀분석

# 종속변수와 독립변수 간의 관계를 나타내어 예측 모델 생성
# 종속변수로 나타날 수 있는 변수가 제한적

# 선형 회귀분석과는 달리 범주형 종속변수를 사용하기에,
# 회귀분석과 분류분석 모두에서 사용 가능

# 정규분포 보다는 이항분포를 따른다.

# 로짓 변환 : 종속변수의 출력범위를 0과 1로 조정

weather <- read.csv(file.choose(), stringsAsFactors = F)

summary(weather)

dim(weather)
head(weather)
str(weather)                                              # 내일의 날씨를 예측하는 모델을 생성할 것이기에
                                                          # 필요 없는 chr 칼럼들과 date, raintoday 칼럼 제거
df <- weather[ , c(-1, -6, -8, -14)]
str(df)                                                   # 로지스틱 회귀분석에 맞게 0, 1 로 로짓변환

df$RainTomorrow[df$RainTomorrow == "Yes"] <- 1
df$RainTomorrow[df$RainTomorrow == "No"] <- 0
df$RainTomorrow <- as.numeric(df$RainTomorrow)

df <- df[!is.na(df$Sunshine), ]                           # 결측치 제거
df <- df[!is.na(df$WindGustSpeed), ]

summary(df)

smp <- sample(1:nrow(df), nrow(df)*0.7)                   # 70:30 = 학습:검정
train <- df[smp , ]
test <- df[-smp, ]

str(train)
str(test)

model <- glm(RainTomorrow ~ ., train, family = 'binomial')
model                                                     # binomial = y가 이항형 변수

summary(model)                                            # 예측치와 비교

pre <- predict(model, newdata = test, type = "response")  # 검증데이터를 입력값으로, 확률 타입으로 나타냄.
pre                                                       # 1에 가까울수록 비올 확률이 높음
                                                          # 시그모이드 함수로 인해
r <- ifelse(pre >= 0.5, 1, 0)                             # 0.5를 기준, 그 이상이면 1, 이하면 0

table(r, test$RainTomorrow)                               # 분류정확도 계산 => (TP + NP) / 전체합
96/(88+8+8+5)                                             # 88%

install.packages("ROCR")
library(ROCR)                                             # 로지스틱 회귀모델 평가를 위한 패키지

p <- prediction(pre, test$RainTomorrow)
pf <- performance(p, measure = "tpr", x.measure = "fpr")
plot(pf)

