
# 실습 2

# 삼성전자 종가 ( 2022.01.03 ~ 2022.09.30 ) 를 이용하여 신경망 생성
# 입력 10개 은닉 10개 출력 5개
# 학습 80% 검정 20%
# 평가 및 특정 구간 예측 해보기

# 정규화 -> 데이터 재구성 -> 인공신경망 학습 -> 데이터 예측 -> 모델 평가

data <- read.csv("data_5410_20221021.csv", header = T, fileEncoding = "euc-kr")

str(data)

cd <- data[ ,c(1:2)]                    # 원본 데이터에서 원하는 데이터만 추출

m <- max(cd$종가) - min(cd$종가)        # 정규화 시 분모 부분
norm <- ((cd$종가 - min(cd$종가))/m) * 0.9 + 0.05
summary(norm)                           # 정규화 완료

nd <- cbind(cd, norm)                   # 데이터프레임에 정규화 데이터 추가

input <- 10
hidden <- 10
output <- 5
iter <- 100

reData <- function(item, from, to, size) {
                                        # 데이터를 재구성 해주는 함수
  df <- NULL
  
  to <- to - size + 1
  
  for ( i in from:to ) {
    
    s <- i
    e <- s + size - 1
    
    df <- rbind(df, t(item[s:e]))
  
  }
  
  return (df)
  
}

n <- nrow(cd)

train <- nd[c(1:(n*0.8)), ]             # 학습 데이터와 검정 데이터 추출
test <- nd[c((nrow(train)+1):n), ]

                                        # 데이터 재구성
i_train <- reData(train$norm, 1, nrow(train)-output, hidden)
o_train <- reData(train$norm, 1 + hidden, nrow(train), output)

i_test <- reData(test$norm, 1, nrow(test)-output, hidden)
o_test <- reData(test$종가, 1 + hidden, nrow(test), output)

model <- nnet(i_train, o_train, size = hidden, maxit = iter)
                                        # 신경망 모델 생성

p <- predict(model, i_test)             # 검정데이터로 예측값 생성

b_p <- (((p - 0.05)/0.9) * m) + min(cd$종가)
                                        # 정규화된 데이터 복원

# 모델 평가

ERROR <- abs(o_test - b_p)              # MAPE 방식 -> 백분율로 비교
MAPE <- rowMeans(ERROR/o_test) * 100    # 개별 오차 비율
mean(MAPE)                              # 전체 오차 비율 평균 5.3%

# 특정 구간 예측

smp <- c(150:159)                       # 특정 구간 예측을 위한 샘플 데이터 인덱스 추출

course <- nd[smp, ]                     # 특정 구간 데이터 추출

p2 <- predict(model, course$norm)       # 예측값 생성
b_p2 <- (((p2 - 0.05)/0.9) * m) + min(cd$종가)
                                        # 정규화된 데이터 복원
er <- abs(nd$종가[160:164] - b_p2)
mean(er/nd$종가[160:164]) * 100         # 오차 비율 2.5%

plot(c(100:159), nd$종가[100:159], xlim = c(100, 164), ylim = c(30000, 80000), type = "o")
lines(c(160:164), b_p2, col = "red", type = "o")
                                        # 시각화