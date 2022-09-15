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
pro_pri

