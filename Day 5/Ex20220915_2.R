# EDA
# 탐색적 자료분석 (Exploratory Data Analysis)
# 다양한 각도에서 데이터를 관찰하고 이해하는 과정
# 그 후 데이터를 정제


# 1 수집 자료 이해

# print(data) / View(data) 로 데이터 셋 확인

getwd()                                     # 설정된 작업 디렉토리를 표시

dataset <- read.csv("C:/source/Part2/dataset.csv")
dataset                                     # 샘플 데이터 가져오기

print(dataset)                              # 데이터 출력
View(dataset)                               # 별도의 창에 표 형식으로 데이터 표시

# head(data) / tail(data)

head(dataset)                               # 상단의 6개 데이터 표시
tail(dataset)                               # 하단의 6개 데이터 표시

# attributes(data)

attributes(dataset)                         # 열이름 / 데이터 형식 / 행이름 표시

# str(data)

str(dataset)                                # 데이터 형식 / 데이터 요소 갯수와 열 갯수
                                            # / 열 별 데이터들의 형과 상위 데이터들

# summary(data)

summary(dataset)                            # 열 별 기술통계 표시
                                            # => 최대값, 최소값, NA개수, 평균, 중앙값, 사분위수

# 특정 열 조회

dataset$age                                 # 선택된 열의 값을 벡터로 조회
dataset['gender']                           # 선택된 열만 조회
                                            # 인덱스 번호로도 열 조회 가능
                                            # [a,b] 로 특정 열의 특정 행 조회 가능
                                            # c로 묶어서 여러 열 조회가능

# 데이터 수 확인

length(dataset$age)                         # length(data$colname)

# 특정 변수의 조회 결과를 변수에 저장

x <- dataset$gender
y <- dataset$price

# 산점도 그래프로 변수 조회

plot(y, ylim = c(1, 9))                     # plot(x, y) => 한가지 데이터만 넣으면 y축은 데이터, x축은 index로 생성된다.



# 2 결측치 처리

summary(dataset$price)                      # 결측치 갯수 확인

sum(dataset$price, na.rm = T)               # na.am 이 활성화 되면 결측치를 제거한 후 함수가 적용이 된다.

n_price <- na.omit(dataset$price)           # 결측치를 제거한 후 반환해주는 함수
sum(n_price)

x <- dataset$price

n_x <- ifelse(!is.na(x), x, 0)              # is.na => na면 T / ! == not / ifelse( 조건, T, F )
dataset$price <- n_x                        # 덮어쓰기
summary(dataset$price)                      # na 없음.

m_x <- ifelse(!is.na(x), x, round(mean(x, na.rm = T),2))
                                            # na가 아닐때 na가 제거된 데이터의 평균을 na 대신 넣음.
                                            # round(data, n) => data의 소수점을 n자리 만큼만 표시
dataset$price <- m_x                        # 덮어쓰기
summary(dataset$price)                      # na 없음.

                                            # 0으로 치환하면 치환 이전과 데이터의 평균이 달라지고
                                            # 평균으로 치환하면 치환 이전과 데이터의 총합이 달라진다.



# 3 극단치 처리

# 범주형 변수의 극단치
# 선택지를 컴퓨터로 처리하기 위해 명목상 수치로 표현한 변수

table(dataset$gender)                       # 유형별로 각 갯수 카운팅

dataset <- subset(dataset, gender == 1 | gender ==2)
                                            # subset(data, 조건)
                                            # 조건에 맞는 행들만 반환

# 연속형 변수의 극단치
# 그 수치 자체가 선택지인 연속된 데이터를 갖는 변수

# 1

summary(dataset$age)                        # 20 ~ 69 까지만 정상 데이터라는 설정

dataset <- subset(dataset, age >= 20 & age <= 69)

dataset$price                               # 2.0 ~ 8.0 까지만 정상 데이터라는 설정

dataset <- subset(dataset, price >= 2.0 & price <= 8.0)

#2

boxplot(dataset$price)$stats                # 값의 범위에서 상하위 0.3%를 극단치로 보고
                                            # 정상범위를 보여줌

dataset <- subset(dataset, price >= 2.1 & price <= 7.9)
