# 빈도분석
# 설문 조사 결과에 대한 가장 기초적인 정보를 제공해주는 분석 방법
# 번주형 데이터를 대상으로 비율을 측정하는 데 주로 이용

# 기술통계분석
# 연속형 데이터를 분석할때 주로 이용
# 연속형 데이터는 수치에 의미가 있기에 분포의 특성을
# 표본의 평균값, 중앙값, 최빈값으로 나타냄

# 기술 통계량
# 대표값 -> 평균, 합계, 중위수, 최빈수, 사분위수, ...
# 산포도 -> 분산, 표준편차, 최소값, 최대값, 범위, 평균의 표준오차, ...
# 비대칭도 -> 첨도, 왜도


# 척도별 기술통계량 구하기

data <- read.csv(file.choose())               # 샘플 데이터

head(data)                                    # 상위 데이터
dim(data)                                     # 행, 열 갯수
length(data)                                  # 열의 길이
length(data$resident)                         # 해당 열의 행의 길이
str(data)                                     # 구조
summary(data)                                 # 각 열의 기술통계량

# 명목 척도
# 명목 척도의 데이터는 수치에 의미가 없기에 기술통계량에 의미가 없다.

length(data$gender)                           # 관측치 확인
table(data$gender)                            # 0과 5의 이상치 발견

data <- subset(data, gender == 1 | gender == 2)
                                              # 조건에 맞는 부분집합 반환
x <- table(data$gender)                       # 성별에 대한 빈도수
barplot(x)                                    # 이상치 제거 확인

y <- prop.table(x)                            # 비율 계산
round(y * 100, 2)                             # 백분율, 소수점 2자리까지

# 서열 척도
# 계급 순위를 수치로 표현한 것이기에 기술통계량에 의미가 없다.

length(data$level)
table(data$level)                             # 빈도수 표시 ( 1 = 고졸, 2 = 대졸, 3 = 대학원졸 )

barplot(table(data$level))

# 등간 척도
# 속성의 간격이 일정한 값을 갖는 변수

summary(data$survey)                          # 만족도 평균 2.6 -> 5가 매우 불만족이기에 리코딩 필요
table(data$survey)

hist(data$survey)                             # 등간 척도는 히스토그램이나
pie(table(data$survey))                       # 빈도수를 파이차트로 시각화

# 비율 척도
# 등간 척도의 특성에 절대 원점이 존재하는 척도
# 직접 수치 입력으로 0을 기준으로 한 수치를 가짐

length(data$cost)                             # 관측치 및 요약 통계량 파악
summary(data$cost)                            # 결측치 확인

plot(data$cost)                               # 이상치 확인
data <- subset(data, cost <= 10 & cost >= 2)  # 이상치 및 결측치 제거

cost <- data$cost

mean(cost)                                    # 평균, 중위수, 오름차순 정렬, 내림차순 정렬
median(cost)
sort(cost)
sort(cost, decreasing = T)
                                              # 사분위수 -> 전체 데이터를 네등분 하여 나타낸 통계량
quantile(cost, 1/4)                           # 제1사분위수
quantile(cost, 2/4)                           # 제2사분위수
quantile(cost, 3/4)                           # 제3사분위수
quantile(cost, 4/4)                           # 제4사분위수

length(cost)
ct <- table(cost)                             # 빈도수 파악
ct

max(ct)                                       # 최대빈도수 : 18

cf <- as.data.frame(ct)                       # 데이터 프레임으로 만들기
cf

which(cf[ , 2] == 18)                         # 빈도수 부분에서 값이 18인 행의 인덱스
cf[19, 1]                                     # 최대빈도수를 가진 변수 확인인

var(cost)                                     # 분산
sd(cost)                                      # 표준편차
