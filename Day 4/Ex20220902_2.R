# 2 연속변수의 시각화


# 상자 그래프
# 데이터의 분포를 나타내는데 많이 사용.
# summary 함수의 내용을 시각화 한다고 생각하면 된다.

data(VADeaths)                                  # 샘플 데이터 가져오기
VADeaths

boxplot(VADeaths)                               # 상자그래프

boxplot(VADeaths, range = 0)                    # range = 0 은 최소값과 최대값을 점선으로 연결
# 0이 디폴트
abline(h = 37, lty = 3, col = "green")          # 37 높이에 초록색으로 하여 스타일 3의 기준선을 그린다.

chart_data <- quakes$mag                        # 샘플 데이터 가져오기

boxplot(chart_data, col = "red", main = "지진강도 데이터 분포", ylim = c(3.8, 6.7))
# 동떨어진 데이터는 o 로 표시


# 히스토그램
# 계급별 분포를 알아보는데 많이 사용.
# ex) 성적별 학생 분포

data(iris)
names(iris)
iris
