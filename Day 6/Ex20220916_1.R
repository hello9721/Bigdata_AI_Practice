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

# 정제 데이터 저장
