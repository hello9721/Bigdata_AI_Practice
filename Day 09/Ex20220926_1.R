# 반정형 데이터 처리

# 웹 크롤링
# 크롤러(프로그램)를 이용하여 웹페이지 자료를 수집

# 스크래핑
# 웹사이트 내용을 가져와 원하는 형태로 가공

# 파싱
# 어떠한 페이지에서 원하는 데이터를 패턴이나 순서로 추출하여 가공

install.packages("httr")                          # 원격 서버의 URL 요청
install.packages("XML")                           # HTML 파싱

library(httr)
library(XML)

web <- GET("http://news.daum.net")                # 해당 사이트 HTML 정보 가져오기
                                                  # GET(url)

html <- htmlTreeParse(web, useInternalNodes = T, trim = T, encoding = "utf-8")
html                                              # HTML 내용 가져와서 변수에 저장
                                                  # useInternalNodes = T => ROOT 노드 찾을 수 있음.
                                                  # trim = T => 앞뒤 공백제거
                                                  # encoding => 인코딩 방식 설정 

root <- xmlRoot(html)                             # ROOT 노드 찾기
root

news <- xpathSApply(root, "//a[@class = 'link_txt']", xmlValue)
news                                              # xpathSApply(root, "//tag[@조건]", xmlValue)
                                                  # root에 저장된 HTML 소스에서 해당 tag들
                                                  # 그중 조건에 맞는 태그들의 Value, 내용을 뽑아서 벡터로 저장

# 전처리

news_pre <- gsub("[\r\n\t]", '', news)            # gsub("찾을 문자 혹은 패턴", "교체문자", 원본)
news_pre <- gsub("\\s+", ' ', news_pre)           # \\s+ => 2개 이상 공백 교체
news_pre <- gsub('[[:punct:]]', '', news_pre)     # [[:punct:]] => 문장부호
news_pre <- gsub('[[:cntrl:]]', '', news_pre)     # [[:cntrl:]] => 특수문자
news_pre <- gsub('[[]]', '', news_pre) 
news_pre <- gsub('뉴스1 PICK', '', news_pre)      # \\d+ => 숫자
news_pre                                          # [a-z]+ / [A-Z]+ => 소 / 대문자 영어
                                                  

library(stringr)
news_pre <- str_trim(news_pre)                    # 좌우 공백 제거
news_pre

setwd("c:/bigdataR")
write.csv(news_pre, "./news.csv", quote = F, fileEncoding = "euc-kr")
                                                  # 따옴표 없이 csv로 저장

news_data <- read.csv("news.csv", header = T, fileEncoding = "euc-kr")
names(news_data) <- c("No", "Title")
news_data

write.csv(news_data, "./news.csv", fileEncoding = "euc-kr", row.names = F)



# 실습 예제

# 코로나 19 사이트의 보도자료 탭의 번호, 제목, 작성자 파싱
# URL : http://ncov.kdca.go.kr/tcmBoardList.do?brdId=&brdGubun=&dataGubun=&ncvContSeq=&contSeq=&board_id=140&gubun=

URL <- "http://ncov.kdca.go.kr/tcmBoardList.do?brdId=&brdGubun=&dataGubun=&ncvContSeq=&contSeq=&board_id=140&gubun="

HTML <- GET(URL)
HTML <- htmlTreeParse(HTML, useInternalNodes = T, trim = T, encoding = 'utf-8')
root <- xmlRoot(HTML)                             # root 노드 소스 코드 추출

# 번호, 작성자 파싱 - 방법 A

num <- xpathSApply(root, "//td[@class = 'm_dp_n']", xmlValue)
num <- num[num != "첨부파일"]                     # 번호 뿐만 아니라 작성자, 첨부파일 까지 딸려옴
num                                               # 첨부파일 항목을 지운 후

number <- num[str_length(num) == 4]               # 번호는 4자리 숫자로 되어있으므로 길이가 4인 항목을 추출
number

author <- num[str_length(num) != 4]               # 나머지 길이가 4가 아닌 항목도 추출
author

# 번호, 작성자 파싱 - 방법 B

number <- xpathSApply(root, "//div[@class = 'board_list']//tbody/tr/td[1]", xmlValue)
                                                  # 바로 부모자식관계의 태그일 경우 /
                                                  # 몇단계 떨어진 관계일 경우 //
                                                  # tr 안의 여러개의 td 중 [1] 번째
author <- xpathSApply(root, "//div[@class = 'board_list']//tbody/tr/td[3]", xmlValue)


# 제목, 날짜 파싱

title <- xpathSApply(root, "//a[@class = 'bl_link']", xmlValue)
                                                  # root에서 제목도 추출

date <- xpathSApply(root, "//div[@class = 'board_list']//tbody/tr/td[4]", xmlValue)
                                                  # 작성날짜 추출

covid_df <- data.frame(No = number, Title = title, Author = author, Date = date)
covid_df                                          # 뽑아낸 정보로 데이터프레임 생성

write.csv(covid_df, "Covid.csv", row.names = F, fileEncoding = "euc-kr")
                                                  # csv 파일로 저장


# 반복문을 이용하여 여러 페이지의 데이터를 저장
# 1~10 페이지

covid_df <- data.frame(No = NULL, Title = NULL, Author = NULL, Date = NULL)
                                                  # 데이터가 누적되어 들어갈 df

for(i in c(1:10)){
  url <- paste("http://ncov.kdca.go.kr/tcmBoardList.do?pageIndex=",i,"&brdId=&brdGubun=&board_id=140&search_item=1&search_content=", sep = "")
                                                  # paste( str1, num1, ..., sep="구분자" )  -> 구분자로 여러 데이터형을 연결
                                                  # 구분자의 기본값은 " "
  HTML <- GET(URL)
  HTML <- htmlTreeParse(HTML, useInternalNodes = T, trim = T, encoding = 'utf-8')
  root <- xmlRoot(HTML)

  number <- xpathSApply(root, "//div[@class = 'board_list']//tbody/tr/td[1]", xmlValue)
  
  author <- xpathSApply(root, "//div[@class = 'board_list']//tbody/tr/td[3]", xmlValue)
 
  title <- xpathSApply(root, "//a[@class = 'bl_link']", xmlValue)
  
  date <- xpathSApply(root, "//div[@class = 'board_list']//tbody/tr/td[4]", xmlValue)

  sub <- data.frame(No = number, Title = title, Author = author, Date = date) 
                                                  # 결합을 위해 임시로 만든 df
  covid_df <- rbind(covid_df, sub)                # 행기준 결합
}

write.csv(covid_df, "Covid_1to10.csv", row.names = F, fileEncoding = "euc-kr")


# 쇼핑몰 스크래핑

searchName <- "노트북"

url <- paste("http://browse.auction.co.kr/search?keyword=", searchName, "&itemno=&nickname=&frm=hometab&dom=auction&isSuggestion=Yes&retry=&Fwk=", searchName, "&acode=SRP_SU_0100&arraycategory=&encKeyword=", searchName, sep = "")

html <- GET(url)                                  # 주소에 한글이 들어가면 인코딩 된 후후 들어가야함
                                                  
# 한글 인코딩 처리

searchName <- URLencode("노트북")

url <- paste("http://browse.auction.co.kr/search?keyword=", searchName, "&itemno=&nickname=&frm=hometab&dom=auction&isSuggestion=Yes&retry=&Fwk=", searchName, "&acode=SRP_SU_0100&arraycategory=&encKeyword=", searchName, sep = "")

html <- GET(url)
html <- htmlTreeParse(html, useInternalNodes = T, trim = T, encoding = 'utf-8')
root <- xmlRoot(html)

s_product <- xpathSApply(root, "//span[@class = 'text--title']", xmlValue)
s_price <- xpathSApply(root, "//strong[@class = 'text--price_seller']", xmlValue)
                                                  # 상품명, 가격 추출

s_price <- gsub(',', "", s_price)                 # 나중에 가격을 낮은순, 높은순으로 정렬해서 볼수 있도록
s_price <- as.numeric(s_price)                    # , 를 빼주고 numeric 형식으로 바꿔준다.

library(stringr)
s_product <- str_trim(s_product)    

shop <- data.frame(상품명 = s_product, 가격 = s_price)

write.csv(shop, "laptop_list.csv", row.names = F, fileEncoding = "euc-kr")


# XML 이용한 반정형 데이터 처리

# 공공데이터포털에 요청한 대기오염정보를 이용

region <- URLencode("충북")

url <- paste("http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?serviceKey=Fl%2B01oBLpWDxQgnBnovdYTZTLErq6%2BEssBdfhTmnwVA4jaBEGRlGamqyAH%2FPiZvS80c%2FJ%2BksHyB1z1igobb%2Fbw%3D%3D&returnType=xml&numOfRows=100&pageNo=1&sidoName=", region, "&ver=1.0", sep = "" )

# "https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/이용서비스?serviceKey=일반 인코드 키&returnType=받을 데이터 타입&numOfRows=한페이지 결과수&pageNo=페이지 수&[sido/station]Name=조회[지역/측정소][&dataTerm=데이터측정기간]&ver=버전"

xmlF <- xmlParse(url)

df <- xmlToDataFrame(getNodeSet(xmlF, "//item"))  # xml파일을 탐색하면서 item 태그를 전부 dataframe으로 저장

# items : 목록
# so2 : 아황산가스 / co : 일산화탄소 / khai : 통합대기환경
# pm25 : 초미세먼지 / pm10 : 미세먼지
# o3 : 오존 / sido : 지역 / no2 : 이산화질소 / station : 측정소
# Grade : 지수 [ 1 - 4 | 좋음 - 매우나쁨]
# Value : 농도 / Flag : 플래그

# 충북 대기오염지수 데이터프레임
air_grade_df <- data.frame(측정소 = df$stationName, 대기환경지수 = df$khaiGrade, 초미세먼지지수 = df$pm10Grade,
                           미세먼지지수 = df$pm10Grade, 오존지수 = df$o3Grade, 일산화탄소지수 = df$coGrade,
                           이산화질소지수 = df$no2Grade, 아황산가스지수 = df$so2Grade)

# 충북 대기오염농도 데이터프레임
air_value_df <- data.frame(측정소 = df$stationName, 대기환경농도 = df$khaiValue, 초미세먼지농도 = df$pm10Value,
                           미세먼지농도 = df$pm10Value, 오존농도 = df$o3Value, 일산화탄소농도 = df$coValue,
                           이산화질소농도 = df$no2Value, 아황산가스농도 = df$so2Value)

# 미세먼지 농도 그래프

station <- air_value_df$측정소
pm10V <- as.numeric(air_value_df$미세먼지농도)

barplot(pm10V, names.arg = station, col = rainbow(7))


# 특정 측정소의 실시간 정보 데이터

install.packages("RCurl")
library(RCurl)                                  # Error: XML content does not seem to be XML 해결을 위한 패키지 설치 및 

region <- URLencode("복대동")

url <- paste("https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey=Fl%2B01oBLpWDxQgnBnovdYTZTLErq6%2BEssBdfhTmnwVA4jaBEGRlGamqyAH%2FPiZvS80c%2FJ%2BksHyB1z1igobb%2Fbw%3D%3D&returnType=xml&numOfRows=100&pageNo=1&stationName=", region, "&dataTerm=MONTH&ver=1.0", sep = "")

dataurl <- getURL(url)                          # RCurl에서 제공하는 getURL을 사용하여 url을 뽑아내서 파싱

xmlF <- xmlParse(dataurl)
df <- xmlToDataFrame(getNodeSet(xmlF, "//item"))
df

# 복대동 대기환경지수 데이터
bokdae_grade_df <- data.frame(측정시간 = df$dataTime, 대기환경지수 = df$khaiGrade, 초미세먼지지수 = df$pm10Grade,
                              미세먼지지수 = df$pm10Grade, 오존지수 = df$o3Grade, 일산화탄소지수 = df$coGrade,
                              이산화질소지수 = df$no2Grade, 아황산가스지수 = df$so2Grade)

# 복대동 대기환경농도 데이터
bokdae_value_df <- data.frame(측정시간 = df$dataTime, 대기환경농도 = df$khaiValue, 초미세먼지농도 = df$pm10Value,
                              미세먼지농도 = df$pm10Value, 오존농도 = df$o3Value, 일산화탄소농도 = df$coValue,
                              이산화질소농도 = df$no2Value, 아황산가스농도 = df$so2Value)

bokdae_pm10 <- as.numeric(bokdae_value_df$미세먼지농도)
bokdae_pm10 <- ifelse(is.na(bokdae_pm10), round( mean(bokdae_pm10, na.rm = T), 0), bokdae_pm10)

bokdae_time <- bokdae_value_df$측정시간

# 복대동 시간별 미세먼지농도 그래프
barplot(bokdae_pm10, names.arg = str_sub(bokdae_time, 12), col = rainbow(12))


# WordCloud 그리기
# 빈도수가 많은 단어부터 적은 단어까지 크기별로 그려짐

install.packages("wordcloud")
library(wordcloud)                              # 패키지 설치 및 로드

word <- c("서울", "부산", "대구")               # 샘플 단어 데이터
freq <- c(300, 230, 150)                        # 샘플 단어별 빈도수 데이터

wordcloud(word, freq, random.order = F, random.color = F, colors = rainbow(4))
                                                # wordcloud(단어, 빈도수[, ...])
                                                # min.frq = n -> 최소 빈도수
                                                # random.order = T/F -> 중심단어위치 변함/그대로

# 순이동이 - 가 아닌 시군 중 전입이 많은 시군을 Wordcloud로 그리기

pop <- read.csv(file.choose(), header = T, fileEncoding = "euc-kr")
head(pop)

region1 <- grep('시$', pop$행정구역.시군구.별)
region2 <- grep('군$', pop$행정구역.시군구.별)
                                                # 시와 군 인덱스 데이터 추출
region1 <- pop[region1, ]
region2 <- pop[region2, ]
                                                # 해당 인덱스의 데이터 추출
region <- rbind(region1, region2)               # 두 데이터를 통합한 후
region <- region[  region$순이동.명. > 0 , ]    # 순이동이 양수인 데이터만 추출
region

wordcloud(region$행정구역.시군구.별, region$총전입.명., random.order = F, scale = c(5,1), random.color = F, colors = rainbow(50))
                                                # 전입 기준으로 그리기기
