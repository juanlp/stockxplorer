library(shiny)
library(RCurl)
library(XML)
if(!file.exists('../sit'))
  shiny:::download('https://github.com/systematicinvestor/SIT/raw/master/sit.lite.gz', '../sit', mode = 'wb', quiet = TRUE)
con = gzcon(file('../sit', 'rb'))
source(con)
close(con)
# source("getnews.r")
