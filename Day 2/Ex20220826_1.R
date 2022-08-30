df <- data.frame(x = c(101:105), y = seq(3,15,3), z = c("a","b","c","d","e"))
df
df$x
str(df)
summary(df)
apply(df[ , c(1,2)], 2, sum)
df_copy <- subset(df, y >= 6)
df_copy
df.and <- subset(df,y < 10 & x >= 102)
df.and
df.or <- subset(df,x == 105 | y < 10)
df.or
sid <- c("A","B", "C", "D")
score <- c(90,80,70,60)
subject <- c("컴퓨터", "국어국문", "소프트웨어", "유아교육")

student <- data.frame(sid, score, subject)
student
str(student)
str(student$sid)
height <- data.frame(id = c(1,2), h = c(180,175))
height
weight <- data.frame(id = c(1,2), w = c(80,75))
weight
user <- merge(height, weight, by.x = "id", by.y = "id"  )
user
language <- list(korean = c("가","나","다"), english = c("A","B","C"), number = c(1,2,3))
language
language$error <- c("a","ㄱ","5")
language
language$error[3] <- 666
language
language$error <- NULL
language
