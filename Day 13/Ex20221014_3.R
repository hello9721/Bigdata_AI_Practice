# 연습 문제

# 제품친밀도 (q1, q2, q3)
# 제품만족도 (q4, q5, q6, q7)

# 데이터파일 > 베리맥스 회전법으로 요인수 2, 요인점수 회귀분석 방법 적용하여 요인 분석
#                                             > 요인적재량 행렬의 칼럼명 변경 > 요인점수로 요인적재량 시각화
#                                                                                   > 요인별 변수 묶기 > 상관관계 제시

library(memisc)
setwd("C:/source/Part3")

data <- as.data.set(spss.system.file('drinking_water_example.sav'))
dwe <- data[1:7]
dwe_df <- as.data.frame(dwe)
str(dwe_df)

d <- factanal(dwe_df, factors = 2, rotation = "varimax", scores = "regression")
d

colnames(d$loadings) <- c("제품친밀도", "제품만족도")
rownames(d$loadings) <- c("브랜드", "친근감", "익숙함", "목넘김", "맛", "향", "가격")

plot(d$scores[ , c(1:2)])
points(d$loadings[ , c(1:2)], pch = 19, col = "blue")

s <- data.frame(dwe_df$Q4,dwe_df$Q5,dwe_df$Q6,dwe_df$Q7)
c <- data.frame(dwe_df$Q1,dwe_df$Q2,dwe_df$Q3)

colnames(s) <- c("목넘김", "맛", "향", "가격")
colnames(c) <- c("브랜드", "친근감", "익숙함")

sat <- round((s$목넘김 + s$맛 + s$향 + s$가격)/ncol(s), 2)
clo <- round((c$브랜드 + c$친근감 + c$익숙함)/ncol(c), 2)

dwe_f_df <- data.frame(sat, clo)

cor(dwe_f_df)

# 만족도와 친밀도의 상관계수 = 0.4048
# 다소 높은 상관관계