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
              ".csv")
          ),
          textAreaInput("filter", "Filter for IDs"),
      #fileInput("goi", "Choose data points of interest file",
        # accept = c(
        #     "text/csv",
        #     "text/comma-separated-values,text/plain",
        #     ".csv")
        #),
          fileInput("experiment", "Choose experiment description file",
            accept = c(
              "text/csv",
              "text/comma-separated-values,text/plain",
              ".csv")
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
        #colourWidget(width=35, showColour="background", value="blue", elementId="colour1"),
        #colourWidget(width=35, showColour="background", value="white", elementId="colour2"),
        #colourWidget(width=35, showColour="background", value="red", elementId="colour3")
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
#    ),
#,
        
        
       #checkboxInput("hdend", "Horizontal dendrogram", TRUE)
    )),

  	mainPanel(
    	#h3(textOutput("caption")),
    	useShinyjs(),
    	plotOutput("heatmap"),
    	downloadButton(outputId = "down", label = "Download the plot")
  	)
))