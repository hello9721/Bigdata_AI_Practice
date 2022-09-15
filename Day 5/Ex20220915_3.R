# 1 코딩 변경
# 최초 코딩 내용을 용도에 맞게 변경

# 가독성을 위한 코딩변경

dataset$resident[dataset$resident == 1]       # resident가 1인 항목만 표시 (+ NA)

dataset$resident[dataset$resident == 1] <- '1.서울특별시'
dataset$resident[dataset$resident == 2] <- '2.인천광역시'
dataset$resident[dataset$resident == 3] <- '3.대전광역시'
dataset$resident[dataset$resident == 4] <- '4.대구광역시'
dataset$resident[dataset$resident == 5] <- '5.시군구'
                                              # resident가 n인 항목의 요소를 변경
dataset

dataset$job2[dataset$job == 1] <- "공무원"
dataset$job2[dataset$job == 2] <- "회사원"
dataset$job2[dataset$job == 3] <- "개인사업"
                                              # 앞쪽에 새로운 열이름을 넣으면 열을 새로 생성함.


# 척도 변경을 위한 코딩 변경

dataset$age2[dataset$age <= 30] <- "청년층"
dataset$age2[dataset$age > 30 & dataset$age <= 55] <- "중년층"
dataset$age2[dataset$age > 55] <- "장년층"
                                              # 연속형 변수를 범주형으로 변경됨


# 역코딩을 위한 코딩 변경
# 예를 들어 1 - 5 == 매우만족 - 매우불만족 을
# 1 - 5 == 매우불만족 - 매우만족 으로 바꾸는 것

survey <- dataset$survey
                                              # 별도의 변수에 역코딩 하려는 데이터를 넣기
                                              # 1이 5로 2는 4로 ... 5는 1로 바뀌어야 되니까 6 - 데이터를 하면 됨
csurvey <- 6 - survey
                                              # 벡터를 연산하면 각 원소가 하나씩 연산됨
dataset$survey <- csurvey
dataset$survey
                                              # 원본 데이터에 역코딩한 데이터를 집어넣기


# 2 변수 간의 관계 분석

# 범주형과 범주형

data <- read.csv("C:/source/Part2/new_data.csv", fileEncoding = "euc-kr")
                                              # 데이터에 한글이 있을때 인코딩 방식을 지정
str(data)

r_g <- table(data$resident2, data$gender2)
                                              # table 함수를 사용해 성별에 따른 거주지 분포 표시
barplot(r_g, beside = T, col = rainbow(5), legend = row.names(r_g), ylim = c(0, 70), main = '성별에 따른 거주지 분포')
                                              # legend는 범례, beside 가 T면 쌓지않고 옆으로 그래프 놓기
                                              # horiz 가 T면 가로 그래프

g_r <- table(data$gender2, data$resident2)

barplot(g_r, beside = T, ylim = c(0, 70), col = rep(c(15,99),5), legend = row.names(g_r), main = '거주지에 따른 성별 분포')
                                              # rep(반복할 수 , 반복횟수)

# 연속형과 범주형

install.packages("lattice")
library(lattice)
                                              # lattice == 고급 시각화 분석을 휘한 패키지

# densityplot(~x, data = data, groups = group, plot.point = T/F, auto.key = T/F)
                                              # x 축으로 넣을 열을 ~뒤에, 그 열을 가져올 데이터를 data에
                                              # groups에 x와 관계를 알아볼 범주형데이터
                                              # plot.point는 밀도 (동그라미로 표시), auto.key는 범례

densityplot(~age, data = data, groups = job2, plot.point = T, auto.key = T)
                                              # 직업에 따른 나이 분포

# 연속형과 범주형, 범주형

densityplot(~price | factor(gender2), data = data, groups = position2, plot.points = F, auto.key = T)
                                              # factor(gender2) => 성별로 격자 생성
                                              # 성별에 따른 직급별 구매비용
densityplot(~price | factor(position2), data = data, groups = gender2, auto.key = T)
                                              # 직급에 따른 성별별 구매비용

# 연속형, 연속형과 범주형

# xyplot( y ~ x, data = data)

xyplot( price ~ age | factor(gender2), data = data )
                                              # 성별에 따른 나이별 구매비용 분포


# 3 파생변수

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
pro_pri

