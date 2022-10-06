# 교차 분석

# 범주형 자료를 대상으로 두 개 이상의 변수들에 대한 관련성을 알아보기 위해
# 결합분포를 나타내는 교차 분할표 작성하고
# 이를 통해 변수가 서로 관련성이 있는지 분석

# 사용되는 변수는 변수의 값이 10 미만인 범주형 변수 여야 함.
# 비율척도라면 리코딩으로 범주화 후 분석

cdata <- read.csv(file.choose(), header = T, fileEncoding = "euc-kr")
                                                          # 샘플데이터
head(cdata)                                               # 상위 데이터

x <- cdata$level2
y <- cdata$pass2

df <- data.frame(Level = x, Pass = y)                     # 교차 분할표 작성을 위한 데이터 프레임

cross <- table(df)                                        # 교차 분할표 작성

install.packages("gmodels")                               # 교차 분할 패키지
library(gmodels)
library(ggplot2)                                          # diamonds 데이터 셋 로드를 위한 패키지 로드

data("diamonds")                                          # 샘플 데이터 로드

CrossTable(x = diamonds$color, y = diamonds$cut)
                                                          # 패키지를 이용한 교차분할표
                                                          # 1 - 관측치
                                                          # 2 - 카이제곱 기대 비율
                                                          # 3 - Row 에서의 비율
                                                          # 4 - Col 에서의 비율
                                                          # 5 - Table 에서의 비율

CrossTable(x, y)


# 카이제곱 검정

# 범주별 관측빈도와 기대빈도의 차이를 통해 확률 모형이 데이터를 잘 설명하는지 검정

CrossTable(x, y, chisq = T)                               # chisq = T 라면 카이제곱 검정 결과 표시
CrossTable(x = diamonds$cut, y = diamonds$color, chisq = T)
                                                          # chi^2 : 카이제곱 값
                                                          # d.f.  : 자유도
                                                          # p     : p 값