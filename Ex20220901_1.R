# 1 숙제 검토
# 행정구역이 시와 군인 데이터에서 순이동이 양수인 데이터만 추출.
# 열은 행정구역과 순이동만 나오게 한다.

hw <- read.csv(file.choose(), sep = ",", header = T) # 파일은 선택, 쉼표로 구분, 헤더 있음.
hw                                                   # 데이터 확인

head(hw)                                             # 상위 데이터 요약
tail(hw)                                             # 하위 데이터 요약

x <- grep("시$", hw$행정구역.시군구.별)              # 데이터에서 시로 끝나는 데이터 행 번호 반환
x

y <- grep("군$", hw$행정구역.시군구.별)              # 데이터에서 군으로 끝나는 데이터 행 번호 반환
y

data1 <- hw[x, ]                                     # x에 있는 행 번호를 가진 데이터를 data1로
data1

data2 <- hw[y, ]                                     # y에 있는 행 번호를 가진 데이터를 data2로
data2

s <- grep("자치시$", hw$행정구역.시군구.별)          # 세종특별자치시가 2개 이기에 하나만 사용하기 위해 열 번호 알아보기
s
data1 <- subset(data1, 행정구역.시군구.별 != "세종특별자치시")
                                                     # 시 데이터에서 세종특별자치시를 전부 제거 후
datas <- hw[84, ]                                    # 아까 알아놓은 행 번호 중 하나를 변수에 선언해서
data1 <- rbind(datas, data1)                         # 시데이터와 세종특별자치시 한개의 데이터를 병합
data1

# 혹은 data1에서의 세종특별자치시의 행번호를 알아본 뒤 data1 <- data1[-c(n), ] 행번호 n ( 세종특별자치시 하나) 만 빼고 전부.

data <- rbind(data1, data2)                          # 시데이터와 군데이터를 병합
data <- subset(data, 순이동.명. > 0)                 # 데이터에서 순이동이 양수인 데이터만 남기기
data

# 혹은 data <- data[data$순이동.명. > 0, ] data에서 순이동이 0보다 큰 데이터의 행 전부.

df <- data.frame(행정구역 = data$행정구역.시군구.별, 순이동 = data$순이동.명.)
                                                     # 열 이름을 행정구역과 순이동으로 하고 데이터를 가져와서 데이터 프레임으로
df                                                   # 숙제 데이터 완성.

setwd("C:/bigdataR/write csv")                       # 저장 디렉토리 설정
write.csv(x = df, file = "Move_July.csv", row.names = F)
                                                     # 저장할 데이터, 저장할 파일이름, 행번호는 없이.


# 2 