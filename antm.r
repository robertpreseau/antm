## STANDARD SETUP #########################################################################

#Create list of required packages
list.of.packages <- c('purrr', 'dplyr', 'rvest', 'stringr', 'ggplot2', 'gganimate', 'gifski')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

#Install missing packages
if(length(new.packages)) install.packages(new.packages)

#Load packages
library('dplyr')
library('purrr')
library('rvest')
library('stringr')
library('ggplot2')
library('gganimate')
library('gifski')


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
#extract the HTML element we want to retrieve data from
table <- html_table(html_nodes(webpage, xpath='//*[@id="mw-content-text"]/div/table[5]'), fill=TRUE)

#finishing order
finishing_order <- as.data.frame(data.frame(table[1])[-1,3])
finishing_order$week <- 1
finishing_order$callout <- as.numeric(rownames(finishing_order))
names(finishing_order) <- c('contestant', 'week', 'callout')

i <- 4
while (i < 12) {
  finishing_order_tmp <- as.data.frame(data.frame(table[1])[-1,i])
  finishing_order_tmp$week <- i-2
  finishing_order_tmp$callout <- as.numeric(rownames(finishing_order_tmp))
  names(finishing_order_tmp) <- c('contestant', 'week', 'callout')

  finishing_order <- rbind(finishing_order, finishing_order_tmp)
  
  i <- i + 1
}  


finishing_order <- finishing_order %>% filter(contestant != '')

#source cleanup
rm(table, webpage, i, url)



# Plot
p <- finishing_order %>%
  ggplot(aes(x=week, y=callout, group=contestant, color=contestant)) +
  geom_line() +
  theme(legend.position = "none") +
  geom_text(aes(label=contestant),hjust=0, vjust=0) +
  ggtitle("America's Next Top Model - Season 1 Weekly Finishing Order") +
  ylab("Weekly Callout Position")  +
  scale_x_continuous(breaks = unique(finishing_order$week), limits=c(0, 9), expand=expand_scale(mult=c(0,.2), add=c(0, 0))) + 
  scale_y_continuous(trans = "reverse", breaks = unique(finishing_order$callout)) +
  transition_reveal(week)

animate(p, end_pause=30)
