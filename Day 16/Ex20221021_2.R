
# 실습

# 종합 주가지수 예측
# 한국 거래소의 개별지수 시세 추이 데이터 ( 코스피, 2022.01 ~ 2022. 06 ) 사용

# 종가 : 주식거래 당일 맨 마지막 거래가 체결된 가격

# 정규화 -> 데이터 재구성 -> 인공신경망 학습 -> 데이터 예측 -> 모델 평가

library(nnet)                                         # 인공 신경망 모델 생성 패키지

setwd("C:/bigdataR/data")

data <- read.csv("data_1806_20221021.csv", header = T, fileEncoding = "euc-kr")
str(data)

c_data <- data[1:2]                                   # 일자, 종가만 사용
c_data$종가 <- as.numeric(c_data$종가)                # 숫자형으로 변환

c_data <- c_data[order(c_data$일자), ]                # 일자 기준 오름차순 정렬
row.names(c_data) <- c(1:nrow(c_data))                # 행번호 또한 정렬된 것에 맞게 오름차순 정렬
c_data

# 정규화 한 후 신경망에 적용 ( but 0이 들어가면 안됨 )
# 5% ~ 95% 사이의 값으로 들어가도록 정규화 ( 스케일 변경 )

m <- max(c_data$종가) - min(c_data$종가)              # 정규화 시킬때 분모

(c_data$종가 - min(c_data$종가)) / m                  # 정규화 수식 ( 0% ~ 100% 사이 )

((c_data$종가 - min(c_data$종가)) / m) * 0.9          # 원하는 범위 만큼 곱함 ( 0% ~ 90% 사이 )

((c_data$종가 - min(c_data$종가)) / m) * 0.9 + 0.05   # 원하는 최소 범위 만큼 더함 ( 5% ~ 95% 사이 )

pnorm <- ((c_data$종가 - min(c_data$종가)) / m) * 0.9 + 0.05
summary(pnorm)                                        # 정규화 완료

c_data <- cbind(c_data, pnorm)                        # 데이터에 정규화된 데이터 추가
c_data                                                # 나중에 분석할 때는 원래 데이터로 분석해야 하므로 원본 데이터 보존존

n <- nrow(c_data)
n80 <- round( n * 0.8 , 0)

c_learning <- c_data[1:n80, ]                         # 학습데이터 80%
c_test <- c_data[(n80+1):n, ]                         # 검정데이터 20%

# RNN 모델 생성 ( 순환 호출 )
# 인공신경망에서 처음 나온 출력값을 다음 입력값에 추가

INPUT_NODES <- 10                                     # 입력데이터 10개
HIDDEN_NODES <- 10                                    # 은닉데이터 10개
OUTPUT_NODES <- 5                                     # 출력데이터 5개

# 가중치 : 은닉데이터가 받게되는 입력데이터

ITERATION <- 100                                      # 반복할 학습 횟수

# 데이터셋 재구성 함수 구축

getDataSet <- function(item, from, to, size){         # 처리할 원본데이터, (어디서부터, 어디까지) -> 인덱스, 입력노드 갯수
  
  edf <- NULL   # 입력데이터가 쌓일 데이터프레임      # 학습데이터의 마지막이 97이어야 하는데,
                                                      # 출력데이터 5개를 감수 하면 입력데이터의 마지막 그룹의 마지막 값은 92.      
  to <- to - size + 1                                 # 그럼 마지막 그룹의 첫 값은 83 이어야 하기 때문에 to를 다시 계산.
  for (i in from:to){                                 # 그럼 1:83 구간만큼 진행하게 된다.
    
    s <- i
    e <- s + size - 1                                 # s:e 가 입력데이터 갯수인 10개가 되어야 한다.
    
    temp <- item[c(s:e)]                              # temp 에 임시로 item(벡터)의 s:e를 담고
    
    edf <- rbind(edf, t(temp))                        # 전치행렬로 행 단위로 edf에 계속 쌓아줌.
    
  }
  
  return (edf)
  
}


# 학습데이터 -> 신경망 구축 (nnet)

l_input <- getDataSet(c_learning$pnorm, 1, nrow(c_learning)-OUTPUT_NODES, INPUT_NODES)
                                                      # 학습 -> 입력데이터
l_output <- getDataSet(c_learning$pnorm, 11, nrow(c_learning), OUTPUT_NODES)
                                                      # 학습 -> 출력데이터

model <- nnet(l_input, l_output, size = HIDDEN_NODES, maxit = ITERATION)
                                                      # 신경망 모델 생성
                                                      

# 검정데이터 -> 예측값 추출

t_input <- getDataSet(c_test$pnorm, 1, nrow(c_test)-OUTPUT_NODES, INPUT_NODES)

t_output <- getDataSet(c_test$종가, 11, nrow(c_test), OUTPUT_NODES)


pre <- predict(model, t_input, type = "raw")


# 정규화된 데이터 복원                                # ((c_data$종가 - min(c_data$종가)) / m) * 0.9 + 0.05 을 역으로
                                                      # m = max(c_data$종가) - min(c_data$종가) 

back <- (((pre - 0.05)/0.9 ) * m ) + min(c_data$종가)

# 관측치와 예측값 비교
# MAPE 방식 사용
# 절대값을 비교하지 않고 백분율을 비교

ERROR <- abs(t_output - back)
MAPE <- rowMeans(ERROR/t_output) * 100                # 개별 오차 비율
mean(MAPE)                                            # 전체 오차 비율 평균 3.55%


# 일부 데이터 예측

in_forecasting <- c_data$pnorm[88:97]
in_forecasting                                        # 해당 데이터를 넣으면 이 다음 5개의 예측값이 추출됨

fore <- predict(model, in_forecasting, type="raw")
fore <- (((fore - 0.05)/0.9 ) * m ) + min(c_data$종가)

ERROR_fore <- abs(c_data$종가[98:102] - fore)
MAPE_fore <- rowMeans(ERROR_fore/c_data$종가[98:102]) * 100
                                                      # 오차 비율 5.15%

plot(71:98, c_data$종가[71:98], xlim = c(71, 102), ylim = c(1000, 3200), type = "o")
                                                      # 관측값 시각화
lines(98:102, fore, type = "o", col = "blue")         # 예측값 시각화
