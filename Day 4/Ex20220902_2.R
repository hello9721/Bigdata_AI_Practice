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

data(iris)                                     # 샘플 데이터 가져오기
names(iris)
iris

str(iris)

hist(iris$Sepal.Length)                       # 히스토그램
                                              # 벡터형식의 숫자로만 이루어진 데이터여야한다.

hist(iris$Sepal.Length, col = "mistyrose", xlim = c(4.3, 7.9), main = "iris sepal length")

hist(iris$Sepal.Width, col = rainbow(20), xlim = c(2.0, 4.5), main = "iris sepal width")
hist(iris$Petal.Length, col = rainbow(30), ylim = c(0, 45), xlab = "petal length")
legend("topright",c("1 - 2","2 - 3","3 - 4","4 - 5","5 - 6","6 - 7"),ncol = 6, fill = rainbow(14))

hist(iris$Sepal.Width, col = rainbow(20), freq = F, main = "iris sepal width")
                                              # freq = F 를 설정하면 확률 밀도에 의해서 그려진다.
lines(density(iris$Sepal.Width), col = "black")
                                              # 밀도를 기준으로한 선을 추가

par(mfrow = c(1,2))

hist(iris$Petal.Length,freq = F, col = rainbow(30), ylim = c(0,1.2), main = "꽃잎 길이 확률 밀도")
lines(density(iris$Petal.Length))
                                              # 정규분포 추정곡선 추가하기
x <- seq(1, 7, 70)                            # seq(시작,끝,개수) -> 시작과 끝 범위 안에서 개수만큼의 원소를 반환
curve(dnorm( x, mean = mean(iris$Petal.Length), sd = sd(iris$Petal.Length)), col = "blue", add = T)

hist(iris$Petal.Width, freq = F, col = rainbow(30), ylim = c(0,1.2), xlim = c(0, 3), main = "꽃잎 너비 확률 밀도")
lines(density(iris$Petal.Width))

x <- seq(0, 3, 30)                            # x에 적용할 그래프의 범위 까지의 일정 변량이 담길 수 있도록 해주고
curve(dnorm( x, mean = mean(iris$Petal.Width), sd = sd(iris$Petal.Width)), col = "blue", add = T)
                                              # curve 함수안의 정규분포 난수 생성함수를 사용
                                              # (평균과 표준편차는 그래프 데이터의 평균과 표준편차 사용)
                                              # curve 함수 add 속성을 이용해 해당 그래프에 추가 표시해준다.
