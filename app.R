#James Yefta Dean -Twitter Sentiment Analysis

#-Libraries Needed--------------
library(twitteR)
library(RCurl)
library(wordcloud)
library(tm)
library(tmap)
library(plyr) #split apply combine (for arrays)
library(stringr)
library(XML)
library(ggplot2)
#---END OF Libraries Needed--------------

#-Setting up twitteR plugin to fetch tweets
#-Consumer Key & Secret-------
consumer_key <- 'CfLTMPvstHSwfGrsGjnjVoQOn'
consumer_secret <- '9a4yMNVX3dy1PAslyHWx30xT4B6lxkOEQoSRBXiCyEULFb03Lu'
access_token <- '82077624-lVXlgJWUnd3Tl5MjrziVWJnmYTAraJd6L4m9h3bwu'
access_secret <- 'FnFjLUpTzjMBfuP6prIznQqBW9aO42K9uimUDD46f8s8a'
#-Setup twitteR library //needed before we use twitteR--------
setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_secret) #loads james' consumer key
#---END OF Setup twitteR library


#Step 1 Twitter [Search Twitter & Collect Tweets]
#-Start twitter search---------------
kfc_tweet <- searchTwitter('kfc -filter:retweets', lang="en",n=250,resultType="recent", geocode='37.0902,-95.7129,1500mi') #download kfc tweets
mcD_tweet <- searchTwitter('mcDonald -filter:retweets', lang="en",n=250,resultType="recent", geocode='37.0902,-95.7129,1500mi') #download mcd tweets
dd_tweet <- searchTwitter('dunkin+donuts -filter:retweets', lang="en",n=250,resultType="recent", geocode='37.0902,-95.7129,1500mi') #download dunkindonuts tweets
bk_tweet <- searchTwitter('burger+king -filter:retweets', lang="en",n=250,resultType="recent", geocode='37.0902,-95.7129,1500mi')
wen_tweet <- searchTwitter('wendys -filter:retweets', lang="en",n=250,resultType="recent", geocode='37.0902,-95.7129,1500mi')
ph_tweet <- searchTwitter('pizza+hut -filter:retweets', lang="en",n=250,resultType="recent", geocode='37.0902,-95.7129,1500mi')
dom_tweet <- searchTwitter('dominos+pizza -filter:retweets', lang="en",n=250,resultType="recent", geocode='37.0902,-95.7129,1500mi')
#---End of twitter search-----------------


#[FOR TROUBLESHOOTING] check the kfc_tweet stats
length(kfc_tweet) #shows the length/amount of tweets
class(kfc_tweet) #shows the class/data-type
head(kfc_tweet,5) #prints the first 5 tweets
length(mcD_tweet) #shows the length/amount of tweets
class(mcD_tweet) #shows the class/data-type
head(mcD_tweet,5) #prints the first 5 tweets
#it will return a list (a collection of objects), use "variableName[[#NUMBER]]" to access elements
#[END OF TROUBLESHOOTING]


#-Convert to character vector-------------------
kfc_text <- sapply(kfc_tweet,function(x) x$getText())
mcD_text <- sapply(mcD_tweet,function(x) x$getText())
bk_text <- sapply(bk_tweet,function(x) x$getText())
dd_text <- sapply(dd_tweet,function(x) x$getText())
dom_text <- sapply(dom_tweet,function(x) x$getText())
ph_text <- sapply(ph_tweet,function(x) x$getText())
wen_text <- sapply(wen_tweet,function(x) x$getText())

#[FOR TROUBLESHOOTING] check the kfc_text & mcd_text stats after converting into character vector
length(kfc_text) #shows the length/amount of tweets
class(kfc_text) #shows the class/data-type
head(kfc_text,5) #prints the first 5 tweets
length(mcD_text) #shows the length/amount of tweets
class(mcD_text) #shows the class/data-type
head(mcD_text,5) #prints the first 5 tweets
#[END OF TROUBLESHOOTING]--
#---End of converting to character vector-----------------


#-Convert to corpus and put it in the according variable--------------  
kfc_corpus <- Corpus(VectorSource(kfc_text))
mcD_corpus <- Corpus(VectorSource(mcD_text))
bk_corpus <- Corpus(VectorSource(bk_text))
dd_corpus <- Corpus(VectorSource(dd_text))
dom_corpus <- Corpus(VectorSource(dom_text))
ph_corpus <- Corpus(VectorSource(ph_text))
wen_corpus <- Corpus(VectorSource(wen_text))

#[FOR TROUBLESHOOTING]
kfc_corpus
inspect(kfc_corpus[89])
mcD_corpus
inspect(mcD_corpus[81])
#[END OF TROUBLESHOOTING]--
#-End of converting to corpus-------------------  

#-Cleaning the tweet corpus and putting it into a new "clean" corpus--------------------------------
kfc_clean <- tm_map(kfc_corpus, removePunctuation) #remove punctuation
kfc_clean <- tm_map(kfc_clean, removeNumbers) #remove numbers
kfc_clean <- tm_map(kfc_clean, removeWords,stopwords('en')) #remove stopwords (english)
kfc_clean <- tm_map(kfc_clean, stripWhitespace) #strip whitespace so that we can compare the words later
kfc_clean <- tm_map(kfc_clean, content_transformer(tolower)) #switch to lower-case
#kfc_clean <- tm_map(kfc_clean, removeWords, c("kfc")) #remove the words that contain the searched word

mcD_clean <- tm_map(mcD_corpus, removePunctuation) #remove punctuation
mcD_clean <- tm_map(mcD_clean, removeNumbers) #remove numbers
mcD_clean <- tm_map(mcD_clean, removeWords,stopwords('en')) #remove stopwords (english)
mcD_clean <- tm_map(mcD_clean, stripWhitespace) #strip whitespace so that we can compare the words later
mcD_clean <- tm_map(mcD_clean, content_transformer(tolower)) #switch to lower-case
#mcD_clean <- tm_map(mcD_clean, removeWords, c("mcDonald")) #remove the words that contain the searched word

bk_clean <- tm_map(bk_corpus, removePunctuation) #remove punctuation
bk_clean <- tm_map(bk_clean, removeNumbers) #remove numbers
bk_clean <- tm_map(bk_clean, removeWords,stopwords('en')) #remove stopwords (english)
bk_clean <- tm_map(bk_clean, stripWhitespace) #strip whitespace so that we can compare the words later
bk_clean <- tm_map(bk_clean, content_transformer(tolower)) #switch to lower-case
#bk_clean <- tm_map(bk_clean, removeWords, c("burger+king")) #remove the words that contain the searched word

dd_clean <- tm_map(dd_corpus, removePunctuation) #remove punctuation
dd_clean <- tm_map(dd_clean, removeNumbers) #remove numbers
dd_clean <- tm_map(dd_clean, removeWords,stopwords('en')) #remove stopwords (english)
dd_clean <- tm_map(dd_clean, stripWhitespace) #strip whitespace so that we can compare the words later
dd_clean <- tm_map(dd_clean, content_transformer(tolower)) #switch to lower-case
#dd_clean <- tm_map(dd_clean, removeWords, c("dunkin+donuts")) #remove the words that contain the searched word

dom_clean <- tm_map(dom_corpus, removePunctuation) #remove punctuation
dom_clean <- tm_map(dom_clean, removeNumbers) #remove numbers
dom_clean <- tm_map(dom_clean, removeWords,stopwords('en')) #remove stopwords (english)
dom_clean <- tm_map(dom_clean, stripWhitespace) #strip whitespace so that we can compare the words later
dom_clean <- tm_map(dom_clean, content_transformer(tolower)) #switch to lower-case
#dom_clean <- tm_map(dom_clean, removeWords, c("dominos")) #remove the words that contain the searched word

ph_clean <- tm_map(ph_corpus, removePunctuation) #remove punctuation
ph_clean <- tm_map(ph_clean, removeNumbers) #remove numbers
ph_clean <- tm_map(ph_clean, removeWords,stopwords('en')) #remove stopwords (english)
ph_clean <- tm_map(ph_clean, stripWhitespace) #strip whitespace so that we can compare the words later
ph_clean <- tm_map(ph_clean, content_transformer(tolower)) #switch to lower-case
#ph_clean <- tm_map(ph_clean, removeWords, c("pizza+hut")) #remove the words that contain the searched word

wen_clean <- tm_map(wen_corpus, removePunctuation) #remove punctuation
wen_clean <- tm_map(wen_clean, removeNumbers) #remove numbers
wen_clean <- tm_map(wen_clean, removeWords,stopwords('en')) #remove stopwords (english)
wen_clean <- tm_map(wen_clean, stripWhitespace) #strip whitespace so that we can compare the words later
wen_clean <- tm_map(wen_clean, content_transformer(tolower)) #switch to lower-case
#wen_clean <- tm_map(wen_clean, removeWords, c("wendys")) #remove the words that contain the searched word
#Finish Cleaning Corpus--------------------------------

#-Returning the corpus back into a dataframe to be processed---------------
kfc_cleaned_dataframe <- data.frame(text=sapply(kfc_clean, identity), 
                                    stringsAsFactors=F)

mcD_cleaned_dataframe <- data.frame(text=sapply(mcD_clean, identity), 
                                    stringsAsFactors=F)

bk_cleaned_dataframe <- data.frame(text=sapply(bk_clean, identity), 
                                   stringsAsFactors=F)

dd_cleaned_dataframe <- data.frame(text=sapply(dd_clean, identity), 
                                   stringsAsFactors=F)

dom_cleaned_dataframe <- data.frame(text=sapply(dom_clean, identity), 
                                    stringsAsFactors=F)

ph_cleaned_dataframe <- data.frame(text=sapply(ph_clean, identity), 
                                   stringsAsFactors=F)

wen_cleaned_dataframe <- data.frame(text=sapply(wen_clean, identity), 
                                    stringsAsFactors=F)
#-End ofeturning the corpus back into a dataframe to be processed--------------- 

#Step 2 [Load sentiment word list]

#-Loading a lexicon (positive/negative word list)
getwd() #print working directory to know where the R file is so that we can place the lexicon in the same folder
#Load positive lexicon
enPositiveWords <- scan('enPositiveWords.txt',what='character',comment.char=';') #loads all english positive words (ignores comment with char ';')
enNegativeWords <- scan('enNegativeWords.txt',what='character',comment.char=';') #loads all english positive words (ignores comment with char ';')



#-Creating a function called "score.sentiment" to score sentiments and do extra cleaning----------------
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  
  
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    #use gsub (pattern matching and replacement) to do regex
    sentence = gsub('[[:punct:]]', '', sentence) #regex punctuations
    sentence = gsub('[[:cntrl:]]', '', sentence) #regex control characters
    sentence = gsub('\\d+', '', sentence) #regex numbers 
    
    #convert the tweet
    sentence = tolower(sentence) #convert to lower case
    
    #split tweet word by word ["hello i am james" => "hello" "i" "am" "james"]
    word.list = str_split(sentence, '\\s+') #split string by whitespace
    words = unlist(word.list) #make a character vector
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words) #checks words one by one and check for positive words from lexicon
    neg.matches = match(words, neg.words) #checks words one by one and check for negative words from lexicon
    # match returns the position of the matched term or NA if the word is not in the lexicon
    
    
    # finding the true/false of each word, if the word is in the lexicon it will return true
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    #we can sum the true/false because true =1 and false =0, and so it will return the sentiment score
    score = sum(pos.matches) - sum(neg.matches) #((sum of all positive matches) - (sum of all negative matches))
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}
#---END OF sentiment score function------------------------------------

#Step 3 [Score sentiment for each tweet and put it into a dataframe]
#Score sentiment using the function above and then put it into a score variable
#After that add "brand" column and "code" column and fill it with the appropriate brand and restaurant code
kfc_scores = score.sentiment(kfc_cleaned_dataframe$text,enPositiveWords,enNegativeWords, .progress="text") #progress bar
kfc_scores$brand = "KentuckyFriedChicken"
kfc_scores$code = "kfc"

mcD_scores = score.sentiment(mcD_cleaned_dataframe$text,enPositiveWords,enNegativeWords, .progress="text") #progress bar
mcD_scores$brand = "McDonald's"
mcD_scores$code = "mcD"

bk_scores = score.sentiment(bk_cleaned_dataframe$text,enPositiveWords,enNegativeWords, .progress="text") #progress bar
bk_scores$brand = "Burger King"
bk_scores$code = "bk"

dd_scores = score.sentiment(dd_cleaned_dataframe$text,enPositiveWords,enNegativeWords, .progress="text") #progress bar
dd_scores$brand = "DunkinDonuts"
dd_scores$code = "dd"

dom_scores = score.sentiment(dom_cleaned_dataframe$text,enPositiveWords,enNegativeWords, .progress="text") #progress bar
dom_scores$brand = "Dominos"
dom_scores$code = "dom"

ph_scores = score.sentiment(ph_cleaned_dataframe$text,enPositiveWords,enNegativeWords, .progress="text") #progress bar
ph_scores$brand = "PizzaHut"
ph_scores$code = "ph"

wen_scores = score.sentiment(wen_cleaned_dataframe$text,enPositiveWords,enNegativeWords, .progress="text") #progress bar
wen_scores$brand = "Wendy's"
wen_scores$code = "wen"
#END OF scoring and adding columns---------------------------

#[FOR TROUBLESHOOTING]--
#[END OF TROUBLESHOOTING]--------------


#STEP 4 [Drawing & Combining Graphs]
#Bind all scores into one variable (so that we can draw the graph)
compiled_scores = rbind(kfc_scores,mcD_scores,bk_scores,dd_scores,dom_scores,ph_scores,wen_scores) #bind scores into a variable
#used the binded scores and make it into histograms-------------------
ggplot(data=compiled_scores) +
  geom_histogram(mapping=aes(x=score, fill=brand),binwidth=1) + #geom_bar
  facet_grid(brand~.) + #make separate plot for each brand
  theme_bw() + scale_colour_brewer() #add colors
#end of using the binded scores and making it into histograms--------------------

#unused code (for troubleshooting)-----
#hist(kfc_scores$score) #make histogram
#qplot(ph_scores$score, binwidth=0.5)
#mean(kfc_scores$score)
#wordcloud(kfc_scoresNew$text,min.freq =4, random.order = F, scale = c(3,0.5), colors=rainbow(3))
#end of unused code for troubleshooting--------



#Step 6 Calculating total scores
#make a bigPositive and bigNegative number (numbers above 1 and under -1 because 0 doesnt count)
compiled_scores$bigPositive = as.numeric(compiled_scores$score >= 1)
compiled_scores$bigNegative = as.numeric(compiled_scores$score <= -1)

#use ratio of bigpositive to bigNegative as overall sentiment score for each brand
sentimentDataFrame = ddply(compiled_scores, c('brand','code'),summarise,
                           totalpositive=sum(bigPositive),totalNegative = sum(bigNegative))
sentimentDataFrame$totalCount = sentimentDataFrame$totalpositive+sentimentDataFrame$totalNegative
sentimentDataFrame$score = round(100*sentimentDataFrame$totalpositive/sentimentDataFrame$totalCount)



#Step 7 Comparing with ACSI (American Customer Sastisfaction Index)
#Loading the Table for benchmarking from the URL
benchmark_url = "http://www.theacsi.org/index.php?option=com_content&view=article&id=149&catid=&Itemid=214&i=Limited-Service+Restaurants"
#Reading a table in HTML and then converting it into a dataframe
benchmark_data_frame = readHTMLTable(benchmark_url,header=T, which=1, stringAsFactors=F)
#only keep column #1 (name) and #25 (year 2017 benchmark scores) and discard the rest
benchmark_data_frame=benchmark_data_frame[,c(1,25)]

#test print
head(benchmark_data_frame,1)

#changing unclear column names into "brand" and "score"  
colnames(benchmark_data_frame) = c('brand','score') #change col1 name to brand and col2 name to score

#Deleting unneeded rows (restaurants) that will not be analysed
benchmark_data_frame <- benchmark_data_frame[-c(1,2,3,4,5,6,8,10,13,16,18),]  #delete rows not needed for benchmarking

#Giving each restaurant a code
benchmark_data_frame$code = c("dd",NA,"kfc","dom","bk","wen","ph","mcD")

#Merging sentiment scores and the benchmark scores in a single dataframe/table
compare_data_frame = merge(sentimentDataFrame, benchmark_data_frame, by="code",suffixes=c(".tweets",".benchmark"))

#making a plot that contains all of the combined scores into a linear regression 
ggplot( compare_data_frame) +
  geom_point(aes(x=score.tweets,
                 y=score.benchmark,
                 color=brand.tweets),size =5) + 
  
  geom_smooth( aes(x=score.tweets,
                   y=score.benchmark,group=1),se=F,
               method="lm")+
  theme_bw()


##WORDCLOUD FUNCTIONS##--------------
#wordcloud kfc
kfc_wordCloud <- tm_map(kfc_clean, removeWords, c("kfc")) #remove the words that contain the searched word
wordcloud(kfc_wordCloud,min.freq =4, random.order = F, scale = c(3,0.5), colors=rainbow(10))

#wordcloud mcD
mcD_wordCloud <- tm_map(mcD_clean, removeWords, c("mcdonalds")) #remove the words that contain the searched word
wordcloud(mcD_wordCloud,min.freq =4, random.order = F, scale = c(3,0.5), colors=rainbow(10))

#wordcloud bk
bk_wordCloud <- tm_map(bk_clean, removeWords, c("burger+king","burger","king")) #remove the words that contain the searched word
wordcloud(bk_wordCloud,min.freq =4, random.order = F, scale = c(3,0.5), colors=rainbow(10))

#wordcloud dd
dd_wordCloud <- tm_map(dd_clean, removeWords, c("dunkin+donuts","dunkin")) #remove the words that contain the searched word
wordcloud(dd_wordCloud,min.freq =4, random.order = F, scale = c(3,0.5), colors=rainbow(10))

#wordcloud dom
dom_wordCloud <- tm_map(dom_clean, removeWords, c("dominos","pizza")) #remove the words that contain the searched word
wordcloud(dom_wordCloud,min.freq =4, random.order = F, scale = c(3,0.5), colors=rainbow(10))

#wordcloud ph
ph_wordCloud <- tm_map(ph_clean, removeWords, c("pizza+hut")) #remove the words that contain the searched word
wordcloud(ph_wordCloud,min.freq =4, random.order = F, scale = c(3,0.5), colors=rainbow(10))

#wordcloud wen
wen_wordCloud <- tm_map(wen_clean, removeWords, c("wendys")) #remove the words that contain the searched word
wordcloud(wen_wordCloud,min.freq =4, random.order = F, scale = c(3,0.5), colors=rainbow(10))

#END OF WORDCLOUD FUNCTIONS------------------------

#Note buat Dean - 
#STEP 1: ini awalnya function delcaration
#STEP 2: terus selanjutnya baru setup variablenya
#STEP 3: nah baru dipaling bawah itu function buat grafiknya. langsung dipake aja function paling bawahnya dan itu nanti langsung bikin grafik

#STEP 1 FORECASTING:
#-START OF FUNCTION DECLARATIONS---------------------------
#---Declare predict_score() function---------
predict_score = function(x, y){
  n = length(x)
  
  #to find mean from x
  x_mean = mean(x)
  
  #to find mean from y
  y_mean = mean(y)
  
  #to find mean^2 from x
  x_mean_2 = x_mean^2
  
  #to find mean from x*y
  xy_mean = 0
  
  for(i in 1:n){
    xy_mean = xy_mean + (x[i] * y[i])
  }
  
  xy_mean = xy_mean / n
  
  #to find mean from x^2
  x2_mean = 0
  
  for(i in 1:n){
    x2_mean = (x2_mean + (x[i])^2)
  }
  
  x2_mean = x2_mean / n
  
  #to find m
  m = (xy_mean - x_mean*y_mean)/(x2_mean - x_mean_2)
  
  #to find b
  b = y_mean - m*x_mean
  
  #prediction
  prediction_2019 = m*2019 + b
  
  print(b)
  print(prediction_2019)
  
  year <- c(x, 2019)
  score <- c(y, prediction_2019)
  predicted_data <- data.frame(year,score)
  return(predicted_data) 
}
#-END OF Declare graph_forecast() function--

#---Declare graph_forecast() function---------
graph_forecast <- function(x){
  ggplot(x) +
    labs(title = "Score Forecast")  +
    xlab("Year") + ylab("Score")+
    geom_point(aes(x=year,
                   y=score,
                   color=year),size =5) + 
    
    geom_smooth( aes(x=year,
                     y=score,group=1),se=F,
                 method="lm") + 
    theme_bw()
}
#-END OF Declare graph_forecast() function--
#-END OF FUNCTION DECLARATIONS---------------------------


#STEP 2:      
#---Setting up the variables for forecasting---------------------
#on this one we will be getting ACSI's score from 2015-2017 and adding our own sentiment score for 2018 year

#Get ACSI Scores Table and keep only scores 2015-2017
acsiYearsScore = readHTMLTable(benchmark_url,header=T, which=1, stringAsFactors=F) #get acsii chart
acsiYearsScore=acsiYearsScore[,c(1,23,24,25)] #keep only col1,23,24,25 -- keeps name,and scores from 15,16,17

#create the variable to place years
yearsWithScores = c(2015,2016,2017,2018) #years with scores available (ACSI + sentiment analysis score)

#Get and put 2015,2016,2017,2018 scores into a numeric array
#as.numeric and as.character is used because the number that is grabbed is a "factor" class and so has to be converted back into a number
kfc_collected_scores= c(as.numeric(as.character(acsiYearsScore$"15"[11])),as.numeric(as.character(acsiYearsScore$"16"[11])),as.numeric(as.character(acsiYearsScore$"17"[11])),compare_data_frame$score.tweets[4])
mcD_collected_scores= c(as.numeric(as.character(acsiYearsScore$"15"[19])),as.numeric(as.character(acsiYearsScore$"16"[19])),as.numeric(as.character(acsiYearsScore$"17"[19])),compare_data_frame$score.tweets[5])
bk_collected_scores= c(as.numeric(as.character(acsiYearsScore$"15"[14])),as.numeric(as.character(acsiYearsScore$"16"[14])),as.numeric(as.character(acsiYearsScore$"17"[14])),compare_data_frame$score.tweets[1])
dd_collected_scores= c(as.numeric(as.character(acsiYearsScore$"15"[7])),as.numeric(as.character(acsiYearsScore$"16"[7])),as.numeric(as.character(acsiYearsScore$"17"[7])),compare_data_frame$score.tweets[2])
dom_collected_scores= c(as.numeric(as.character(acsiYearsScore$"15"[12])),as.numeric(as.character(acsiYearsScore$"16"[14])),as.numeric(as.character(acsiYearsScore$"17"[12])),compare_data_frame$score.tweets[3])
ph_collected_scores= c(as.numeric(as.character(acsiYearsScore$"15"[17])),as.numeric(as.character(acsiYearsScore$"16"[17])),as.numeric(as.character(acsiYearsScore$"17"[17])),compare_data_frame$score.tweets[6])
wen_collected_scores= c(as.numeric(as.character(acsiYearsScore$"15"[15])),as.numeric(as.character(acsiYearsScore$"16"[15])),as.numeric(as.character(acsiYearsScore$"17"[15])),compare_data_frame$score.tweets[7])
#---END OF MAKING VARIABLES

#Use predict_score() function to get a table with predicted results using linear regression
kfc_forecast_table <- predict_score(yearsWithScores, kfc_collected_scores)
mcD_forecast_table <- predict_score(yearsWithScores, mcD_collected_scores)
bk_forecast_table <- predict_score(yearsWithScores, bk_collected_scores)
dd_forecast_table <- predict_score(yearsWithScores, dd_collected_scores)
dom_forecast_table <- predict_score(yearsWithScores, dom_collected_scores)
ph_forecast_table <- predict_score(yearsWithScores, ph_collected_scores)
wen_forecast_table <- predict_score(yearsWithScores, wen_collected_scores)
#-END OF Setting up the variables for forecasting---------------------


#STEP 3:      
#--GRAPHING PART!!---
#PICK ONE BY ONE TO PUT INTO SHINY
#plot graph for kfc
graph_forecast(kfc_forecast_table)
#plot graph for mcd
graph_forecast(mcD_forecast_table)
#plot graph for bk
graph_forecast(bk_forecast_table)
#plot graph for dunkin
graph_forecast(dd_forecast_table)
#plot graph for dominos
graph_forecast(dom_forecast_table)
#plot graph for pizzahut
graph_forecast(ph_forecast_table)
#plot graph for wendys
graph_forecast(wen_forecast_table)
#-END OF GRAPHING PART!--

#--GRAPH CHART FROM 2015 to 2018 --------------------------------
#--Declare graph_forecastBefore() function to make graph for (2015-2018)--------------    
graph_forecastBefore <- function(yearsWithScores, restaurantCollectedScores){
  ggplot() +
    labs(title = "Score Forecast")  +
    xlab("Year") + ylab("Score")+
    geom_point(aes(x=yearsWithScores,
                   y=restaurantCollectedScores,
                   color=yearsWithScores),size =5) + 
    
    geom_smooth( aes(x=yearsWithScores,
                     y=restaurantCollectedScores,group=1),se=F,
                 method="lm") + 
    theme_bw()
}
#---END OF graph_forecastBefore() function delcaration ----------------------

library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  # App title ----
  titlePanel("Fast Food Sentiment Analysis with Twitter"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      radioButtons(
        "rest",
        "Restaurant :",
        c(
          "None selected" = "",
          "KFC (Yum! Brands)" = "kfc",
          "McDonalds" = "mcD",
          "Burger King" = "bk",
          "Dunkin' Donuts" = "dd",
          "Domino's" = "dom",
          "Pizza Hut (Yum! Brands)" = "ph",
          "Wendy's" = "wen"
        )
        
      ),
      br(),
      actionButton("viewHist", h4("View Histogram", align = "center")),
      br(),
      br(),
      actionButton("bar", h4("View Bar Chart" , align = "center")),
      br(),
      br(),
      actionButton("linear", h4("View Linear Regression" , align = "center")),
      br(),
      br(),
      actionButton("word", h4("View Word Cloud" , align = "center"))
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      plotOutput("Hist", outputId = )
    )
  )
)

server <- function(input, output, session) {
  
  observeEvent(input$viewHist, {
    output$Hist <- renderPlot({
      ggplot(data = compiled_scores) +
        geom_histogram(mapping = aes(x = score, fill = brand),
                       binwidth = 1) + #geom_bar
        facet_grid(brand ~ .) + #make separate plot for each brand
        theme_bw() + scale_colour_brewer() #add colors
    })
  })
  
  observeEvent(input$word, {
    output$Hist <- renderPlot({
      word <- switch(
        input$rest,
        kfc = wordcloud(
          kfc_wordCloud,
          min.freq = 4,
          random.order = F,
          scale = c(3, 0.5),
          colors = rainbow(10)
        ),
        mcD = wordcloud(
          mcD_wordCloud,
          min.freq = 4,
          random.order = F,
          scale = c(3, 0.5),
          colors = rainbow(10)
        ),
        bk = wordcloud(
          bk_wordCloud,
          min.freq = 4,
          random.order = F,
          scale = c(3, 0.5),
          colors = rainbow(10)
        ),
        dd = wordcloud(
          dd_wordCloud,
          min.freq = 4,
          random.order = F,
          scale = c(3, 0.5),
          colors = rainbow(10)
        ),
        dom = wordcloud(
          dom_wordCloud,
          min.freq = 4,
          random.order = F,
          scale = c(3, 0.5),
          colors = rainbow(10)
        ),
        ph = wordcloud(
          ph_wordCloud,
          min.freq = 4,
          random.order = F,
          scale = c(3, 0.5),
          colors = rainbow(10)
        ),
        wen = wordcloud(
          wen_wordCloud,
          min.freq = 4,
          random.order = F,
          scale = c(3, 0.5),
          colors = rainbow(10)
        )
        
      )
      
    })
  })
  
  observeEvent(input$bar, {
    output$Hist <- renderPlot({
      barplot(
        compare_data_frame$score.tweets,
        main = "Sentiment Score",
        names.arg = (compare_data_frame$brand.tweets),
        xlab = "Fast Food Restaurants",
        ylab = "Satisfaction Index"
      )
    })
  })
  
  observeEvent(input$linear, {
    output$Hist <- renderPlot({
      if(input$rest=="kfc")
      {graph_forecast(kfc_forecast_table)}
      else if(input$rest=="mcD")
      {graph_forecast(mcD_forecast_table)}
      else if(input$rest=="bk")
      {graph_forecast(bk_forecast_table)}
      else if(input$rest=="dd")
      {graph_forecast(dd_forecast_table)}
      else if(input$rest=="dom")
      {graph_forecast(dom_forecast_table)}
      else if(input$rest=="ph")
      {graph_forecast(ph_forecast_table)}
      else if(input$rest=="wen")
      {graph_forecast(wen_forecast_table)}
    })
  })
  
}





shinyApp(ui, server)
