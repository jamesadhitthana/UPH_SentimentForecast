# UPH_SentimentForecast
One Paragraph of project description goes here

## Getting Started

To be able to run this Shiny app, you will need to have the following prerequesites and have follow the instructions below.

### Prerequisites

Libraries needed on R:
- twitteR
- shiny
- RCurl
- wordcloud
- tm
- tmap
- plyr
- stringr
- xml
- ggplot2


### Running the application

Make sure you have all the prerequisites installed and you are connected to the internet.
Then copy the following into R console to run the app:

```
shiny::runGitHub("jamesadhitthana/UPH_SentimentForecast")
```

If all works well this is what will happen
//start tutoraial

This is the main view when our shiny program is first run. 

![tutorial1](https://github.com/jamesadhitthana/UPH_SentimentForecast)

User can see information related to the brand that will be seen by pressing the radio button available. After choosing a brand, the user can select the type of information that will be displayed by pressing the existing action button. There are 4 graphs that can be displayed: Histogram, Bar Chart, Linear Regression, Word Cloud. Specially for the Histogram and Bar Chart will show the graph of all existing brands in order to show the comparison.

![tutorial1](https://github.com/jamesadhitthana/UPH_SentimentForecast)




//end tutorail
//INSERT SCREENSHOT HERE//


## Our Goal

## Explanation

blah

### searchTwitter

To grab and download the tweets from twitter the ‘twitteR’ library is used. Before we can get started the consumer_key, consumer_secret,acces_token, and access_secret has to be activated first before we can access the twitter API via the twitteR library.
```
setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_secret) #loads the keys
```
To actually search for the tweets, the searchTwitter() function is used and the data is put into the appropriate variables. For example for the kfc_tweets variable, the searchTwitter() function is used to search for the keyword: 'kfc'. Then "-filter:retweets" is used to prevent retweets from being downloaded. The "lang=en" parameter is used to search for only English tweets, and then "n=250" sets the number of tweets to fetch which is set to 250 tweets. The resultType is set to recent because we want the latest tweets. Last is the geocode which is set to the latitude, longitude, and radius that covers the map of USA so that we only get tweets from America.
```
kfc_tweet <- searchTwitter('kfc -filter:retweets', lang="en",n=250,resultType="recent", geocode='37.0902,-95.7129,1500mi') #download kfc tweets
```

### Preparing the Tweets for Processing

After recieving the tweets in the “restaurant_tweet” variable (ex: kfc_tweet variable), it is converted into the character vector by extracting the text from tweet variable using the getText() function and then putting it into its appropriate variable. This is done so that the tweets can be converted into a corpus.

```
kfc_text <- sapply(kfc_tweet,function(x) x$getText()) 
#creates a function that gets the text from the each tweet in the variable (looping) and places it in the variable
```

After it is converted into a character vector of name “restaurant_text” (ex: kfc_text), it is converted into a corpus and placed into a variable called “restaurant_corpus” (ex:kfc_corpus). It is converted into a corpus so that the tweets can be proccessed word by word.

```
kfc_corpus <- Corpus(VectorSource(kfc_text))
#converts the previous character vector into a corpus and put it in kfc_corpus
```

### Cleaning the Tweets

Since we do not want to process the unimportant parts of a tweet such as punctuations (marks, such as period, comma, parenthesis, etc.), numbers, stop words (the, a, to, you etc.), and whitespaces we have to clean up the corpus for each variable. This is done by using the tm_map() function from the tm and tmap libraries. This variable takes the corpus as the first parameter and the attributes to clean up in the second parameter. Below is the example for KFC’s variables.

```
kfc_clean <- tm_map(kfc_corpus, removePunctuation) #get corpus, remove punctuation, then put into a new variable called kfc_clean so that it doesnt affect the original corpus
kfc_clean <- tm_map(kfc_clean, removeNumbers) #remove numbers
kfc_clean <- tm_map(kfc_clean, removeWords,stopwords('en')) #remove stopwords (english)
kfc_clean <- tm_map(kfc_clean, stripWhitespace) #strip whitespace so that we can compare the words later
```

After cleaning it up, the corpus is converted into lower case so that it can be processed in the sentiment analysis process.

```
kfc_clean <- tm_map(kfc_clean, content_transformer(tolower)) #switch to lower-case
```

After it is cleaned up, using the data.frame() function and the plyr library, the cleaned up and lower case corpus is returned back into a dataframe called “restaurant_cleaned_dataframe” (ex: kfc_cleaned_dataframe). 

```
kfc_cleaned_dataframe <- data.frame(text=sapply(kfc_clean, identity), stringsAsFactors=F)
#converting back into a data.frame and then putting it into the appropriate variable name, it also makes sure that strings arent made into a factor type class by using stringsAsFactors=F
```
### Sentiment Analysis

To calculate customer satisfaction in 2018, we used a sentiment analysis. Sentiment analysis can be done using previously obtained dataframe from Twitter. First of all it needs to be given information about positive and negative word (load lexicon).

```
enPositiveWords <- scan('enPositiveWords.txt',what='character',comment.char=';') #loads all english positive words (ignores comment with char ';')
enNegativeWords <- scan('enNegativeWords.txt',what='character',comment.char=';') #loads all english positive words (ignores comment with char ';')
```

Then put into a function called sentiment.score() that serves to calculate the sentiment score of each brand by searching the number of positive and negative words from each related tweet that also performs the cleaning of some unnecessary characters. Essentially what it does is that it takes the tweets from the previous variable and matches it with the positive and the negative lexicon and then if it matches it either adds a positive score or adds a negative score. For example if a tweet contains a word “terrible” it will add -1 to the total score. On the other hand if a tweet contains a word “awesome” it will add +1 to the total score. The function sentiment.score() is inspired by Jeffrey Breen’s algorithm which is credited on the bottom of this page. 


Scores can be calculated using the following basic formula:

```
score = sum(pos.matches) - sum(neg.matches) 
#((sum of all positive matches) - (sum of all negative matches))
```

The scores obtained will be included in a new data frame called “restaurant_scores” (ex: kfc_scores). Then the brand and the restaurant code is added to make graph making easier.

```
kfc_scores = score.sentiment(kfc_cleaned_dataframe$text,enPositiveWords,enNegativeWords, .progress="text") #progress bar
kfc_scores$brand = "KentuckyFriedChicken"
kfc_scores$code = "kfc"
```

After all of that, all of the scores from all the restaurants are compiled into a variable named “compiled_scores” by using the rbind() function. This will create a table with the scores for each tweet.

```
compiled_scores = rbind(kfc_scores,mcD_scores,bk_scores,sb_scores,dom_scores,ph_scores,wen_scores) #bind scores into a variable
```

![screenshotTableSentiment](https://github.com/jamesadhitthana/UPH_SentimentForecast)

With all the scores combined, the total sentiment score will now be calculated. But first we have to extract the positive and negative numbers first which is done by this function.






## Built With
* [R](https://www.r-project.org/) - R Programming Language
* [RStudio](https://www.rstudio.com/) - RStudio

## Authors

* **James Adhitthana** - [jamesadhitthana](https://github.com/jamesadhitthana)
* **Christopher Yefta** - [ChrisYef](https://github.com/ChrisYef)
* **Deananda Irwansyah** - [hikariyoru](https://github.com/hikariyoru)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments
* Customer satisfaction index of (2015-2017) by [ACSI - American Customer Satisfaction Index](http://www.theacsi.org/index.php?option=com_content&view=article&id=149&catid=&Itemid=214&i=Limited-Service+Restaurants)
* Positive and negative word list by [Minqing Hu and Bing Liu](https://www.cs.uic.edu/~liub/FBS/opinion-lexicon-English.rar)
* score.sentiment() function by [Jeffrey Breen](https://github.com/jeffreybreen/twitter-sentiment-analysis-tutorial-201107/blob/master/R/sentiment.R)
