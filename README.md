
An R package to assist with AUtomated DAta COLection and Analysis (audacola). 

### How to use: ###
This package is tailored to collect and analyze public speeches provided on offical websites. Please note that due to the very different structure of websites, the scraping functions (get_links, get_content) will only work for a certain type of websites (not necessarily limited to official government websites). While this type seems prevalent regarding the structure of offical government websites, there will be offical government websites with other structures for which these functions won't work (future extensions might follow). Please be aware of copyright-protected work when using the functions (e.g. give credit to the copyright owner or respect further copyright restriction which might apply), take note of terms of use and robots.txt and be mindful of not overloading servers with your requests (the functions in the audacola package include time-outs, for further info on ethical web scraping see here: https://finddatalab.com/ethicalscraping/)

## The audacola R package ##

#### Automated data collection: ####
* `get_links`: A function to automatically collect specific links on a website, e.g. to public speeches on official websites.
* `get_content`: A function to automatically download content from the Internet - typically, a public speech provided on offical websites.

#### Automated data analysis: ####
* `tba`: ...more to come.


## Installation ##

```
# Install the development version of the audacola package 
# (since this package is still an ongoing project, 
# keep checking for updates, new functions, etc.!)

# First, you need to have the devtools package installed
install.packages("devtools")
# now, install the audacola package directly from GitHub
devtools::install_github("SeraphineM/audacola")
```


