
if (!require(quantmod)) {
  stop("This app requires the quantmod package. To install it, run 'install.packages(\"quantmod\")'.\n")
}

# Download data for a stock if needed, and return the data
require_symbol <- function(symbol, envir = parent.frame()) {
  if (symbol != "^AXJO") {symbol <-paste(symbol,".AX",sep="")}
  if (is.null(envir[[symbol]])) {
    envir[[symbol]] <- getSymbols(symbol, auto.assign = FALSE)
  }
  
  envir[[symbol]]
}

urlx <- function(symbol)
{
  default = "http://www.asx.com.au/asx/research/companyInfo.do?by=asxCode&asxCode="
  if (symbol=="^AXJO") {
    xurl = "http://www.asx.com.au/asx/statistics/indexInfo.do"
  } else
  {
    xurl    = paste(default,symbol,sep="")      
  }
  return(xurl)
}
urly <- function(symbol)
{
  default = "http://au.finance.yahoo.com/q/h?s="
  if (symbol=="^AXJO") {
    xurl = "http://au.finance.yahoo.com/q/h?s=^AXJO"
  } else
  {
    xurl    = paste(default,symbol,".AX",sep="")      
  }
  return(xurl)
}
urla <- function(symbol)
{
  default = "http://tools.afr.com/research-tools/analysis/key-measures.aspx?code="
  if (symbol=="^AXJO") {
    xurl = "http://tools.afr.com/markets-data/overview.aspx"
  } else
  {
    xurl    = paste(default,symbol,sep="")      
  }
  return(xurl)
}

shinyServer(function(input, output) {
  #Get ASX Link
  output$iframe.asx = renderText({paste("<iframe src=\"",urlx(input$symbol),"\" width=\"1280\" height=\"1024\" style=\"position:absolute; top:0px; left:-150px;\"></iframe>",sep="")})
  output$iframe.yho = renderText({paste("<iframe src=\"",urly(input$symbol),"\" width=\"1280\" height=\"1024\" style=\"position:absolute; top:0px; left:-150px;\"></iframe>",sep="")})
  output$iframe.afr = renderText({paste("<iframe src=\"",urla(input$symbol),"\" width=\"1280\" height=\"1024\" style=\"position:absolute; top:0px; left:-120px;\"></iframe>",sep="")})
  
  # Create an environment for storing data
  symbol_env <- new.env()
  
  # Make a chart for a symbol, with the settings from the inputs
  red   = chartTheme(up.col="white",dn.col="red",area="#FFF8DC",bg.col="#EEE8CD")
  white = chartTheme("white")
  black = chartTheme("black")
  count = 0
  make_chart <- function(symbol,TAF) {    
    symbol_data <- require_symbol(symbol, symbol_env)
    if (TAF == "")
    { 
      chartSeries(symbol_data,
                  name      = symbol,
                  type      = input$chart_type,
                  subset    = paste("last", input$time_num, input$time_unit)
      )
      
    }
    else
    {
      chartSeries(symbol_data,
                  name      = symbol,
                  type      = input$chart_type,
                  subset    = paste("last", input$time_num, input$time_unit),
                  TA        = TAF)
    }
    if (input$theme_type=="red") {reChart(theme=red)}
    if (input$theme_type=="white") {reChart(theme=white)}
    if (input$theme_type=="black") {reChart(theme=black)}
  }
  getdata <- function(symbol) {    
    symbol_data <- require_symbol(symbol, symbol_env)
    symbol_data
  }
  TAFK <- function(TA1,TA2,TA3,TA4,TA5,TA6,TA7,TA8) {
    xname = "addVo()"
    count = 360
    if (TA1 == TRUE) {xname ="addBBands()"
                      count = count + 20}
    if (TA2 == TRUE) {xname = paste("addCMO()",xname,sep=";")
                      count = count + 60}
    if (TA3 == TRUE) {xname = paste("addCCI()",xname,sep=";")
                      count = count + 20}
    if (TA4 == TRUE) {xname = paste("addEMA()",xname,sep=";")
                      count = count + 20}
    if (TA5 == TRUE) {xname = paste("addSMA()",xname,sep=";")
                      count = count + 20}
    if (TA6 == TRUE) {xname = paste("addMACD()",xname,sep=";")
                      count = count + 20}
    if (TA7 == TRUE) {xname = paste("addROC()",xname,sep=";")
                      count = count + 20}
    if (TA8 == TRUE) {xname = paste("addRSI()",xname,sep=";")
                      count = count + 20}
    return(c(xname,count))
  }
  reso <- function(TA1,TA2,TA3,TA4,TA5,TA6,TA7,TA8) {
    count = 70
    if (TA1 == TRUE) {count = count + 10}
    if (TA2 == TRUE) {count = count + 10}
    if (TA3 == TRUE) {count = count + 10}
    if (TA4 == TRUE) {count = count + 0}
    if (TA5 == TRUE) {count = count + 0}
    if (TA6 == TRUE) {count = count + 10}
    if (TA7 == TRUE) {count = count + 0}
    if (TA8 == TRUE) {count = count + 10}
    return(count)
  }
  xx <- reactive({as.numeric(TAFK(input$addTA1,input$addTA2,input$addTA3,input$addTA4,input$addTA5,input$addTA6,input$addTA7,input$addTA8)[2])})
  rr <- 90
  output$plot_symbol <- renderPlot({ make_chart(input$symbol,TAFK(input$addTA1,input$addTA2,input$addTA3,input$addTA4,input$addTA5,input$addTA6,input$addTA7,input$addTA8)[1])},height=xx,res=rr)
  #   })
  #output$heightpx <- paste(500+10*count,"px",sep="")
  #output$plot_aord <- renderPlot({ make_chart("^AORD",input$addTA1,input$addTA2,input$addTA3) })
})