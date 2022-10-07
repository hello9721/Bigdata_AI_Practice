# R_Practice
### 한국 IT 전문 학원 - SW 및 빅데이터 지역 인재 양성 과정 - R
####
#### 22/08/24  
    Day 01 1 - R의 개요 및 변수와 응용 함수 ( https://velog.io/@hello9721/R-001 ) 
#### 22/08/26  
    Day 02 1 - 문자열 및 데이터의 입출력과 저장 ( https://velog.io/@hello9721/R-002 )
             * 통계청 기준 지역별 인구 통계 데이터 추출 :  
             ( 실습 파일 > https://github.com/XIUMAMU/R_Practice/tree/main/Day%202/Practice )
#### 22/09/01
    Day 03 1 - 숙제 검토 ( 인구 이동 통계에서 시, 군의 순이동이 양수 인 데이터만 추출 )
             ( https://velog.io/@hello9721/R-003 )
             ( 실습 파일 > https://github.com/XIUMAMU/R_Practice/blob/main/Day%203/Practice/Move_July.csv )
           2 - 연산자 ( 산술/관계/논리 연산자 ) 와 조건문 ( if/else if/ifelse/switch/which )
           3 - 반복문 ( for/while ) 과 함수 정의 ( function )
           4 - 주요 내장함수
#### 22/09/02
    Day 04 1 - 이산변수의 시각화 ( 세로/가로 막대 그래프, 누적 막대 그래프, 점 차트, 원형 차트 )
               ( https://velog.io/@hello9721/R-004 )
           2 - 연속변수의 시각화 ( 상자 그래프, 히스토그램, 산점도 그래프 )
           3 - dplyr 패키지를 통한 데이터프레임 처리
              ( 필터, 정렬, 조회, 추가, 요약통계, 그룹화, 병합, 합치기, 열 이름 변경 )
#### 22/09/15
    Day 05 1 - reshape2 패키지를 통한 데이터프레임의 형식 변환
               ( 긴형식과 넒은형식 변환, array 형태 변환 )
           2 - EDA의 정의, 수집한 자료에 대한 이해, 결측치와 극단치 처리
           3 - 코딩 변경, 변수 간의 관계분석
#### 22/09/16
    Day 06 1 - 파생변수 생성, 표본 변수 추출 ( 표본 샘플링 / 교차 검정 샘플링 ),
               실습 예제 풀기 ( airquality 데이터 셋에서 문제에서 요구하는 데이터 값 추출 )
           2 - 격자형 기법 시각화 ( 히스토그램, 밀도 그래프, 막대 그래프, 점 그래프, 산점도 그래프 )\
               / 데이터 범주화 / 조건 그래프 / 3차원 산점도 그래프
#### 22/09/22
    Day 07 1 - ggplot2 패키지 ( qplot() / ggplot() / ggsave() ) 의 사용
           2 - ggmap 패키지 ( get_stamenmap() / ggmap() ) 의 사용과 고급 시각화 기법 연습 문제
#### 22/09/23
    Day 08 1 - 정형 데이터 처리 [ MariaDB 설치 및 사용, 문법 ( 테이블과 레코드의 추가 / 수정 / 삭제 / 정렬 / 조회 )
               / heidiSQL 사용 실습 예제 ( https://github.com/XIUMAMU/R_Practice/tree/main/Day%208/Query ) ]
#### 22/09/26
    Day 09 1 - 반정형 데이터 처리 [ httr 패키지와 XML 패키지를 이용한 웹 스크래핑 / XML 파일의 데이터 처리 ]
               / Wordcloud / Wordcloud2
#### 22/10/04
    ES Ch 01 1 - 확률실험, 표본공간, 확률변수, 확률, 모집단, 표본, 편차, 분산, 표준편차
       Ch 02 1 - 확률분포, 이산형 확률분포, 이항분포, 다항분포
    Day 10 1 - 분석 절차, 가설설정 > 유의수준 결정 > 측정도구 설계 > 데이터 수집 > 데이터 코딩 > 통계분석 > 분석결과 제시
           2 - 전수조사 / 표본조사, 점 추정 / 구간 추정, 기각역 / 채택역, 양측 / 단측 검정, 가설검정 오류
#### 22/10/05
    ES Ch 02 2 - 중심극한정리
             3 - 연속형 확률분포, 정규분포, 표준 정규분포, 카이제곱 분포, F 분포
#### 22/10/06
    Day 11 1 - 척도별 기술통계량 ( 명목 / 서열 / 등간 / 비율 )
           2 - 기술 통계량 관련 연습문제
           3 - 교차분석, 교차분할표, 카이제곱검정, 일원 카이제곱 검정 ( 적합도 / 선호도 ), 이원 카이제곱 검정 ( 독립성 / 동질성 )
           4 - 카이제곱 검정 관련 연습문제
#### 22/10/07
    ES Ch 02 4 - 이항분포 시각화 및 중심극한정리 실습
    Day 12 1 - 추정 ( 점추정, 구간추정 )
           2 - 단일 집단 비율 검정, 이항 분포 비율 검정, 단일 집단 간 평균 검정 (단일 표본 T-검정)
           3 - 두 집단 비율 검정, 두 집단 평균 검정 (독립 표본 T-검정), 동질성 검정, 두 집단 평균 차이 검정,
               대응 두 집단 평균 검정 (대응 표본 T-검정), 대응 두 집단 평균 차이 검정
           4 - 세 집단 비율 검정,
