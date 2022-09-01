# 4 반복문

# for(n in 변수){실행문}
# 변수에 있는 요소를 하나씩 n으로 넘겨 변수의 요소가 다 넘겨질 때까지 실행문을 반복

i <- c( 1:5 )

for( n in i ){
  print( n )            # i의 요소가 하나씩 n으로 넘겨져서 출력됨 -> 1 2 3 4 5
}                       # print는 변수의 값 또는 연산 결과를 출력 / 자동으로 줄바꿈 실행

x <- 0

for( n in c( 1:10 ) ){  # x에 n이 하나씩 더해지면서
  x <- x + n            # x에는 결과적으로 총합이 들어간다.
}                       # 반복문에는 next ( == 파이썬의 continue) 가 사용 가능하다.

print( x )              # 1:10 이 더해져 55 출력


# for(n in c(names(데이터프레임))){ print(n) }
# 위를 사용하면 데이터프레임의 열 이름 출력 가능


# for(n in 100){cat(i)} => 100


score <- c(88:90)       # 점수와 이름은 위치에 따라 서로 대응 된다.
name <- c("a","b","c")

i <- 1                  # 카운터를 위해 1 넣기

for( s in score ){
  cat( name[i], "->", s,"\n" )
                        # 1에 들어있는 이름이 출력될 때 첫번째 점수 또한 같이 출력된다.
  i <- i + 1            # 다음 반복에는 2의 이름을 출력하기 위해 i에 1을 더해 i의 값으로 넣기
}                       # a -> 88 b -> 89 c -> 90 


# while(조건){ 실행문 }
# 조건이 T일 경우는 반복, 조건이 F일 경우는 멈춤.

n <- 0                  # 카운터를 위해 1 넣기                

while( n < 10 ){        # 매 반복 마다 n은 1씩 커짐
  n <- n + 1            # 1 2 3 4 5 6 7 8 9 10
  print(n)
}



# 5 함수 정의

# 사용자 정의 함수
# 함수명 <- functino(매개변수){실행문}

f1 <- function(){       # 매개변수 없이 정의
  cat("매개변수 없음")
}
f1()                    # 함수 실행

f2 <- function(x, y){   # 매개변수 2개 사용 가능
  xy <- x+y
  return (xy)           # 값 반환
}
f2(3, 7)                # 매개변수 부분에 인수를 넣어 함수 실행


# 기술통계량을 계산하는 함수 정의

test <- quakes$mag      # 테스트 데이터셋 불러오기
test

# 표본분산 식 var <- sum((x - 산술평균)^2) / (n-1)
# 표본본표준편차 식 sqrt(var)

# 편차 = 평균하고 변량의 차이
# 분산 = 각 편차의 제곱의 평균
# 표준편차 = 분산의 음이 아닌 제곱근

# 분산과 표준편차의 값이 크다 == 변량들이 중심으로 부터 넓게 흩어져있다.
# 분산과 표준편차의 값이 작다 == 변량들이 중심으로 모여있다.

var_sd <- function(x){
  var <- sum((x - mean(x))^2) / (length(x)-1)
                        # x - mean(x) : 각각 편차를 구함 == 시그마
  sd <- sqrt(var)       # sqrt() : 분산에 루트 == 표준편차
  cat("표본 분산       ", var,"\n")
  cat("표본 표준편차   ", sd)
}

sd(test)                # 표준편차 구하는 함수로 검증
var_sd(test)


# 결측치 포함 자료의 평균 계산 함수 정의

data <- c(50, 10, 20, NA, 60, 70, NA, 30, NA, 80, 90, NA, 100, 40)

na1 <- function(x){
  print(x)
  print(mean(x, na.rm = T))
                        # NA를 제거 후 나머지 항목 평균 구함
}

na2 <- function(x){
  x <- ifelse(!is.na(x), x, 0)
                        # NA를 0으로 바꾼 후 평균 구함
  print(x)              # 데이터 손실 예방
  print(mean(x))        # 보통 사용 하지 않는 방법
}

na3 <- function(x){
  x <- ifelse(!is.na(x), x, round(mean(x, na.rm = T), 2))
                        # NA를 제거한 후 나오는 평균을 NA에 대입하여 평균 구함
  print(x)              # NA가 평균에 영향을 끼치지 못함
  print(mean(x))        # 데이터 손실 예방
}

na1(data)               # 55
na2(data)               # 39.28571
na3(data)               # 55
