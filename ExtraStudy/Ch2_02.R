# 중심극한정리

# 어떤 분포를 가지는지 정확히 알 수 없지만
# 동일한 확률분포를 가지는 확률변수로부터 추출된 n개의 표본평균은
# n이 클수록 정규분포에 가까워진다는 정리

# 여기서 n은 실험을 독립적으로 n번 진행했을 때 표본을 의미

# 정규분포 -> 평균을 중심으로 대칭 구조를 가지는 연속형 확률분포

# ex) 동전을 10번 던져서 나오는 확률을 계산하는데
#     이 10번 던져보는 실험을 n번 반복했을때 앞이 나올 확률의 분포가
#     정규분포에 가까워진다.

coins <- c()                       # 빈 벡터 생성

for(i in 1:1000){
                                  # replace = T 중복추출
  coin <- sample(x = c("H", "T"), size = 10, replace = T)
                                  # Head와 Tail로 이루어진
                                  # 10개의 샘플 데이터
  probs <- table(coin)/length(coin)
                                  # coin을 테이블로 만든 것을 length로 나누면 확률이 된다.
  coins[i] <- probs["H"]          # Head가 나올 확률을 i에 담는다.
  
}

library(ggplot2)                  # 시각화 패키지

ggplot() + geom_histogram(aes(x=coins), binwidth = 0.05) + theme_bw() + theme(legend.position = "bottom")
                                  # coins로 히스토그램
                                  # for문에서 반복 횟수가 커질수록 정규분포에 가까워진다.

