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

# inner_join(df1, df2, by = 'x')
# 1,2 모두 x열이 존재하는 관측치만 병합

df1 <- data.frame(x = 1:100, y = rnorm(100))
df2 <- data.frame(x = 51:60, z = rnorm(10))

inner_join(df1, df2, by = 'x')
inner_join(df2, df1, by = 'x')
                                  # 기준이 되는 x열이 1열, 왼쪽 df의 열이 2열, 오른쪽 df의 열이 3열
                                  # x열 중 공통적이지 않은 행은 버린다.

# left_join(df1, df2, by = 'x')
# 왼쪽 데이터의 x열 기준으로 병합

left_join(df1, df2, by = 'x')
left_join(df2, df1, by = 'x')
                                  # 왼쪽 df에 오른쪽 df가 합쳐진다.
                                  # 왼쪽 df 열, 오른쪽 df 열 순서로 병합.
                                  # 합쳐진 열 중 공통적이지 않은 행의 없는 값들은 결측치, NA로 기록된다.
                                  # 왼쪽 df 행 수보다 오른쪽 df 행의 수가 더 많으면 넘치는 행들은 버린다.

# right_join(df1, df2, by = 'x')
# 오른쪽 데이터의 x열 기준으로 병합

right_join(df1, df2, by = 'x')
right_join(df2, df1, by = 'x')
                                  # 오른쪽 df에 왼쪽 df가 합쳐진다.
                                  # 오른쪽 df 열, 왼쪽 df 열 순서로 병합.
                                  # 합쳐진 열 중 공통적이지 않은 행의 없는 값들은 결측치, NA로 기록된다.
                                  # 오른쪽 df 행 수보다 왼쪽 df 행의 수가 더 많으면 넘치는 행들은 버린다.

# full_join(df1, df2, by = 'x')
# 1,2 중에서 x열이 있으면 모두 병합

full_join(df1, df2, by = 'x')
full_join(df2, df1, by = 'x')
                                  # 모든 df의 데이터를 병합.
                                  # 왼쪽 df 열, 오른쪽 df 열 순서로 병합.
                                  # 합쳐진 열 중 공통적이지 않은 행의 없는 값들은 결측치, NA로 기록된다.

# bind_rows(df1, df2)
# 데이터프레임들을 행 기준으로 합친다.

df1 <- data.frame(x = 1:5, y = rnorm(5))
df2 <- data.frame(x = 6:10, z = rnorm(5))

bind_rows(df1, df2)               #  공통적인 열은 df1 / 없는 열의 행은 결측치로 기록.
                                  #                df2                  df2


# bind_cols(df1, df2)
# 데이터프레임들을 열 기준으로 합친다.

bind_cols(df1, df2)               #  공통적인 열은 자동으로 열 이름이 바뀌어서 df1 df2 순서로 합쳐진다.

# rename(df1, x1_re = x1)
# 데이터 프레임의 특정 열의 이름을 새로 짓는다.

rename(df1, z = y) %>% bind_rows(df2)



# 숙제
# iris에서의 3품종을 각각 df1, df2, df3에 저장한 후,
# df_all 라는 이름으로 행단위 병합하기 (virg -> vers -> set 순서로)

# 1

summary(iris)

t_iris <- tbl_df(iris)

df1 <- filter(t_iris, Species == "virginica")
df2 <- filter(t_iris, Species == "versicolor")
df3 <- filter(t_iris, Species == "setosa")

df_all<- bind_rows(df1, df2) %>% bind_rows(df3)

head(df_all)
tail(df_all)

# 2

df1 <- iris[iris$Species == "virginica", ]
df2 <- iris[iris$Species == "versicolor", ]
df3 <- iris[iris$Species == "setosa", ]

df_all <- rbind(df1, df2) %>% rbind(df3)

head(df_all)
tail(df_all)
