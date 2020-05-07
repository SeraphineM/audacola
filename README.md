
An R package to assist with AUtomated DAta COLection and Analysis (audacola). 

### How to use: ###
This package is tailored to collect and analyze public speeches provided on offical websites. NOTE that due to the very different structure of websites, the scraping functions will only work for a certain type of websites (not necessarily limited to official government websites). While this type seems prevalent regarding the structure of offical government websites, there will be offical government websites with other structures for which these functions won't work (future extensions might follow). 

Please make sure to have an up-to-date Firefox browser and the Java JDK installed when using the scraping functions since they involve dynamic webscraping. 

Be aware of copyright-protected work when using the scraping functions (e.g. give credit to the copyright owner or respect further copyright restriction which might apply), take note of terms of use and robots.txt and be mindful of not overloading servers with your requests (the functions in the audacola package include time-outs, for further info on ethical web scraping see here: https://finddatalab.com/ethicalscraping/)

## The audacola R package ##

#### Automated data collection, a "scraping" workflow in several steps: ####
* `get_links`: A function to automatically collect specific links on a website, e.g. to public speeches on official websites.
* `get_pagesource`: A function to automatically collect the page sources of websites, e.g. of all links to public speeches collected with get_links.
* `get_html`: A function to automatically download content from the Internet and save it as html in a separate folder - typically, public speeches provided on offical websites for which the page source was already collected (get_pagesource).
* `get_text`: A function to extract texts, typically speeches, scraped as html files (= the result of having used the functions get_links, get_pagesource, and get_html).
* `get_first`: A helper function to extract one "first" text from an html file to check and set the parameters for using the function get_text.

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


