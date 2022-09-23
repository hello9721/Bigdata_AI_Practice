# 정형과 비정형 데이터

# 정형 데이터
  # 형식( 고정된 필드 )을 가진 데이터
  # 전처리 필요X

# 반정형 데이터
  # 태그를 포함하는 웹문서 ( 웹 크롤링 )
  # 전처리 필요O

# 비정형 데이터
  # 형식( 고정된 필드 )을 가지지 않은 데이터
  # 전처리 필요O

# 데이터 처리 => DBMS


# 1 정형 데이터 처리

# 관계형 데이터베이스 == 데이터프레임 형태를 가진 데이터

# Oracle
# MySQL (상용)  = MariaDB (오픈)


# MariaDB 사용시 필요 파일

  # MariaDB 설치 패키지, jdk의 11 GA 버전, MySQL connector/j의 5.xx버전


# 설치 순서

  # 1) MariaDB 설치 => 설치시 비밀번호 설정 및 UTF8 자동 인코딩 설정

  # 2) jdk 11 환경 설정

    Sys.setenv(JAVA_HOME = "C:/bigdataR/MariaDB/jdk-11")

  # 3) 필요 패키지 설치

    install.packages("rJava")
    install.packages("DBI")
    install.packages("RJDBC")

    library(rJava)
    library(DBI)
    library(RJDBC)

  # 4) MariaDB 연결

    drv <- JDBC(driverClass = "com.mysql.jdbc.Driver", "C:/bigdataR/MariaDB/mysql-connector-java-5.1.49.jar")
                                                            # MySQL connector 위치 설정
                                                    
  # 4_1) MariaDB로 데이터베이스 만들기

    # create database DB; / create table TABLE(); / insert into TABLE values(); 

  # 4_2) 데이터베이스 전용 계정 만들기

    # create user 'ID'@'localhost' identified by 'PW';      # 계정 추가
    # grant all privileges on TABLE.* to 'ID'@'localhost';  # 계정 권한 부여
    # flush privileges;                                     # 캐시를 지워 재시작 없이 사용 가능 하도록.

  # 4_3) DB 연동

    conn <- dbConnect(drv, "jdbc:mysql://127.0.0.1:3306/work", "hana", "bigdatar")
                                                            # dbConnect(drv, URL, ID, PW)

    query <- "select * from goods"                          # 데이터베이스를 선택하는 명령어를 문자열로 변수에 저장
    goodsAll <- dbGetQuery(conn, query)                     # dbGetQuery(연결, 명령문)
                                                            # 데이터베이스 가져오기

    
# 데이터베이스의 레코드 검색, 정렬, 추가, 수정, 삭제
    
    
# DML ( Data Manipulation Language ) : 데이터 조작어
# select, insert, update, delete
    
  # select FieldList from TABLE [ where 조건 order by 정렬 ]
  # insert into TABLE ( FieldList ) values ( ValueList )
  # update TABLE set Field1 = Val1 , ... where 조건
  # delete from TABLE where 조건
  
      
# 레코드 검색
    
sellAll <- dbGetQuery(conn, "select * from sell")
  
goods_sel <- dbGetQuery(conn, "select * from goods where su >= 3")
                                                            # 원하는 조건에 따른 레코드 검색

# 테이블 정렬

sell_order <- dbGetQuery(conn, "select * from sell order by su desc")
                                                            # 원하는 열을 내림차순 정렬 후 반환
                                                            # 기본값은 오름차순, desc 입력하면 내림차순

# 원하는 열만 가져오기 

sell <- dbGetQuery(conn, "select code, dan from sell")      # 열 지정 가져오기 가능

sell <- dbGetQuery(conn, "select code, dan from sell where dan >= 500000 and su >= 3")
                                                            # 조건에 맞는 행 중에 지정된 열만 가져오기

goods <- dbGetQuery(conn, "select * from goods where not name = '세탁기'")
                                                            # and or not 사용 가능

# 데이터베이스에 테이블 추가

dbWriteTable(conn, "goodSel", goods)                        # 데이터 프레임의 자료를 데이터베이스에 테이블로 저장
                                                            # dbWriteTable(연결, 테이블 이름, 데이터)
goodSel <- dbGetQuery(conn, "select * from goodSel")        # 조회 하여 확인

data <- read.csv(file = "C:/source/Part2/recode.csv", fileEncoding = "euc-kr")
dbWriteTable(conn, "goods2", data)                          # csv 데이터 불러와서 테이블로 데이터베이스에 저장

goodsAll <- dbGetQuery(conn, "select * from goods2")         # 테이블 조회 
                                    

# 테이블에 레코드 추가

dbSendUpdate(conn, "insert into goods2 values(6, 'test', 1, 1000)")
                                                            # dbSendUpdate(연결, "insert into TABLE values()")
                                                            # 테이블에 레코드 추가
# 테이블의 특정 레코드 값 변경

dbSendUpdate(conn, "update goods2 set name = '테스트' where code = 6")
                                                            # dbSendUpdate(연결, "update TABLE set ~ where ~")
goodsAll <- dbGetQuery(conn, "select * from goods2")
goodsAll

# 테이블의 특정 레코드 삭제

dbSendUpdate(conn, "delete from goods2 where code = 6")
                                                            # dbSendUpdate(연결, "delete from TABLE where ~")
goodsAll <- dbGetQuery(conn, "select * from goods2")
goodsAll

# DB와 연결 종료

dbDisconnect(conn)


# 실습
# code = 6 / dan = 200000 / name = "청소기" / su = 2

dbSendUpdate(conn, "insert into goods2 values( 6, '청소기', 2, 200000)")

goodsAll <- dbGetQuery(conn, "select * from goods2")
goodsAll

# dan >= 600000 => su = 5

dbSendUpdate(conn, "update goods2 set su = 5 where dan >=600000")

goodsAll <- dbGetQuery(conn, "select * from goods2")
goodsAll

# 수량이 1인 물품 삭제

dbSendUpdate(conn, "delete from goods2 where su = 1")

goodsAll <- dbGetQuery(conn, "select * from goods2")
goodsAll


# 데이터베이스 데이터 처리 문법

# 특정 문자열로 시작하거나 끝나는 레코드 조회
  # select * from TABLE where COL like '%STR'   # 해당 문자열로 끝나는 행
  # select * from TABLE where COL like 'STR%'   # 해당 문자열로 시작하는 행

# 일부 열의 데이터만 추가
  # NULL 값을 허용하는 열만 가능
  # desc TABLE 로 조회
  # insert into TABLE ( COL1, COL3, ...) values ( VAL1, VAL3, ... )
                                                # COL2 생략 -> NA로 기록

# 복수의 열에 대해 수정
  # update TABLE set COL1 = VAL5, COL2 = VAL9 where COL3 = VAL3
                                                # 조건에 맞는 행의 열들의 값이 지정한 값들로 변경

