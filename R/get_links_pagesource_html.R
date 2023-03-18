#' Automatically collect specific links provided on a website.
#'
#' A function to automatically collect specific links on a website, e.g. to public speeches on official websites.
#'
#' @param website The target website with the links to the desired content.
#'
#' @param start_website The main webpage of the case of interest.
#'
#' @param page_ex The page counter in the link of the main website which - most likely - refers to the links with content on several pages.
#' Typically an expression such as "page/30" at the end of the link.
#'
#' @param links_xpath The general xpath node which contains the links of interest, often similar to "//h2//a".
#'
#' @param first The page counter on the first page (typically a 1, occasionally also a 0 or other).
#'
#' @param last The page counter on the last page of the target website which contains the links of interest.
#'
#' @param time_out By default 1 sec, simulates human action and prevents overloading servers (too many requests in too little time)
#'
#'
#' @return A character vector with all links ("all_links). Please NOTE that this collection of links might
#' need to be further filtered (depending on how well the links_xpath was designed) and/or completed, e.g. with str_c(start_website, all_links),
#' since often, the links miss the first part, e.g. the main address (start_website) of the homepage.
#'
#' @import RSelenium
#' @import rvest
#' @importFrom xml2 read_html xml_attrs
#' @import stringr
#' @import dplyr
#'
#' @export
#'
#' @examples
#' #Don't run
#' #Get the links provided on a website
#' #get_links()
#'
get_links <- function(website, start_website, page_ex, links_xpath, first, last, time_out = 1){
rD <- rsDriver(port=4567L, browser = "firefox") # runs a firefox (or chrome etc.) browser, wait for necessary files to download
remDr <- rD$client
# navigate to main website
remDr$navigate(website)
Sys.sleep(time_out)
# all htmls (page_sources) should be collected in a list
page_source <- list()
# write loop to get page_sources of all pages in a large list (check how many pages)
for (i in 1:last){
  page <- paste0("", seq.int(first,last), "")
  website_page <- str_c(website, page_ex)
  path <- str_c(website_page, page)
  remDr$navigate(path[i])
  page_source[i]<-remDr$getPageSource()
  remDr$navigate(start_website)
  Sys.sleep(time_out)
}
remDr$close()
rD$server$stop()
rm(rD)
gc()
# use sys.sleep if website is loading very slowly
# another loop to save in a list all links to speeches contained in the already scraped page_sources
link <- list()
all_links <- list()

for (i in 1:length(page_source)){
  #parse it to get links
  link[[i]] <- xml2::read_html(page_source[[i]]) %>% rvest::html_nodes(xpath = links_xpath) # links are typically stored in this node path
  link[[i]] <- bind_rows(lapply(xml2::xml_attrs(link[[i]]), function(x) data.frame(as.list(x), stringsAsFactors=FALSE)))
  all_links[[i]] <- link[[i]]$href
}

# erase dublicates
all_links <- unlist(all_links)
all_links <- unique(all_links)
return(all_links)
{

}
}

#' Automatically collect the page sources of links.
#'
#' A function to automatically collect the page sources of links (typically done before the content of the links is downloaded).
#'
#' @param all_links A character vector which contains all links with the desired content to be downloaded
#'
#' @param time_out By default 1 sec, simulates human action and prevents overloading servers (too many requests in too little time)
#'
#'
#' @return A character vector with all page sources.
#'
#' @import RSelenium
#'
#' @export
#'
#' @examples
#' #Don't run
#' #Get the page sources of links provided on a website
#' #get_pagesource()
#'
get_pagesource <- function(all_links, time_out = 1)
{
  rD <- rsDriver(port=4567L, browser = "firefox") # runs a firefox (or chrome etc.) browser, wait for necessary files to download
  remDr <- rD$client
source <- list()
# save page source of each link in a list
for(i in 1:length(all_links)){
  remDr$navigate(all_links[i])
  Sys.sleep(time_out)
  source[i]<-remDr$getPageSource()
}
remDr$close()
rD$server$stop()
rm(rD)
gc()
# again, we use sys.sleep since website is very slow
# unlist all page sources
pagesource <- unlist(source)
{
  return(pagesource)
}
}

#' Automatically download content of websites.
#'
#' A function to automatically download content of websites via their page source and save them as html in a folder.
#'
#' @param pagesource A character vector which contains the page sources of all websites.
#'
#' @param case The name of the case, e.g. a country, make it a unique case identifier.
#'
#'
#' @return A folder with all htmls scraped from the target website.
#'
#' @import RSelenium
#' @import stringr
#'
#' @export
#'
#' @examples
#' #Don't run
#' #Get the contents of links provided on a website
#' #get_html()
#'
get_html <- function(pagesource, case){
# create folder
dir.create(case)
# save them as html
for(i in 1:length(pagesource)){
  write(pagesource[i], str_c(str_c(case, "/"), i, ".html"))
}
}
