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
x <- seq(1, 7, 0.01)                          # seq(시작,끝,간격) -> 시작부터 끝 범위까지 간격만큼의 모든 원소를 반환
curve(dnorm( x, mean = mean(iris$Petal.Length), sd = sd(iris$Petal.Length)), col = "blue", add = T)

hist(iris$Petal.Width, freq = F, col = rainbow(30), ylim = c(0,1.2), xlim = c(0, 3), main = "꽃잎 너비 확률 밀도")
lines(density(iris$Petal.Width))

x <- seq(0, 3, 0.01)                          # x에 적용할 그래프의 범위 까지의 일정 변량이 담길 수 있도록 해주고
curve(dnorm( x, mean = mean(iris$Petal.Width), sd = sd(iris$Petal.Width)), col = "blue", add = T)
                                              # 정규분포 난수 생성함수를 사용하여 얻은 난수를 curve 함수를 통해 선으로.
                                              # (평균과 표준편차는 그래프 데이터의 평균과 표준편차 사용)
                                              # curve 함수 add 속성을 이용해 해당 그래프에 추가 표시해준다.

x <- quakes$mag
hist(x, ylim = c(0, 120), breaks = seq(4.0, 6.5, 0.1))
                                              # break = seq(시작, 끝, 간격) -> seq를 통해 나온 수 들을 x 지표로 사용.


# 산점도 그래프

x <- runif(100, min = 0, max = 100)           # 난수 발생 함수를 통해 샘플데이터 받기
plot(x, col = "blue")                         # 산점도 그래프

par(new = T)                                  # 차트 추가
line_chart <- c(1:100)                        # 산점도 그래프의 대각선을 추가하기 위한 데이터
plot(line_chart, type = "l", ann = F, axes = F)
                                              # type = "l" -> 실선으로,
                                              # ann, axes = F -> 레이블이나 지표 표시 F
text(70, 80, "대각선 추가", col = "red")      # 해당 좌표에 해당 텍스트 표시

par(mfrow = c(2, 2))

plot(x, type = "l", col = "red")              # 실선으로 표시
plot(x, type = "o", col = "orange")           # 실선으로 표시, 지점마다 o 표시
plot(x, type = "h", col = "blue")             # 수직선으로 표시
plot(x, type = "s", col = "purple")           # 꺽은선으로 표시

plot(x, type = "o", pch = 5)                  # pch -> 지점 도형을 최대 30가지로 바꿈
plot(x, type = "o", col = "orange", pch = 20, lwd = 2)
                                              # lwd -> 선 굵기
plot(quakes$mag, type = "s")


# 중첩 자료 그래프
# 2차원 산점도 그래프에서 중복 데이터가 있을때.

x <- c(1, 2, 3, 4, 2)
y <- rep(2, 5)

table(x,y)
plot(x, y)                                    # 결과 -> (2, 2)가 2번 나오기때문에 중첩되서 점 4개만 나옴

xy <- as.data.frame(table(x,y))               # 중복 없는 x의 데이터가 x 열, y는 y 열, 중복 갯수가 Freq 열
xy

plot( x, y, col = rainbow(10), cex = 2 * xy$Freq)
                                              # xy$Freq, 즉, 중복되는 원소일수록 더 확대되도록.
                                              # 그래프에서 중복되는 값을 알아보기 쉽다.
library(UsingR)
data(galton)                                  # 샘플 데이터 가져오기

str(galton)
summary(galton)

galtonData <- as.data.frame(table(galton$child, galton$parent))
                                              # 교차 테이블로 만들기 -> 중복되는 수는 Freq로 나온다.
galtonData

child <- as.numeric(galtonData$Var1)
parent <- as.numeric(galtonData$Var2)

plot(child, parent, col = rainbow(1000), cex = 0.2 * galtonData$Freq)
                                              # 중복되는 수가 많은 데이터 일수록 더 크게 확대되어 잘 보이게 된다.


# 변수 간 비교 그래프
# 변수와 변수 사이의 관계를 시각화

iris                                          # 샘플 데이터 가져오기

virginica <- iris[ iris$Species == "virginica", 1:4 ]      
setosa <- iris[ iris$Species == "setosa", 1:4 ]
versicolor <- iris[ iris$Species == "versicolor", 1:4 ]
                                              # Species가 virginica인 변수만 1열부터 4열까지 출력
pairs(virginica)                              # 각 열이 서로 어떠한 관계인지 시각화
pairs(setosa)
pairs(versicolor)

# 3차원 산점도 그래프

library(scatterplot3d)

d3 <- scatterplot3d(iris$Petal.Length, iris$Sepal.Length, iris$Sepal.Width, type = 'n')
                                              # 뼈대 생성 -> type ='n' 을 사용하면 산점도 표시 하지 않고 뼈대만 생성 가능
d3$points3d(virginica$Petal.Length, virginica$Sepal.Length, virginica$Sepal.Width, bg = "orange", pch = 21)
d3$points3d(setosa$Petal.Length, setosa$Sepal.Length, setosa$Sepal.Width, bg = "green", pch = 23)
d3$points3d(versicolor$Petal.Length, versicolor$Sepal.Length, versicolor$Sepal.Width, bg = "purple", pch = 25)
                                              # 각자 모양, 색을 다르게 해서 구별이 가도록 한다.
