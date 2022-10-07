library(ggplot2)
library(reshape2)
library(dplyr)


# 이항 분포 시각화

data <- read.csv(file.choose(), header = T)

str(data)

ggplot(data) + geom_bar(aes(x = as.factor(waterfront), fill = as.factor(waterfront))) + 
  xlab("WaterFront") + ylab("Freqeuency") + theme_bw() + 
  guides(fill = "none") + theme(text = element_text(size = 15, face = "bold"))

d <- data %>% group_by(waterfront) %>% summarise(count = n()) %>% 
  mutate(perce = count/sum(count)*100)              # 이항분포 빈도 및 확률 계산


# 중심극한정리 시각화

coins <- c()

for (i in 1:1000){                                  # 횟수가 많아질수록 정규분포 그래프가 되어가고
                                                    # 확률의 평균이 중심이 된다.
  coin <- sample(c("H", "T"), 1000, replace = T, prob = c(0.7, 0.3))
  
  probs <- table(coin) / length(coin)
  h_prob <- probs["H"]
  
  coins[i] <- h_prob
  
}

hist(coins)

