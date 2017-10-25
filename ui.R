library(shiny)
library(shinyjs)
library(colourpicker)

shinyUI(pageWithSidebar(
 
  	headerPanel("Heatmap"),

  	sidebarPanel(
      tabsetPanel(
        tabPanel("Data", 
          fileInput("data", "Choose data file",
            accept = c(
              "text/csv",
              "text/comma-separated-values,text/plain",
              ".csv",
              "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
              )
          ),
          textAreaInput("filter", "Filter for IDs"),
          fileInput("experiment", "Choose experiment description file",
            accept = c(
              "text/csv",
              "text/comma-separated-values,text/plain",
              ".csv",
              "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
              )
          )

        ), 
        tabPanel("Plot format", 
          radioButtons("log", "Log data:",
               c("Yes" = TRUE,
                 "No" = FALSE),
               selected=TRUE,
               inline=TRUE),
          radioButtons("dend", "Dendrogram:",
               c("None" = "none",
                 "Row" = "row",
                 "Column" = "column",
                 "Both" = "both"),
               selected="column",
               inline=TRUE),
          radioButtons("trace", "Trace:",
               c("None" = "none",
                 "Row" = "row",
                 "Column" = "column",
                 "Both" = "both"),
               inline=TRUE),
          textInput("keylabel", "Key label", "value")
        ), 
        tabPanel("Colours", 
          sliderInput("breaks", "Colour break:",
                min = 2, max = 100, value = 16),
          radioButtons("palette", "Colour palette:",
                c("Heat" = "heat.colors",
                  "Blue-red" = "bluered",
                  "Red-green" = "redgreen",
                  "Terrain" = "terrain.colors",
                  "Topo" = "topo.colors",
                  "Other (use selectors)" = "other"),
                selected="heat.colors",
                inline=TRUE),
          colourInput("colour1", "Select low colour", value = "blue"),
          colourInput("colour2", "Select medium colour", value = "white"),
          colourInput("colour3", "Select high colour", value = "red")
        ),
        tabPanel("Export", 
          sliderInput("pdfwidth", "PDF width:",
                min = 1, max = 25, value = 7, step=0.25),
          sliderInput("pdfheight", "PDF height:",
                min = 1, max = 25, value = 7, step=0.25)
        )
    )),

  	mainPanel(
    	useShinyjs(),
    	plotOutput("heatmap"),
    	downloadButton(outputId = "down", label = "Download the plot")
  	)
))