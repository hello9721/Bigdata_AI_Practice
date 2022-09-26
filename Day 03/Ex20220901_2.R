# 2 연산자

# 산술 연산자

num1 <- 100
num2 <- 20

result <- num1/num2     # 나누기 연산
result

result <- num1%%num2    # 나머지 연산
result

result <- num1^2        # 거듭제곱 연산
result
result <- num1**2
result

# 관계 연산자
# 결과는 T / F

#  ==   Equal
#  !=   Not Equal
#  >    Greater Than
#  <    Less Than
#  >=   Greater Than or Equal
#  <=   Less Than or Equal

# 논리 연산자
# 결과는 T / F

# & AND
# | OR

# ! NOT

num1 <- 30

result <- !(num1 == 20) # 관계식은 F지만 ! 가 있기에 T 가 반환
result                  # T

# xor(x,y) x != y -> T / x == y -> F

x <- T
y <- F
z <- T

xor(x, y)               # T
xor(x, z)               # F


# 3 조건문

# if(조건){참인 경우} else{거짓인 경우}

x <- 50
y <- 4
z <- x*y

if( z >= 40 ){
  cat("40 이상\n")      # 조건이 참이면 / "\n" 은 줄바꿈
  cat("x * y =", z)     # cat은 원하는 포맷으로 출력 가능 / 줄바꿈을 설정하지 않으면 이어서 출력됨
}else{
  cat("40 미만")        # 조건이 거짓이면
}


# if(조건){참인 경우} else if(조건){이전 조건은 거짓이지만 현재 조건은 참인 경우} else {거짓인 경우}

x <- scan()             # x의 값을 입력 받아

if( x > 100 ){              
  result <- "100 초과"  # x가 첫번째 조건에 참일 경우
}else if( x > 50 ){
  result <- "100 이하 50 초과"
                        # x가 첫번째에는 거짓, 이번에는 참일 경우
}else if( x > 0 ){
  result <- "50 이하 0 초과"
                        # x가 첫번째, 두번째에는 거짓, 이번에는 참일 경우
}else{
  result <- "0 이하"    # x가 모든 경우에 거짓일 경우
}

cat(result)             # result를 출력


# ifelse( 조건, 참인 경우 출력, 거짓인 경우 출력 )
# 여러 값을 가진 벡터 데이터에 적용할 경우 각각 요소에 관해 적용 된다.

x <- scan()             # x의 값을 입력 받아

y <- ifelse(x >= 20, "20 이상", "20 미만")
                        # 각 결과에서 출력을 원하는 값을 입력
cat(y)                  # 받은 값을 출력


# swith( 비교문, 실행문1, ...)
# 실행문은 보통 key = value 형태
# key를 비교하여 실행문의 value를 반환

a <- "a"

switch( a, a = 12, b = 55, c = 100)
                        # 비교문과 비교하여 동일한 요소를 가진 실행문의 값을 반환
                        # 동일한 요소가 없다면 아무것도 반환 되지 않는다.


# which(조건)
# 조건이 참이 되는 요소의 인덱스 값 반환

x <- c( 1,2,3,4,5,6,7,8,9 )

y <- which( x == 1 )    # x가 1인 요소의 인덱스 반환
z <- which( x != 5 )    # x가 5가 아닌 요소들의 인덱스 반환
                        # 요소가 없다면 0 반환
x[y]
x[z]
