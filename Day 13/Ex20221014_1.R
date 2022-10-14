
# 요인 분석
# 다수의 변수를 대상으로 변수 간의 관계를 분석, 공통 차원으로 축약하는 통계 기법

# 하위 요인으로 구성되는 데이터 셋이 준비 되어 있어야 하고
# 변수는 등간척도나 비율 척도여야하며 최소 50개 이상이어야 한다.

# 상관관계가 높은 변수끼리 그룹화하는 것이므로 상관관계가 낮다면 요인 분석에 적합하지 않다.


# 공통요인으로 변수 정제

# s1 ~ s6 각자 다른 분야의 과목들
# 1 ~ 5 5점 만점 (5점 척도) 만족도 조사

s1 <- c(1, 2, 1, 2, 3, 4, 2, 3, 4, 5)
s2 <- c(1, 3, 1, 2, 3, 4, 2, 4, 3, 4)
s3 <- c(2, 3, 2, 3, 2, 3, 5, 3, 4, 2)
s4 <- c(2, 4, 2, 3, 2, 3, 5, 3, 4, 1)
s5 <- c(4, 5, 4, 5, 2, 1, 5, 2, 4, 3)
s6 <- c(4, 3, 4, 4, 2, 1, 5, 2, 4, 2)

subject <- data.frame(s1, s2, s3, s4, s5, s6)

# 주성분 분석

# 요약 통계량 요소
# standard deviation 표준편차
# proportion of variance 분산의 비율
# cumulative proportion 누적 비율

p <- prcomp(subject)                # 주성분 분석 수행
summary(p)                          # 요약통계
plot(p)

# 고유값 분석

# $values 고유값 $vectors 고유벡터

e <- eigen(cor(subject))            # 고유값 추출
names(e)

plot(e$values, type = "o")

# 상관관계 분석

cor(subject)                        # 상관 계수 추출
r <- factanal(subject, factors = 3, rotation = "varimax", scores = "regression")
r                                   # factors = 요인 수
                                    # p 값이 0.05 이상이면 요인수가 부족하다는 의미
# Uniquenesses -> 0.5 이하 라면 유효한 변수
# Loadings -> 요인 적재값 ( 각변수와 해당 요인 값의 상관관계 계수)
#             0.4 이상이라면 유의미하다.
# SS loadings -> 요인적재값의 제곱의 합 ( 요인의 설명력 )
# proportion var -> 요인의 분산비율 ( 요인의 설명력의 비율 )
# cumulative var -> 누적분산 비율 ( 1 - 마지막 요인의 비율 = 정보손실 )
#                   정보 손실이 너무 크면 요인 분석의 의미가 없다.

attributes(r)                       # 결과 변수 속성
r$loadings                          # 기본 요인적재량

# 요인적재량 시각화

name <- 1:10                        # 문항 이름

                                    # factor1, factor2
plot(r$scores[ , c(1:2)])           # x, y에 해당하는 문항이름을 표시
text(r$scores[ , 1], r$scores[ , 2], labels = name, cex = 0.7, pos = 3)
                                    # 요인 적재량 표시
points(r$loadings[ , c(1:2)], pch = 19, col = "blue")
text(r$loadings[ , 1], r$loadings[ , 2], labels = rownames(r$loadings), cex = 0.8, pos = 3, col = "blue")

                                    # factor2, factor3
plot(r$scores[ , c(1, 3)])
text(r$scores[ , 1], r$scores[ , 3], labels = name, cex = 0.7, pos = 3)
                                    # 요인 적재량 표시
points(r$loadings[ , c(1, 3)], pch = 19, col = "red")
text(r$loadings[ , 1], r$loadings[ , 3], labels = rownames(r$loadings), cex = 0.8, pos = 3, col = "red")

                                    # 3차원 산점도
library(scatterplot3d)

factor1 <- r$scores[ , 1]           # 요인 점수
factor2 <- r$scores[ , 2]
factor3 <- r$scores[ , 3]

loading1 <- r$loadings[ , 1]        # 요인 적재량
loading2 <- r$loadings[ , 2]
loading3 <- r$loadings[ , 3]

d <- scatterplot3d(factor1, factor2, factor3, type = "p")
d$points3d(loading1, loading2, loading3, bg = "blue", pch = 21, cex = 1.5, type = "h")


# 잘못 분류된 요인 제거로 변수 정제

install.packages("memisc")        # spss로 편집된 데이터 불러오는 패키지
library(memisc)


setwd("C:/source/Part3")          # 샘플데이터
data <- as.data.set(spss.system.file("drinking_water.sav"))
dw <- data[1:11]
dw_df <- as.data.frame(data[1:11])
str(dw_df)                        # 제품친밀도 (q1, q2, q3, q4)
                                  # 제품적절성 (q5, q6, q7)
                                  # 제품만족도 (q8, q9, q10, q11)
r <- factanal(dw_df, factors = 3, rotation = "varimax")
r                                 # 1,2,3 / 4,5,6,7 / 8,9,10,11 이 가장 관련 높게 나옴
                                  # 의도한 요인과 결과가 다르게 나옴
# 잘못 분류된 요인 제거

dw_df <- dw_df[-4]

s <- data.frame(dw_df$Q8,dw_df$Q9,dw_df$Q10,dw_df$Q11)
c <- data.frame(dw_df$Q1,dw_df$Q2,dw_df$Q3)
p <- data.frame(dw_df$Q5,dw_df$Q6,dw_df$Q7)

satisfaction <- round((s$dw_df.Q8 + s$dw_df.Q9 + s$dw_df.Q10 + s$dw_df.Q11) / ncol(s), 2 )
closeness <- round((c$dw_df.Q1 + c$dw_df.Q2 + c$dw_df.Q3 ) / ncol(c), 2 )
pertinence <- round((p$dw_df.Q5 + p$dw_df.Q6 + p$dw_df.Q7 ) / ncol(p), 2 )

dw_f_df <- data.frame(satisfaction, closeness, pertinence)
colnames(dw_f_df) <- c("제품만족도", "제품친밀도", "제품적절성")

cor(dw_f_df)                      # 각 factor의 상관계수 추출
