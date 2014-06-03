
shinyUI(pageWithSidebar(
  headerPanel(""),
  
  sidebarPanel(
    tags$head(
      tags$style(type="text/css", "label.radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none; }"),
      tags$style(type="text/css", "select { max-width: 200px; }"),
      tags$style(type="text/css", "textarea { max-width: 100px; }"),
      tags$style(type="text/css", ".jslider { max-width: 200px; }"),
      tags$style(type='text/css', ".well { max-width: 250px; }"),
      tags$style(type='text/css', ".span4 { max-width: 260px; }")
    ),
    #wellPanel(
    #p(strong("Underlying Asset")),
    #textInput(inputId="symbol", label = "Source: Yahoo Finance", value = "^AXJO"),#,
    #checkboxInput(inputId = "stock_aord", label = "All Ordinaries", value = TRUE)
    #),
#         createNonReactiveTextInput("symbol", "Australian Share Ticker:", value = "^AXJO", "Research"),
    textInput("symbol", "Symbol:", "^AXJO"),
        submitButton("Submit"),
    br(),
    HTML('i.e. CBA, BHP, WOW, MAH...'),
    br(),
    htmlOutput("status")
  ), #End sidebarPanel
  
  mainPanel(
    tags$head(
      tags$style(type='text/css', ".span8 { width:100%; }")
    ),
    tabsetPanel(
      tabPanel("About",
                               HTML('This application is built with RShiny and HTML5 framework. <br> 
                                     Users can gather information and perform basic technical analysis about a specific <br>
                                     stock which is listed  on the Australian Security Exchange (ASX). More functions will be <br>
                                     included in the near future.'),
                               HTML('Author: Juan Luong <br>'),
                               HTML('Last updated: 2014-06-02')
      ),
      tabPanel("ASX Profile",
               HTML('<div style=" width:100%;height:1024px;overflow:hidden;position:relative;"> '),
               htmlOutput(outputId="iframe.asx"),
               HTML('</div>')
      ),
      tabPanel("AFR Key Notes",
               HTML('<div style=" width:100%; height:1024px;overflow:hidden;position:relative;"> '),
               htmlOutput(outputId="iframe.afr"),
               HTML('</div>')
      ),
      
      tabPanel("Yahoo Headlines",
               HTML('<div style=" width:100%; height:1024px;overflow:hidden;position:relative;"> '),
               htmlOutput(outputId="iframe.yho"),
               HTML('</div>')
      ),
      tabPanel("Technical Analysis", 
               HTML('<details><summary><b><p style="text-align:right">Graph Settings</p></b></summary><table border=0 width="100%"><tr bgcolor="#f5f5f5"><td width=20%>'),
               div(style="width:100%;",
                   sliderInput(inputId = "time_num",
                               label = "Time number",
                               min = 1, max = 12, step = 1, value = 6)
               ), HTML('</td><td width=20px>'), HTML('</td><td width=20%>'),
               selectInput(inputId = "time_unit",
                           label = "Time unit",
                           choices = c("Days" = "days",
                                       "Weeks" = "weeks",
                                       "Months" = "months",
                                       "Years" = "years"),
                           selected = "Months"
               ), HTML('</td><td width=20%>'),
               selectInput(inputId = "chart_type",
                           label = "Chart type",
                           choices = c("Candlestick" = "candlesticks",
                                       "Matchstick" = "matchsticks",
                                       "Bar" = "bars",
                                       "Line" = "line")
               ), HTML('</td><td width=20%>'),
               selectInput(inputId = "theme_type",
                           label = "Theme colour",
                           choices = c("White"   = "white",
                                       "Red" =   "red",
                                       "Black" = "black")
               ),HTML('</td></tr></table></details>'),
               HTML('<details><summary><b><p style="text-align:right">More Technical Indicators</p></b></summary>'),
#                wellPanel(
                 #p(strong("Technical Analysis")),
                 checkboxInput(inputId = "addTA1", label = "BB", value = FALSE
                 ),
                 checkboxInput(inputId = "addTA2", label = "CMO", value = FALSE
                 ),   
                 checkboxInput(inputId = "addTA3", label = "CCI", value = FALSE
                 ),
                 checkboxInput(inputId = "addTA4", label = "EMA", value = TRUE
                 ),
                 checkboxInput(inputId = "addTA5", label = "MA", value = TRUE
                 ),
                 checkboxInput(inputId = "addTA6", label = "MACD", value = FALSE
                 ),
                 checkboxInput(inputId = "addTA7", label = "ROC", value = TRUE
                 ),
                 checkboxInput(inputId = "addTA8", label = "RSI", value = FALSE
                 ),
                 submitButton("Update"),
#                ), #End wellPanel
               HTML('</details>'),
               conditionalPanel(#condition = "input.stock_axjo",
                 br(),
                 div(style="height:600px;padding-bottom:20px;",plotOutput(outputId = "plot_symbol")))#,
      )#, #end tabPanel1
      #tabPanel("Twitter/Facebook",
      #HTML('<iframe src="https://hootsuite.com/dashboard" height="100%" width="100%"></iframe>')
    )#end tabPanel2
  ) #end tabsetPanel
  #conditionalPanel(condition = "input.stock_aord",
  #                 br(),
  #                 plotOutput(outputId = "plot_aord"))
  
  #)#end main
))