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

# 코로나 19 사이트의 보도자료 탭의 번호 제목 담당자 파싱
# URL : http://ncov.kdca.go.kr/tcmBoardList.do?brdId=&brdGubun=&dataGubun=&ncvContSeq=&contSeq=&board_id=140&gubun=

URL <- "http://ncov.kdca.go.kr/tcmBoardList.do?brdId=&brdGubun=&dataGubun=&ncvContSeq=&contSeq=&board_id=140&gubun="

HTML <- GET(URL)
HTML <- htmlTreeParse(HTML, useInternalNodes = T, trim = T, encoding = 'utf-8')
root <- xmlRoot(HTML)                             # root 노드 소스 코드 추출

num <- xpathSApply(root, "//td[@class = 'm_dp_n']", xmlValue)
num <- num[num != "첨부파일"]                     # 번호 뿐만 아니라 작성자, 첨부파일 까지 딸려옴
num                                               # 첨부파일 항목을 지운 후

number <- num[str_length(num) == 4]               # 번호는 4자리 숫자로 되어있으므로 길이가 4인 항목을 추출
number

charge <- num[str_length(num) != 4]               # 나머지 길이가 4가 아닌 항목도 추출
charge

title <- xpathSApply(root, "//a[@class = 'bl_link']", xmlValue)
title                                             # root에서 제목도 추출

covid_df <- data.frame(No = number, Title = title, Author = charge)
covid_df                                          # 뽑아낸 정보로 데이터프레임 생성

write.csv(covid_df, "Covid.csv", row.names = F, fileEncoding = "euc-kr")
                                                  # csv 파일로 저장

