# 1 파생변수

setwd("C:/source/Part2")

user <- read.csv("user_data.csv", fileEncoding = "euc-kr")
pay <- read.csv("pay_data.csv", fileEncoding = "euc-kr")
return <- read.csv("return_data.csv", fileEncoding = "euc-kr")
                                            # 샘플 데이터 가져오기

# 더미 형식으로 생성

table(user$house_type)
house_type2 <- ifelse(user$house_type == 1 | user$house_type == 2, 0, 1)
                                            # house_type이 1이나 2면 0, 그외에는 1
                                            # (단독주택 == 1, 다가구주택 == 2, 아파트 == 3, 오피스텔 == 4)
                                            # house_type2 라는 더미 변수 생성
                                            # ( 주택 유형 = 0, 아파트 유형 = 1)
user$house_type2 <- house_type2

# 1:1관계로 생성

library(reshape2)

pro_pri <- dcast(pay, user_id ~ product_type, sum, na.rm = T)
                                            # 행 ~ 열
                                            # pay에는 id와 상품 유형을 제외하고는 숫자데이터가 금액밖에 없음으로
                                            # 값은 자동으로 금액의 합이 들어간다.
                                            # 고객별 상품 유형에 따른 구매금액
names(pro_pri) <- c('user_id','식료품(1)','생필품(2)','의류(3)','잡화(4)','기타(5)')
head(pro_pri)

pay_pri <- dcast(pay, user_id ~ pay_method, length)
names(pay_pri) <- c('user_id', '현금(1)', '직불카드(2)', '신용카드(3)', '상품권(4)')
head(pay_pri)

# 파생변수 합치기

library(plyr)                               # 병합을 위해 로드

pay_data <- join(user, pro_pri, by='user_id')
                                            # join(x, y, by='기준')
                                            # x의 '기준'을 기준으로  x 오른쪽에 y가 병합되어 반환된다.
                                            # x에는 있지만 y에는 없는 기준은 데이터가 NA로 생성되어 표시된다.
head(pay_data, 10)

pay_data <- join(pay_data, pay_pri, by='user_id')

pay_data$총구매금액 <- pay_data$'식료품(1)' + pay_data$'생필품(2)' + pay_data$'의류(3)' + pay_data$'잡화(4)' + pay_data$'기타(5)'
                                            # 총구매금액이라는 새로운 열을 생성 후
                                            # 그 안에 user_id마다 상품별 구매금액을 전부 더하여 넣기
print(pay_data)


# 2 표본추출

setwd("C:/bigdataR/write csv")

write.csv(pay_data, file="pay_data_c.csv", row.names = F)

data <- read.csv("pay_data_c.csv", header = T)

# 표본 샘플링 ( 딥러닝에서 주로 사용하는 방식 )

# 복원 추출 -> 중복 샘플 O
# 비복원 추출 -> 중복 샘플 X

nrow(data)                              # 샘플을 구할 데이터의 행 갯수 확인
                                        # length(data) -> 데이터의 열 갯수 확인
choice01 <- sample(nrow(data), 30)      # sample( n, m ) -> 1 ~ n 에서 m 개 만큼의 수를 랜덤 추출
choice01                                # 비복원추출

choice02 <- sample(50:nrow(data), 30)   # n:a -> n ~ a 에서 추출
choice02

choice03 <- sample(50:100, 30)

choice04 <- sample(c(10:50, 80:150, 160:190), 30)
                                        # 여러 범위에서 샘플 추출

data[choice01, ]                        # 표본 데이터 추출


data("iris")                            # 특정 비율로 랜덤하게 데이터를 뽑을 샘플 데이터 로드
dim(iris)                               # 행, 열 수

ind <- sample(1:nrow(iris), nrow(iris) * 0.7)
                                        # 데이터의 총 행 개수의 70퍼센트 갯수에 해당하는 샘플 랜덤 추출

training <- iris[ind, ]                 # 7할의 랜덤 학습 표본 데이터 추출
testing <- iris[-ind, ]                 # 3할의 랜덤 검정 표본 데이터 추출

                                        # 학습데이터 -> 패턴 학습에 사용할 데이터
                                        # 검정데이터 -> 학습이 잘 이루어졌는지 검정할 데이터
                                        # 학습데이터와 검정데이터는 서로 중복요소가 없는게 좋음.

                                        # 학습:검정 = 7:3

dim(training)
dim(testing)


# 교차 검정 샘플링

# 동일한 데이터셋을 N등분하여 N-1개의 학습데이터로 하고
# 나머지 1을 검정데이터로 이용

# K겹 교차 검정 데이터셋 알고리즘 사용
# EX) N = 3 => N1 = D1, D2, D3 | N2 = D1, D2, D3 | N3 = D1, D2, D3
# EX) K = 3 => 검정:학습1/학습2 => N1 -> D1:D2/D3 | N2 -> D2:D1/D3 | N3 -> D3:D1/D2

name <- c('a', 'b', 'c', 'd', 'e', 'f')
score <- c(90, 85, 99, 75, 65, 88)

df <- data.frame(Name = name, Score = score)
                                          # 샘플 데이터 작성

install.packages("cvTools")
library(cvTools)
                                          # 교차 검정을 위한 패키지 설치 및 로드
