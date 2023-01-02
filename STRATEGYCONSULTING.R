############# 페키지 다운 ############# 

## KoNLP 다운
Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre1.8.0_321")
install.packages("rJava")
install.packages("multilinguer")
multilinguer::install_jdk()
install.packages(c('stringr', 'hash', 'tau', 'Sejong', 'RSQLite', 'devtools'), type = "binary")
install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))
DONE(KoNLP)
library(KoNLP)
useSejongDic()
useNIADic()

extractNoun('집에 가고 싶다')

## 기타 패키지

install.packages("stringr")
install.packages("dplyr")
install.packages("wordcloud")
install.packages("wordcloud2")
install.packages("tm")
install.packages("tidytext")

library(dplyr)
library(stringr)
library(RColorBrewer)
library(wordcloud)
library(wordcloud2)
library(tm)
library(tidytext)

##한글이 깨질때
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")





############# 단어 추가/제거하기 #############
mergeUserDic(data.frame(c("훈련생", "쌍방향훈련", "재량학습활동", "비대면", "혼합훈련", "활용", "직업상담사"), c("ncn"))) # 다시 명사추출





############# 파일 불러오기 ############# 


install.packages("readxl")
library(readxl)

setwd("C:\\Users\\Administrator\\OneDrive\\data\\dobby\\dobby")

consul <- read_excel("operst.xlsx", col_names = F)
consul


############# 명사 추출 ############# 
https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=nonamed0000&logNo=220959119930

exNouns <- function(x) {paste(extractNoun(as.character(x)), collapse=" ")}

consul_n <- sapply(consul, exNouns)





############# 데이터 전처리 #############
consul_n <- sapply(consul_n, str_remove_all,'\\s+') # 텍스트 공백 제거
consul_n <- sapply(consul_n, unique) # 한 줄 안에 중복되는 단어 제거

corpus_nv <- Corpus(VectorSource(consul_n))
corpus_nv


corpus_nv <- tm_map(corpus_nv, removePunctuation) # 문장부호 제거
corpus_nv <- tm_map(corpus_nv, removeNumbers) # 수치 제거
corpus_nv <- tm_map(corpus_nv, tolower) #소문자 변경
corpus_nv <- tm_map(corpus_nv, removeWords, stopwords('english')) #불용어 제거

inspect(corpus_nv[1:5])



corpus_txt <- gsub("c","",consul_txt)
############### 단어 선별 #####################

## PlainTextDocument 함수를 이용하여 myCorpus를 일반문서로 변경
consul_txt <- tm_map(corpus_nv, PlainTextDocument)



## TermDocumentMatrix() : 일반텍스트문서를 대상으로 단어 선별
# 단어길이 2개 이상인 단어만 선별 -> matrix 변경
consul_txt <- TermDocumentMatrix(consul_txt, control=list(wordLengths=c(4,Inf)))

## matrix -> data.frame 변경
consul.df <- as.data.frame(as.matrix(consul_txt)) 




word <- sort(rowSums(consul.df), decreasing=TRUE) # 빈도수로 내림차순 정렬
word[1:20] 
word200 <- head(word,200)
word200

wc <- names(word200) # 단어 이름 추출(빈도수 이름) 

word.df <- data.frame(word=wc, freq=word200)



############# 워드클라우드 생성 ######################

wordcloud2(word.df,
           shape='circle')


wordcloud2(word.df,
           minRotation=-pi/6, 
           maxRotation=-pi/6,
           rotateRatio=1)