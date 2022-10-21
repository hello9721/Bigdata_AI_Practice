
# 의사결정트리

# 자본이득에 영향을 미치는 변수 분석

library(arules)
data("AdultUCI")                                  # 샘플 데이터 로드

library(party)
library(ggplot2)

str(AdultUCI)

smp <- sample(1:nrow(AdultUCI), 10000)            # 전체 데이터의 수 중 10000개만 선택
df <- AdultUCI[smp, ]                             # 샘플 데이터 추출

c <- df$`capital-gain`                            # 변수 추출
h <- df$`hours-per-week`
e <- df$`education-num`
r <- df$race
a <- df$age
i <- df$income

df <- data.frame(capital = c, hours = h, education = e, race = r, age = a, income = i)

f <- capital ~ income + hours + education + race + age
a_ctree <- ctree(f, data = df)

plot(a_ctree)

# 소득이 가장큰 영향을 미치고 그다음으로는 교육수준, 주당 근무시간, 나이 순으로 영향을 미친다.
# 인종은 가장 영향을 미치지 못한다.

library(rpart)
library(rpart.plot)

data("iris")                                      # 샘플 데이터 로드

r <- rpart(Species ~ ., data = iris)              # rpart 의사결정트리
rpart.plot(r)                                     # rpart 의사결정트리 시각화



# 랜덤 포레스트

# 의사결정 트리에 앙상블 학습 기법을 적용한 모델
# 앙상블 학습기법 : 새로운 데이터에 대해서 여러개의 트리로 학습을 수행한 후 학습 결과들을 종합해서 예측하는 모델

library(randomForest)                             # 랜덤 포레스트 패키지

data("iris")                                      # 샘플 데이터 로드

m <- randomForest(Species ~ ., data = iris)       # 모델 생성
m
# Number of trees : n 개의 트리가 복원 추출방식으로 생성되어 학습 데이터로 쓰임
# ntree 속성으로 트리의 갯수 지정
# mtry 속성으로 변수의 갯수 지정

# 해당 랜덤 포레스트에서 오차 비율은 4%
# 혼돈 매트리스를 통해 분류정확도를 96% 로 계산 할 수 있다.

m <- randomForest(Species ~ ., data = iris, ntree = 300, mtry = 4, na.action = na.omit)
# ntree를 300, mtry를 4로 지정 -> 오차 비율 4.67%

m <- randomForest(Species ~ ., data = iris, importance = T )
importance(m)
# importance 속성을 T로 하면 가장 중요한 변수가 어떤 변수인가를 알려주는 역할을 한다.
# importance 함수를 통해 MeanDecreaseAccuracy (분류정확도) 를 개선하는데 기여한 변수를 수치로 제공하고
# 또한, MeanDecreaseGini (불확실성) 을 개선하는데 기여한 변수를 수치로 제공

varImpPlot(m)                                     # 중요 변수 시각화

