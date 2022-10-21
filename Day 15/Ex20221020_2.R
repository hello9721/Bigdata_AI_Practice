
# 인공신경망

# 경험과 학습을 통해서 패턴을 발견하고 이를 통해 특정 사건을 일반화 데이터를 분류하는데 이용됨.
# 입력신호를 받아 가중치를 적용하고 입력신호와 가중치를 이용하여 망의 총합을 계산하고,
# 활성 함수를 이용하여 망의 총합을 출력신호에 보낸다.

df <- data.frame( x2 = c(1:6), x1 = c(6:1), y = factor(c('no', 'no', 'no', 'yes', 'yes', 'yes')))
df

# x1, x2 는 입력변수, y는 출력변수

m_net <- nnet(y ~ ., df, size = 1)
m_net

m_net$fitted.values                     # 적합값이 점점 높아짐.

p <- predict(m_net, df, type = "class") # 예측치 생성

table(p, df$y)                          # 혼돈 매트릭스 생성



data("iris")

idx <- sample(1:nrow(iris), 0.7 * nrow(iris))
                                        # 7:3 학습 : 검정

train <- iris[idx, ]
test <- iris[-idx, ]

# nnet을 이용한 신경망

iris1 <- nnet(Species ~ ., train, size = 1)
iris2 <- nnet(Species ~ ., train, size = 3)

a <- predict(iris1, test, type = "class")
b <- predict(iris2, test, type = "class")

table(a, test$Species)
table(b, test$Species)

( 15 + 16 )/ nrow(test)                 # 68.9%
( 15 + 16 + 13 )/nrow(test)             # 97.8%


# neuralnet을 이용한 신경망

library(neuralnet)

# 위에서 생성한 학습, 검정 데이터 사용
# neuralnet은 문자열은 안되고 수치형으로 사용해야하기 때문에 데이터 리코딩
# 문자열을 수치형으로 바꾸고 문자열을 지워준다.

train$Species2[train$Species == "setosa"] <- 1
train$Species2[train$Species == "versicolor"] <- 2
train$Species2[train$Species == "virginica"] <- 3

train$Species <- NULL

test$Species2[test$Species == "setosa"] <- 1
test$Species2[test$Species == "versicolor"] <- 2
test$Species2[test$Species == "virginica"] <- 3

test$Species <- NULL

# 정규화 함수

nor <- function(x) {
  
  return ((x - min(x))/(max(x) - min(x)))
  
}

n_train <- as.data.frame(lapply(train, nor))
n_test <- as.data.frame(lapply(test, nor))

# 인공신경망 모델 생성

m_net <- neuralnet(Species2 ~ ., data = n_train, hidden = 1)
plot(m_net)                             # 시각화

# 예측치 생성

m <- compute(m_net, n_test[c(1:4)])     # Species2를 제외한 부분 예측치 생성
m

cor(m$net.result, n_test$Species2)      # 예측치와 관측치의 상관관계의 강도 측정을 통해 분류정확도 확인
                                        # 98%
m_net2 <- neuralnet(Species2 ~ ., n_train, hidden = 2, algorithm = "backprop", learningrate = 0.01)
                                        # backprop 역전파 알고리즘을 통해 모델 생성. ( 학습비율 1% )

m2 <- compute(m_net2, n_test[c(1:4)])
cor(m2$net.result, n_test$Species2)     # 98%
