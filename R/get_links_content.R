#' A function to \emph{automatically collect specific links on a website, e.g. to public speeches on official websites}.
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
#' @param case The name of the case, e.g. a country, make it a unique case identifier.
#'
#' @param n The number of pages on the target website which contains the links of interest.
#'
#' @return A character vector with all links ("all_links)
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
get_links <- function(website, start_website, page_ex, links_xpath, case, n){
rD <- rsDriver(port=4567L, browser = "firefox") # runs a firefox (or chrome etc.) browser, wait for necessary files to download
remDr <- rD$client
# navigate to main website
remDr$navigate(website)
# all htmls (page_sources) should be collected in a list
page_source <- list()
# write loop to get page_sources of all pages in a large list (check how many pages)
for (i in 1:n){
  page <- paste0("", seq(1:n), "")
  website_page <- str_c(website, page_ex)
  path <- sprintf(website_page, page)
  remDr$navigate(path[i])
  page_source[i]<-remDr$getPageSource()
  remDr$navigate(start_website)
  Sys.sleep(3)
}
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
  rD$server$stop()
  remDr$close()
}
}

#' A function to \emph{automatically download content from the Internet} - typically, a link to a public speech provided on offical websites.
#'
#' @param all_links A character vector which contains all links with the desired content to be downloaded
#'
#' @param case The name of the case, e.g. a country, make it a unique case identifier.
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
#' #get_content()
#'
get_content <- function(all_links, case)
{
  rD <- rsDriver(port=4567L, browser = "firefox") # runs a firefox (or chrome etc.) browser, wait for necessary files to download
  remDr <- rD$client
# create folder
dir.create(case)
speeches <- list()
# download speeches
for(i in 1:length(all_links)){
  remDr$navigate(all_links[i])
  Sys.sleep(3)
  speeches[i]<-remDr$getPageSource()
}
# again, we use sys.sleep since website is very slow
# unlist all page sources
speeches <- unlist(speeches)
# save them as html
for(i in 1:length(speeches)){
  write(speeches[i], str_c(str_c(case, "/"), i, ".html"))
}
{
  rD$server$stop()
  remDr$close()
}
}
