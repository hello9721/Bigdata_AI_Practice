age <- c(25,30,45)
names(age) <- c("C","B","A")
age <- NULL
a <- c(1:50)
a[5:30]
a[20:(length(a) -length(bool1))]
a[c(15,18,33)]
v1 <- c(13, -5, 20:23, 12, -2:3)
v1[c(3:5)]
v1[c(4, 4:8, 7)]
v1[-c(1)]
v1[-c(1:13)]
m <- matrix(c(1:10), nrow = 2, byrow=T)
m
x1 <- c(1,2,3,4,5)
x2 <- c(11:15)
mat <- rbind(x1,x2)
mt <- cbind(x1,x2)
mt
mode(mt)
class(mt)
mat[x1]
m3 <- matrix(10:19,2)
m3
m3[,4]
m3[2,5]
m3[]
m3[,5]
m4 <- matrix(a, nrow = 4, ncol=4)
m4
apply(m4,2,max)
apply(m4,2, mean)
apply(m4, 1, min)
f <- function(v){
  v * c(1,10,100,1000)
}
apply(m4,1, f)
result <- apply(m4,2,f)
result
ar <- array(c(1:12), c(3,2,2))
ar
ar[2,2,2]
no <- c(1,2,3)
name <- c("a","b","c")
age <- c(26,27,30)
df <- data.frame(No=no,Name=name,Age=age)
df
help(read.csv)
name <- c("사번","이름","급여")
csvtemp <- read.csv('c:/bigdataR/e.csv', header = T)
csvtemp
csvtemp2 <- read.csv('c:/bigdataR/ee.csv', header = F, col.names = name)
csvtemp2
csvtemp$no
csvtemp$name
str(csvtemp)
names(csvtemp)
summary(csvtemp)
