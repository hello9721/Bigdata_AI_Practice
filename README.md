## 한국 IT 전문 학원 - S/W 및 빅데이터 지역 인재 양성 과정 - AI

</br>

:point_right: [PACKAGE.R](https://github.com/hello9721/R_Practice/blob/main/PACKAGE.R) :point_left:

               => 수업 과정 중 활용한 패키지들 모음 ( 샘플데이터활용 / 함수활용 / 시각화활용 )
#
#### 22/08/24  
    Day 01 1 - R의 개요 및 변수와 응용 함수 ( https://velog.io/@hello9721/R-001 ) 

#
#### 22/08/26  
    Day 02 1 - 문자열 및 데이터의 입출력과 저장
               * 통계청 기준 지역별 인구 통계 데이터 추출 :  
               ( 실습 파일 > https://github.com/XIUMAMU/R_Practice/tree/main/Day%202/Practice )

#
#### 22/09/01
    Day 03 1 - 숙제 검토 ( 인구 이동 통계에서 시, 군의 순이동이 양수 인 데이터만 추출 )
               ( 실습 파일 > https://github.com/XIUMAMU/R_Practice/blob/main/Day%203/Practice/Move_July.csv )
           2 - 연산자 ( 산술/관계/논리 연산자 ) 와 조건문 ( if/else if/ifelse/switch/which )
           3 - 반복문 ( for/while ) 과 함수 정의 ( function )
           4 - 주요 내장함수

#
#### 22/09/02
    Day 04 1 - 이산변수의 시각화 ( 세로/가로 막대 그래프, 누적 막대 그래프, 점 차트, 원형 차트 )
           2 - 연속변수의 시각화 ( 상자 그래프, 히스토그램, 산점도 그래프 )
           3 - dplyr 패키지를 통한 데이터프레임 처리
               ( 필터, 정렬, 조회, 추가, 요약통계, 그룹화, 병합, 합치기, 열 이름 변경 )

#
#### 22/09/15
    Day 05 1 - reshape2 패키지를 통한 데이터프레임의 형식 변환
               ( 긴형식과 넒은형식 변환, array 형태 변환 )
           2 - EDA의 정의, 수집한 자료에 대한 이해, 결측치와 극단치 처리
           3 - 코딩 변경, 변수 간의 관계분석

#
#### 22/09/16
    Day 06 1 - 파생변수 생성, 표본 변수 추출 ( 표본 샘플링 / 교차 검정 샘플링 ),
               실습 예제 풀기 ( airquality 데이터 셋에서 문제에서 요구하는 데이터 값 추출 )
           2 - 격자형 기법 시각화 ( 히스토그램, 밀도 그래프, 막대 그래프, 점 그래프, 산점도 그래프 )
               / 데이터 범주화 / 조건 그래프 / 3차원 산점도 그래프

#
#### 22/09/22
    Day 07 1 - ggplot2 패키지 ( qplot() / ggplot() / ggsave() ) 의 사용
           2 - ggmap 패키지 ( get_stamenmap() / ggmap() ) 의 사용과 고급 시각화 기법 연습 문제

#
#### 22/09/23
    Day 08 1 - 정형 데이터 처리 [ MariaDB 설치 및 사용, 문법
               ( 테이블과 레코드의 추가 / 수정 / 삭제 / 정렬 / 조회 )
               / heidiSQL 사용 실습 예제 ( https://github.com/XIUMAMU/R_Practice/tree/main/Day%208/Query ) ]

#
#### 22/09/26
    Day 09 1 - 반정형 데이터 처리 [ httr 패키지와 XML 패키지를 이용한 웹 스크래핑 / XML 파일의 데이터 처리 ]
               / Wordcloud / Wordcloud2

#
#### 22/10/04
    ES Ch 01 1 - 확률실험, 표본공간, 확률변수, 확률, 모집단, 표본, 편차, 분산, 표준편차
       Ch 02 1 - 확률분포, 이산형 확률분포, 이항분포, 다항분포
    Day 10 1 - 분석 절차, 가설설정 > 유의수준 결정 > 측정도구 설계 >
                                    데이터 수집 > 데이터 코딩 > 통계분석 > 분석결과 제시
           2 - 전수조사과 표본조사, 점 추정과 구간 추정, 기각역과 채택역, 양측 검정과 단측 검정, 가설검정 오류

#
#### 22/10/05
    ES Ch 02 2 - 중심극한정리
             3 - 연속형 확률분포, 정규분포, 표준 정규분포, 카이제곱 분포, F 분포

#
#### 22/10/06
    Day 11 1 - 척도별 기술통계량 ( 명목 / 서열 / 등간 / 비율 )
           2 - 기술 통계량 관련 연습문제
           3 - 교차분석, 교차분할표, 카이제곱검정,
               일원 카이제곱 검정 ( 적합도 / 선호도 ), 이원 카이제곱 검정 ( 독립성 / 동질성 )
           4 - 카이제곱 검정 관련 연습문제

#
#### 22/10/07
    ES Ch 02 4 - 이항분포 시각화 및 중심극한정리 실습
       Ch 03 1 - 데이터 분석의 시작을 위한 분포탐색 ( 데이터 치우침, 데이터 변환 )
       Ch 04 1 - 가설 설정, 가설 검정, 구간 추정, 유의수준, 신뢰수준, 신뢰구간
    Day 12 1 - 추정 ( 점추정, 구간추정 )
           2 - 단일 집단 비율 검정, 이항 분포 비율 검정, 단일 집단 간 평균 검정 (단일 표본 T-검정)
           3 - 두 집단 비율 검정, 두 집단 평균 검정 (독립 표본 T-검정), 동질성 검정, 두 집단 평균 차이 검정,
               대응 두 집단 평균 검정 (대응 표본 T-검정), 대응 두 집단 평균 차이 검정
           4 - 세 집단 비율 검정, 분산분석(ANOVA Analysis / F-검정), 세 집단 동질성 검정, 사후검정
           5 - 연습문제
               ( 이항 분포 비율 검정, 단일 집단 평균 차이 검정, 두 집단 비율 검정, 두 집단 평균 차이 검정 )

#
#### 22/10/11
    ES Ch 04 2 - 가설 검정의 절차
       Ch 05 1 - t 분포

#
#### 22/10/14
    Day 13 1 - 요인 분석 ( 공통요인으로 변수 정제 / 잘못 분류된 요인 제거로 변수 정제 )
           2 - 상관관계 분석 및 시각화 ( corrgram / PerformanceAnalytics )
           3 - 연습문제 ( 주어진 데이터의 요인 분석 및 요인적재량 시각화, 요인별 변수를 묶어 상관관계 계수 제시 )

#
#### 22/10/17
    Day 14 1 - 기계학습 - 지도학습 ( 회귀분석, 로지스틱 회귀분석 )
           2 - 기계학습 - 지도학습 ( 분류분석 - 의사결정트리 )

#
#### 22/10/21
    Day 15 1 - 기계학습 - 지도학습 ( 랜덤포레스트 ) / 중요변수 시각화
           2 - 기계학습 - 지도학습 ( 인공신경망 - nnet, neuralnet ) / 변수의 정규화
           3 - 기계학습 - 비지도학습 ( 군집분석 - 유클리디안 거리 ) ( 예정 )
    Day 16 1 - 기계학습 - 시계열 분석
                         ( 차분과 로그변환을 통한 시계열 정상화, 자기상관함수, 부분자기상관함수, 이동평균법 )
           2 - 실습 1 - 인공신경망을 통한 종합주가지수 예측 ( 한국 거래소의 개별지수 시세추이 데이터 활용 )
                        [ 정규화 -> 데이터 재구성 -> 인공신경망 학습 -> 데이터 예측 -> 모델 평가 ]
           3 - 실습 2 - 인공신경망을 통한 삼성전자의 2022.01 ~ 2022.09 종가 분석 및 예측

#
#### 22/10/31
    Day 17 1 - Python을 이용한 지도학습 - 분류 모델
               [ K-최근접 이웃 모델 / 서포트 벡터 머신 모델 / 결정트리 ]
           2 - Python을 이용한 지도학습 - 회귀 모델
               [ 로지스틱 회귀 모델 / 선형 회귀 모델 ]
           
#
#### 22/11/03
    Day 18 1 - Python을 이용한 비지도학습 - 군집화
               [ K-평균 군집화 모델 / 밀도 기반 군집화 모델 / 주성분 분석 ]
           2 - 딥러닝 기초 이론
           3 - Python을 이용한 딥러닝
               [ 합성곱 신경망 / 심층 신경망 ]

#
#### 22/11/04
    Day 19 1 - 딥러닝 [ DNN / CNN ] 실습
           2 - 전이 학습 / 특성 추출 기법 / ResNet50
           
#
#### 22/11/11
    Day 20 1 - tensorflow_hub 를 통한 모델 학습
           2 - 합성곱 신경망의 특성맵 시각화

#
#### 22/11/14
    Day 21 1 - 합성곱 신경망 [LeNet-5]
           2 - 합성곱 신경망 [AlexNet]
           3 - 실습 [ 동물 사진을 6종류로 분류하는 분류모델 만들기 ]
           
#
#### 22/11/17
    Day 22 1 - 실습 [ 와인 분석 데이터를 토대로 레드와인, 화이트와인 분류모델 만들기 ]
           2 - 실습 [ 동물 + 식물 사진을 총 11 종류로 분류하는 분류모델 만들기 ]
           3 - 시계열 - ARIMA 모델
