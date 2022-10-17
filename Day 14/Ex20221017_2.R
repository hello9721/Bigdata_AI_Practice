# 분류 분석


# 의사결정 트리

# 나무 구조 형태로 분류결과를 도출하는 방식
# 입력 변수 중 가장 영향력이 있는 변수를 기준으로 이진 분류하여 분류결과를 나무 구조 형태로 시각화

install.packages("party")                           # 의사결정트리 생성을 위한 패키지
library(party)
library(datasets)

a <- airquality                                     # 샘플데이터 생성

# 온도에 영향을 미치는 변수를 알아보기 위하여
# 온도를 종속변수로, 태양광 / 바람 / 오존을 독립변수로

a_ctree <- ctree(Temp ~ Solar.R + Wind + Ozone, a)
a_ctree

plot(a_ctree)                                       # 의사결정트리 시각화
                                                    # 오존 수치가 가장 영향력 있고
                                                    # 오존이 37 이하라면 바람의 영향을 받는다.
                                                    # 태양광은 영향을 미치지 않는 것으로 분석

smp <- sample(1:nrow(iris), nrow(iris)*0.7)         # 70:30 = 학습:검정
train <- iris[smp, ]
test <- iris[-smp, ]

i_ctree <- ctree(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, train)
plot(i_ctree, type="simple")                        # 간단한 형식으로 시각화
                                                    
                                                    # 꽃받침 길이가 종을 구분하는데 가장 영향력 있고
                                                    # 1.9 보다 작으면 꽃받침의 넓이가,
                                                    # 꽃잎의 길이와 넓이는 영향을 미치지 않는 것으로 분석

pre <- predict(i_ctree, test)
table(pre, test$Species)                            # 생성된 예측치로 혼돈 매트릭스 생성
(15 + 12 + 15)/45                                   # 분류 정확도 => 93.3%


# K겹 교차 검정 샘플링으로 분류 분석

library(cvTools)
cross <- cvFolds(nrow(iris), K = 3, R = 2)          # sample 함수 대신 K겹 교차 검정으로 샘플링

str(cross)
cross

length(cross$which)
table(cross$which)

R <- 1:2                                            # 반복 횟수
K <- 1:3                                            # 겹 수
CNT <- 0                                            # 카운터 변수
ACC <- numeric()                                    # 분류정확도 저장

for(r in R){                                        # 검정 총 2번 전체 반복
  
  cat("\n R = ", r, "\n")

  for(k in K){                                      # 겹 만큼 시행
    
    idx <- cross$subsets[cross$which == k, r]       # k가 1일때, 2일때, 3일때
    
    test <- iris[idx, ]                             # 앞에서 뽑은 인덱스로 검정데이터
    
    cat("test : ", nrow(test), '\n')
    
    
    train <- iris[-idx, ]                           # 검정 데이터를 제외한 나머지를 학습데이터
    
    cat("train : ", nrow(train), "\n")
    
    
    model <- ctree(Species~., data = train)         # 학습데이터로 모델 생성
    
    pred <- predict(model, test)                    # 검정데이터로 예측치 생성
    
    t <- table(pred, test$Species)                  # 예측치와 관측치로 테이블 생성
    
    print(t)
    
    
    CNT <- CNT + 1                                  # 현재 횟수 저장
    
    ACC[CNT] <- (t[1,1] + t[2,2] + t[3,3])/sum(t)   # 그 횟수 칸에 그 횟수의 분류정확도 저장
  }
  
}

ACC                                                 # 분류정확도 확인

length(ACC)

r <- mean(ACC, na.rm = T)
r                                                   # 정확도 평균 -> 94.67%



# iris 데이터 활용하여 로지스틱 회귀분석 하기

iris

df <- iris
df$Species <- as.numeric(df$Species)

summary(df)

smp <- sample(1:nrow(df), nrow(df)*0.7)

test <- df[-smp, ]
train <- df[smp, ]

model <- glm(Species ~ ., data = df)            
model

pre <- predict(model, test)

pre[pre <= 1.4] <- 1
pre[1.4 < pre & pre <= 2.4] <- 2
pre[2.4 < pre] <- 3

table(pre, test$Species)                            # 99%

