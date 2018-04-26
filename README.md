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
bla bla lanjut lagi, ini blm selsai
### next explanation/technique


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
