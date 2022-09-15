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
