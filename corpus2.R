# Install

install.packages("tm")  # for text mining
install.packages("SnowballC") # for text stemming(어근추출)
install.packages("wordcloud") # word-cloud generator 
install.packages("RColorBrewer") # color palettes

# Load
library("tm")
library("SnowballC") #stemDocument어근추출위해
library("wordcloud")
library("RColorBrewer")
library(readxl)

consul <- read_excel("exam2.xlsx", col_names = F)
consul

docs <- VCorpus(VectorSource(consul))
docs

#공백제거
docs <- tm_map(docs, stripWhitespace)

# Convert the text to lower case(소문자변경-사전에 있는 내용과 비교하기 위해)
docs <- tm_map(docs, tolower)
# Remove numbers(숫자제거)
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords(뛰어쓰기와 시제 제거 )
docs <- tm_map(docs, removeWords, stopwords("english"))

# Remove punctuations(구두점제거)
docs <- tm_map(docs, removePunctuation)

# Text stemming(어근만 추출한다) SnowballC패키지 설치
docs <- tm_map(docs, stemDocument)


#term document matrix를 만든다.
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)

dtm <- TermDocumentMatrix(docs, control=list(wordLengths=c(4,Inf)))
m <- as.matrix(dtm)

#term document matrix의 결과를  합해서 내림차순으로 정렬
v <- sort(rowSums(m),decreasing=TRUE) 
d <- data.frame(word = names(v),freq=v)
head(d, 10)