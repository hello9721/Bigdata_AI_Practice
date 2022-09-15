# reshape2 활용


# dcast(데이터, 기준변수~재배치변수, 재배치변수에 적용함수)
# 긴형식 -> 넓은 형식

install.packages("reshape2")                    # 패키지 설치 및 로드

library(reshape2)

data <- read.csv('C:/source/Part2/data.csv')    # 샘플 데이터 가져오기
data

wide <- dcast(data, Customer_ID ~ Date, sum)    # Buy 열은 값으로 사용된다.
wide

setwd("C:/bigdataR/write csv")

colnames(wide) = c('Customer_ID', 'Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Day 7')
                                                # 열 이름 지정
write.csv(wide, "wide_.csv", row.names = F)     # 외부파일로 내보내기

wide


# melt(데이터, 기준행)
# 넓은 형식 -> 긴 형식

long <- melt(wide, id = "Customer_ID")
long

colnames(long) <- c('Customer_ID', 'Date', 'Buy')
long                                            # 열 이름 지정


# 실습

data("smiths")
smiths

long <- melt(id = 1:2, smiths)                  # 1번 열 기준
long

wide <- dcast(long, subject+time ~ ...)         # a+b -> a와 b 기준으로
wide                                            # ... -> 나머지 모두


# acast(데이터, 행 기준 ~ 열 기준 ~ 면 기준)
# array( = 3차원 구조 배열)로 변경

data('airquality')
airquality

str(airquality)

names(airquality) <- toupper(names(airquality)) # toupper(name) -> 열 이름을 대문자로 변경
airquality                                      # names(data) -> 데이터의 열이름 가져오기

air_melt <- melt(airquality, id = c('MONTH', 'DAY'), na.rm = T)
                                                # c로 묶어서 여러 기준을 잡을 수 있다.
                                                # na.rm = T -> na를 제거
air_melt

names(air_melt) <- tolower(names(air_melt))     # tolower(name) -> 열 이름을 소문자로 변경
air_melt

air_3d <- acast(air_melt, day ~ month ~ variable)
air_3d
