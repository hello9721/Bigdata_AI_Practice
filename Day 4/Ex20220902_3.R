# [ 2 ] 데이터 조작


# 1 dplyr 패키지

library(dplyr)                    # dplyr 불러오기 -> 데이터 처리에 적합
library(hflights)

# 파이프 연산자
# %>%
# 함수1의 처리 결과가 바로 함수2의 입력으로 들어간다.

iris %>% head()                   # == head(iris)
