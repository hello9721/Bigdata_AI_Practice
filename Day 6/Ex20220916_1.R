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

# K겹 교차 검정 데이터셋 알고리즘 사용 ( K fold )
# EX) K = 3 => 검정:학습1/학습2 => 1겹 -> D1:D2/D3 | 2겹 -> D2:D1/D3 | 3겹 -> D3:D1/D2

name <- c('a', 'b', 'c', 'd', 'e', 'f')
score <- c(90, 85, 99, 75, 65, 88)

df <- data.frame(Name = name, Score = score)
                                          # 샘플 데이터 작성

install.packages("cvTools")
library(cvTools)
                                          # 교차 검정을 위한 패키지 설치 및 로드
cross <- cvFolds(n = 6, K = 3, R = 1, type = "random")
                                          # cvFolds(n = 요소 개수, K = K겹, R = 반복횟수, type = "추출 방법" )
                                          # K겹 교차 검정 데이터 셋 생성
str(cross)

cross$subsets[cross$which == 1, 1]        # K = 1인 경우 -> 2, 6 = test : train = 5, 4, 3, 1  
cross$subsets[cross$which == 2, 1]        # K = 2인 경우 -> 1, 5 = test : train = 6, 4, 3, 2
cross$subsets[cross$which == 3, 1]        # K = 3인 경우 -> 3, 4 = test : train = 6, 5, 2, 1

r = 1                                     # 반복 횟수
K = 1:3                                   # K겹 교차 검정

for(i in K){                              # K회 반복
  data_ind <- cross$subsets[cross$which == i, r]
                                          # data_ind에 which가 i인 r열 데이터를 임시로 담는다.
  cat('K = ', i, '검정데이터 \n')
  print(df[data_ind, ])
                                          # data_ind를 인덱스 삼아 df에서 검정데이터를 추출한다.
  cat('K = ', i, '훈련데이터 \n')
  print(df[-data_ind, ])                  # 검정데이터의 인덱스를 제외한 나머지 데이터를 훈련데이터로 추출한다.
}



# 3 실습 예제

# airquality 데이터 셋 처리

# 기온이 가장 높은 날 -> 월/일 추출
# 6월달 발생한 가장 강한 바람의 세기 추출
# 7월달의 평균 기온 추출
# NA를 제외한 5월의 평균 오존 농도 추출
# 오존 농도가 100을 넘는 날은 며칠인지 추출

data("airquality")                        # 데이터셋 로드

str(airquality)

# 기온이 가장 높은 날 -> 월/일 추출

top_temp <- data.frame(Month = 0, Day = 0)
                                          # 날짜 값을 담아줄 데이터프레임 생성
top_temp$Month <- airquality$Month[ airquality$Temp == max(airquality$Temp, na.rm = T)]
top_temp$Day <- airquality$Day[ airquality$Temp == max(airquality$Temp, na.rm = T)]
                                          # max를 이용하여 temp 열이 max 값인 month와 day를 추출하여 담음
cat(top_temp$Month,"/",top_temp$Day)
                                          # 출력

# 6월달 발생한 가장 강한 바람의 세기 추출

June_strong <- max(airquality$Wind[airquality$Month == 6], na.rm = T)
                                          # max를 이용하여 month가 6인 행들 중 wind 열 값이 큰 것을 가져옴
cat(June_strong)

# 7월달의 평균 기온 추출

July_avg_temp <- mean(airquality$Temp[airquality$Month == 7])
                                          # mean을 이용하여 month가 7인 행들의 평균 값
cat(July_avg_temp)

# NA를 제외한 5월의 평균 오존 농도 추출

May_avg_ozone <- mean(airquality$Ozone[airquality$Month == 5], na.rm = T)
                                          # mean의 na.rm 속성을 이용하여 na를 모두 제거하고 난 5월의 오존 평균 값
cat(May_avg_ozone)

# 오존 농도가 100을 넘는 날은 며칠인지 추출

ozone_over100 <- length(airquality$Ozone[airquality$Ozone >= 100])
                                          # length를 이용하여 ozone의 값이 100을 넘는 값들의 갯수를 카운트
ozone_over100
