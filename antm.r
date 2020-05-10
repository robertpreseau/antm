## STANDARD SETUP #########################################################################

#Create list of required packages
list.of.packages <- c('purrr', 'dplyr', 'rvest', 'stringr')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

#Install missing packages
if(length(new.packages)) install.packages(new.packages)

#Load packages
library('dplyr')
library('purrr')
library('rvest')
library('stringr')


#Clear out environment variables
rm(list=ls())

#Set random seed
set.seed(1738)

#Set working directory
setwd('C:\\Users\\Robert Preseau\\OneDrive\\Projects\\antm')

#clear Plots pane
if(!is.null(dev.list())) dev.off() 

## END STANDARD SETUP #########################################################################


##### Start working #####

#Specifying the url for desired website to be scraped
url <- 'https://en.wikipedia.org/wiki/America%27s_Next_Top_Model_(season_1)'

#Reading the HTML code from the website
webpage <- read_html(url)

#Using this tutorial https://www.freecodecamp.org/news/an-introduction-to-web-scraping-using-r-40284110c848/
table <- html_table(html_nodes(webpage, xpath='//*[@id="mw-content-text"]/div/table[3]'))


table[1][,1]



#Pull out useful columns
contestant <- as.character(data.frame(table[1])[,1])
finish <- as.integer(data.frame(table[1])[,6])





#Create dataframe from intermediate columns
results <- data.frame(contestant, finish)


results
