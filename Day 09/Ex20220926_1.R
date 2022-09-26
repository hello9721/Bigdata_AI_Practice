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

news_pre <- gsub("[\r\n\t]", '', news)            # gsub("패턴", "교체문자", 원본)
news_pre <- gsub("\\s+", ' ', news_pre)           # \\s+ => 2개 이상 공백 교체
news_pre <- gsub('[[:punct:]]', '', news_pre)     # [[:punct:]] => 문장부호
news_pre <- gsub('[[:cntrl:]]', '', news_pre)     # [[:cntrl:]] => 특수문자
news_pre <- gsub('[[]]', '', news_pre)            # [원하는문장부호] 제거
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

searchName <-

url <- 

html <- GET(url)
html <- htmlTreeParse(html, useInternalNodes = T, trim = T, encoding = 'utf-8')
root <- xmlRoot(root)

s_title <- xpathSApply(root, "//span[@class = 'text--title']", xmlValue)

url
