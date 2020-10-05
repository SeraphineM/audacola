#' Extract texts from scraped html files.
#'
#' A function to extract texts, typically speeches,
#' scraped as html files and ideally stored in a folder in your working directory
#' (= the result of using the functions get_links, get_pagesource, and get_html).
#'
#' @param loc_html A character vector which designates the location of the html files to extract, e.g. in a folder called "aze_speech/"
#'
#' @param x_text The xpath of the text (to be found out, for example, by using the "inspect" tool of firefox)
#'
#' @param x_title The xpath of the title of the text
#' (to be found out, for example, by using the "inspect" tool of firefox)
#'
#' @param x_date The xpath of the text's date, if available
#'(to be found out, for example, by using the "inspect" tool of firefox).
#' One might like to use regular expressions and/or the as.Date function
#' to further adjust the format of the date once extracted.
#'
#' @param speaker The name of the speaker (assuming official speeches are extracted from htmls)
#'
#' @param country The name of the country of the speaker
#' (assuming official speeches are extracted from htmls)
#'
#' @param country_id A short country identifier,
#' useful for merging the speech corpus with other datasets during the analysis.
#'
#' @param regime The regime type of the speaker's country
#' (assuming official speeches are extracted from htmls), e.g. autocracy.
#'
#' @param source The webpage from which the htmls were scraped
#' (crucial to always indicate due to copyright reasons!)
#'
#' @return A quanteda corpus consisting of all texts scraped as corpus documents
#' (for quanteda tutorials on text analysis see https://quanteda.io/index.html)
#'
#' @import quanteda
#' @import textcat
#' @import stringr
#' @import dplyr
#' @importFrom XML htmlParse xpathSApply xmlValue
#'
#' @export
#'
#' @examples
#' #Don't run
#' #Extract texts from htmls
#' #get_text()
#'
get_text <- function(loc_html,
                     x_text,
                     x_title,
                     x_date,
                     speaker,
                     country,
                     country_id,
                     regime,
                     source){

  tmp <- readLines(str_c(loc_html, "1.html"))
  tmp <- str_c(tmp, collapse = " ")
  tmp <- XML::htmlParse(tmp)
  speech <- XML::xpathSApply(tmp, x_text, XML::xmlValue)
  speech <- paste(speech, collapse = " ")
  # check for language
  language <- textcat(speech)
  df <- data.frame(speech,language)
  englishonly <- subset(speech, df$language == "english")
  speech <- englishonly
  # define meta data
  title <- XML::xpathSApply(tmp, x_title, XML::xmlValue)
  date <- XML::xpathSApply(tmp, x_date, XML::xmlValue)
  # build a quanteda corpus with meta data
  speech_corpus <- corpus(speech, docnames = "first")
  docvars(speech_corpus, "title") <- title
  docvars(speech_corpus, "date") <- date
  docvars(speech_corpus, "speaker") <- speaker
  docvars(speech_corpus, "country") <- country
  docvars(speech_corpus, "country_id") <- country_id
  docvars(speech_corpus, "regime") <- regime
  docvars(speech_corpus, "source") <- source
  docvars(speech_corpus, "language") <- language

  n <- 1
  for(i in 2:length(list.files(loc_html))){
    tmp <- readLines(str_c(loc_html, i, ".html"))
    tmp <- str_c(tmp, collapse = " ")
    tmp <- XML::htmlParse(tmp)
    speech <- XML::xpathSApply(tmp, x_text, XML::xmlValue)
    speech <- paste(speech, collapse = " ")
    title <- XML::xpathSApply(tmp, x_title, XML::xmlValue)
    date <- XML::xpathSApply(tmp, x_date, XML::xmlValue)
    language <- textcat(speech)
    df <- data.frame(speech,language)
    englishonly <- subset(speech, df$language == "english")
    speech <- englishonly
    if(length(speech) != 0){
      n <- n + 1
      tmp_corpus <- corpus(speech, docnames = i)
      docvars(tmp_corpus, "title") <- title
      docvars(tmp_corpus, "date") <- date
      docvars(tmp_corpus, "speaker") <- speaker
      docvars(tmp_corpus, "country") <- country
      docvars(tmp_corpus, "country_id") <- country_id
      docvars(tmp_corpus, "regime") <- regime
      docvars(tmp_corpus, "source") <- source
      docvars(tmp_corpus, "language") <- language
      speech_corpus <- c(tmp_corpus, speech_corpus)
    }
  }
  return(speech_corpus)
}
#' Extract texts from one "first" scraped html file to check and set paramters for the get_text function.
#'
#' A helper function to extract one "first" text from an html file as preparation and check of using the function get_text
#' (finding the right xpath can be tricky sometimes...)
#'
#' @param loc_html A character vector which designates the location of the html files to extract, e.g. in a folder called "aze_speech/"
#'
#' @param x_text The xpath of the text (to be found out, for example, by using the "inspect" tool of firefox)
#'
#' @param x_title The xpath of the title of the text
#' (to be found out, for example, by using the "inspect" tool of firefox)
#'
#' @param x_date The xpath of the text's date, if available
#'(to be found out, for example, by using the "inspect" tool of firefox).
#' Please NOTE: One might like to use regular expressions and/or the as.Date function
#' to further adjust the format of the date once extracted.
#'
#' @param speaker The name of the speaker (assuming official speeches are extracted from htmls)
#'
#' @param country The name of the country of the speaker
#' (assuming official speeches are extracted from htmls)
#'
#' @param country_id A short country identifier,
#' useful for merging the speech corpus with other datasets during the analysis.
#'
#' @param regime The regime type of the speaker's country
#' (assuming official speeches are extracted from htmls), e.g. autocracy.
#'
#' @param source The webpage from which the htmls were scraped
#' (crucial to always indicate due to copyright reasons!)
#'
#' @return A quanteda corpus consisting of one single "first" text scraped as corpus documents
#' (for quanteda tutorials on text analysis see https://quanteda.io/index.html)
#'
#' @import quanteda
#' @import textcat
#' @import stringr
#' @import dplyr
#' @importFrom XML htmlParse xpathSApply xmlValue
#'
#' @export
#'
#' @examples
#' #Don't run
#' #Extract texts from htmls
#' #get_first()
#'
get_first <- function(loc_html,
                      x_text,
                      x_title,
                      x_date,
                      speaker,
                      country,
                      country_id,
                      regime,
                      source){
  tmp <- readLines(str_c(loc_html, "1.html"))
  tmp <- str_c(tmp, collapse = " ")
  tmp <- XML::htmlParse(tmp)
  speech <- XML::xpathSApply(tmp, x_text, XML::xmlValue)
  speech <- paste(speech, collapse = " ")
  # check for language
  language <- textcat(speech)
  df <- data.frame(speech,language)
  englishonly <- subset(speech, df$language == "english")
  speech <- englishonly
  # define meta data
  title <- XML::xpathSApply(tmp, x_title, XML::xmlValue)
  date <- XML::xpathSApply(tmp, x_date, XML::xmlValue)
  # build a quanteda corpus with meta data
  speech_corpus <- corpus(speech, docname = 1)
  docvars(speech_corpus, "title") <- title
  docvars(speech_corpus, "date") <- date
  docvars(speech_corpus, "speaker") <- speaker
  docvars(speech_corpus, "country") <- country
  docvars(speech_corpus, "country_id") <- country_id
  docvars(speech_corpus, "regime") <- regime
  docvars(speech_corpus, "source") <- source
  docvars(speech_corpus, "language") <- language
  {
    return(speech_corpus)
  }
}
