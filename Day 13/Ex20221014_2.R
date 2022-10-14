
# 상관관계 분석

# 회귀분석 전에 수행
# 상관계수인 피어슨 r 계수를 이용

# 0.9 <= r -> 매우 높은 상관관계
# 0.7 <= r < 0.9 -> 높은 상관관계
# 0.4 <= r < 0.7 -> 다소 높은 상관관계
# 0.2 <= r < 0.4 -> 낮은 상관관계
# r < 0.2 -> 상관관계 없음

product <- read.csv(file.choose(), header = T, fileEncoding = "euc-kr")

cor(product$제품_친밀도, product$제품_적절성)           # 다소 높은 상관관계
cor(product$제품_친밀도, product$제품_만족도)           # 다소 높은 상관관계

cor(product$제품_적절성, product$제품_만족도)           # 높은 상관관계

cor(product$제품_적절+product$제품_친밀도, product$제품_만족도)           
                                                        # 높은 상관관계

install.packages("corrgram")
library(corrgram)                                       # 상관관계 시각화 패키지

corrgram(product, upper.panel = panel.conf)             # upper.panel / lower.panel = panel.conf
                                                        # 위쪽 / 아래쪽 패널에 상관계수 추가

install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)                           # 차트에 밀도곡선, 상관성, 유의확률(별표) 추가 패키지

chart.Correlation(product, histogram = , pch = "+")     # 상관성 차트
                                                        # histogram = -> 히스토그램 차트 (정규성)
                                                        # p값 (*) -> *** == 99%

cor(product, method = "spearman")                       # 스피어만 상관계수 ( 서열척도 )
cor(product, method = "pearson")                        # 피어슨 상관계수 ( r )

