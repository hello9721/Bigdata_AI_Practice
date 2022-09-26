install.packages("stringr")
library(stringr)
str_extract("abdcs212dfsd356dfsfd849sdfsdfd2sdfsdfd578","[1-9]{3}")
str_extract_all("abdcs212dfsd356dfsfd849sdfsdfd2sdfsdfd578","[1-9]{3}")

str1 <- "1234홍길동"
strsub <- str_sub(str1, 5, )
strsub
str2 <- str_replace(str1, "1234", "95845")
str2
str3 <- "123a,45d,6855,2154q"
strsp <- str_split(str3,",")
strsp
strsp <- unlist(strsp)
strsp <- paste(strsp, collapse = " ")
strsp
strsp <- str_split(strsp," ")
strsp
strsp <- paste(strsp,collapse = " ")
strsp
install.packages("writexl")
library(writexl)
install.packages("RSADBE")
library(RSADBE)
install.packages("readxl")
library(readxl)
pop <- read.csv(file.choose(), sep = ",", header = T)
pop
str(pop)
summary(pop)
head(pop)
tail(pop)
"도$"
x <- grep("도$",pop$행정구역.시군구.별) #조회대상의 행번호를 벡터로 반환
data1 <- pop[x, ]
data1
x1 <- grep("광역시$", pop$행정구역.시군구.별)
data2 <- pop[x1, ]
data2
x <- grep("특별시$", pop$행정구역.시군구.별)
data3 <- pop[x, ]
data3
x <- grep("특별자치시$", pop$행정구역.시군구.별)
data4 <- pop[x, ]
data4
ndata <- rbind(ndata, data4)
ndata
df <- data.frame(행정구역 = ndata$행정구역.시군구.별, 남자인구수 = ndata$남자인구수.명., 여자인구수 = ndata$여자인구수.명.)
df
setwd("C:/bigdataR")
write.csv(x = df,file = "Population.csv", row.names = F)
sdata <- read.csv(file.choose(), sep = ",", header = T)
sdata
x <- grep("특별자치시$",sdata$행정구역.시군구.별)
x
data64 <- sdata[x,]
data64
data6m <- rbind(data6m, data64)
data6m
df6 <- data.frame(행정구역 = data6m$행정구역.시군구.별, 남자인구수 = data6m$남자인구수.명., 여자인구수 = data6m$여자인구수.명., 총인구수 = data6m$총인구수.명.)
df6
setwd("c:/bigdataR")
write.csv(x=df6, file = "Population_June.csv", row.names = F)
