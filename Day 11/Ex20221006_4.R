# 연습 1

# 교육수준과 흡연율 간의 관련성 검정을 위해 가설을 수립하라

# 귀무가설 : 교육수준과 흡연률은 독립성이 있다.
# 연구가설 : 교육수준과 흡연률은 독립성이 없다.

# 데이터 파일을 가져와 리코딩 후 교차분할표를 작성하여 독립성을 검정하고 그 결과를 해석하라
# 파일명 : smoke.csv
# 교육수준 -> 1.대졸 2.고졸 3.중졸
# 흡연율 -> 1.과다흡연 2.보통흡연 3.비흡연

smoke <- read.csv(file.choose(), header = T)                  # 데이터 로드

str(smoke)                                                    # 데이터 구조 확인

smoke$education2[smoke$education == 1] <- "1.대졸"            # 리코딩
smoke$education2[smoke$education == 2] <- "2.고졸"
smoke$education2[smoke$education == 3] <- "3.중졸"

smoke$smoking2[smoke$smoking == 1] <- "1.과다흡연"
smoke$smoking2[smoke$smoking == 2] <- "2.보통흡연"
smoke$smoking2[smoke$smoking == 3] <- "3.비흡연"

smoke

cross <- table(smoke$education2, smoke$smoking2)              # 교차분할표
cross

chisq.test(smoke$education2, smoke$smoking2)                  # 카이제곱 검정

# 결과 해석

# x-squared = 18.911
# df = 4
# p-value = 0.0008183

# p가 0.05보다 작기에 귀무가설 기각 -> 교육수준과 흡연률은 독립성이 없고 관련되어 있다.



# 연습 2

# 나이와 직위 간의 관련성 분석
# 데이터 파일을 가져와 산점도로 관련성을 확인한 뒤 독립성을 검정하고 그 결과를 해석하라
# 파일명 : cleanData.csv.csv

a_data <- read.csv(file.choose(), header = T, fileEncoding = "euc-kr")

str(a_data)                                                   # 데이터 구조 확인

x <- a_data$position
y <- a_data$age3

plot(x,y)                                                     # 나이가 어릴수록 낮은 지위

chisq.test(x, y)                                              # 카이제곱 검정

# 결과 해석

# X-squared = 287.9, df = 8, p-value < 2.2e-16

# p 가 0.05보다 작기에 귀무가설 기각 -> 나이와 직위에는 관련성이 있다.



# 연습 3

# 직업 유형에 따른 응답 정도에 차이가 있는가
# 데이터 파일을 가져와 리코딩 후 교차분할표를 작성하여 동질성을 검정하고 그 결과를 해석하라
# 파일명 : response.csv
# 직업 -> 1.학생 2.직장인 3.주부
# 응답 -> 1.무응답 2.낮음 3.높음

response <- read.csv(file.choose(), header = T)                 # 데이터 로드

str(response)

response$job2[response$job == 1] <- "1.학생"                    # 리코딩
response$job2[response$job == 2] <- "2.직장인"
response$job2[response$job == 3] <- "3.주부"

response$response2[response$response == 1] <- "1.무응답"
response$response2[response$response == 2] <- "2.낮음"
response$response2[response$response == 3] <- "3.높음"

crossr <- table(response$job2, response$response2)              # 교차분할표
crossr

chisq.test(response$job2, response$response2)                   # 동질성 검정

# 결과 해석

# X-squared = 58.208, df = 4, p-value = 6.901e-12

# p가 0.05 보다 작으므로 귀무가설 기각 -> 직업 유형에 따른 응답정도는 동일 하지 않고 차이가 있다.