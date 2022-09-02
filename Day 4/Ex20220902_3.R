# [ 2 ] 데이터 조작


# 1 dplyr 패키지

library(dplyr)                    # dplyr 불러오기 -> 데이터 처리에 적합
library(hflights)                 # 샘플 데이터 불러오기

# 파이프 연산자
# %>%
# 함수1의 처리 결과가 바로 함수2의 입력으로 들어간다.

iris %>% head()                   # == head(iris)

# filter 처리

hf <- tbl_df(hflights)            # 그리드 형식으로 저장
hf                                # 데이터 처리를 위해서 그리드 형식으로

dim(hf)

filter(hf, Month == 12 & DayofMonth == 25)
                                  # filter(테이블 형식의 데이터 프레임, 조건1, 조건2)
                                  # 데이터에서 조건에 맞는 데이터만 추출하여 표시해준다.

hf %>% filter(Month == 1 & DayofMonth == 1)
                                  # == filter(hf, Month == 1 & DayofMonth == 1)
                                  # & == AND == 그리고
filter(hf, DayofMonth == 1 | DayofMonth == 20)
                                  # | == OR == 혹은

# arrange 정렬

arrange(hf, Year, Month, DayofMonth, DepTime, ArrTime)
                                  # 정렬 우선 순위 , 기본적으로 오름차순
                                  # arrange(dataframe, 열1, 열2, 열3 ...)
                                  # desc(열) 을 넣으면 내림차순

# select 조회

select(hf, Year, Month, DayofMonth, FlightNum)
                                  # 원하는 열만 조회
                                  # select(dataframe, 열1, 열2, ...)
select(hf, Year:TailNum)
                                  # select(dataframe, 열1:열5)
                                  # 열1, 열2, 열3, 열4, 열5
                                  # -(열) 을 넣으면 그 열 제외 나머지 조회

# mutate 특정 열 추가

mutate(hf, gain = ArrDelay - DepDelay, time = ArrTime - DepTime) %>% select(gain, time)
                                  # 열끼리 연산하여 새로운 열 추가 가능
                                  # mutate(dataframe, 열1 = 수식1, 열2 = 수식2, ...)
                                  # 파이프 연산자로 새로운 열을 넣은 데이터 값을 select 에 넣어 gain열과 time열 조회

# Summarise 요약통계

summarise(hf, avgAirTime = mean(AirTime, na.rm = T))
                                  # AirTime의 평균을 avgAirTime으로
                                  # summarise(dataframe, 추가 열1 = 함수(계산할 열1), ...)
summarise(hf, sdAirTime = sd(AirTime, na.rm = T), varAirTime = var(AirTime, na.rm = T))
                                  # sd == 표준편차 , var == 분산

# 집단변수 대상 그룹화
# group_by(dataframe, 집단변수)

species <- group_by(iris, Species)
                                  # 종을 기준으로 그룹화
str(species)
