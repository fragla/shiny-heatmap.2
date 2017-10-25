options(shiny.maxRequestSize=500*1024^2)


library(shiny)
library(gplots)
library(xlsx)
library(mime)
# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  readData <- reactive({
    if(input$data$type==mimemap["xlsx"]) {
      data <- read.xlsx2(file=input$data$datapath, sheetIndex=1, row.names=1, header=TRUE)
    }
    else {
      data <- read.csv(file=input$data$datapath, header=TRUE, row.names=1)
    }
    return(data)
  })

  readExperiment <- reactive({
    if(input$experiment$type==mimemap["xlsx"]) {
      experiment <- read.xlsx2(file=input$experiment$datapath, sheetIndex=1, header=TRUE)
    }
    else {
      experiment <- read.csv(file=input$experiment$datapath, header=TRUE)
    }
    return(experiment)
  })

	goi.heatmap <- function(input) {
    data <- readData()
		filter <- as.character(unlist(strsplit(input$filter, "\\s")))
  		tpm.filter <- data[tolower(rownames(data)) %in% tolower(filter),]

  		key.label <- input$keylabel
  		if(input$log) {
  			tpm.filter[tpm.filter==0] <- NA
  			tpm.filter <- log2(na.omit(tpm.filter))
  			key.label <- paste0("log2(", key.label, ")")
  		}

      main.palette <- NULL
      breaks <- input$breaks
      if (input$palette=="other") {
        main.palette <- colorpanel(breaks, input$colour1, input$colour2, input$colour3) 
        breaks <- NULL
      }
      else {
        main.palette <- input$palette
      }

  		col.colours <- NULL
  		if(!is.null(input$experiment)) {
        experiment <- readExperiment()
  			idx <- match(colnames(data), as.character(experiment[,1]))
			  col.colours <- palette()[as.numeric(experiment[idx,2])]
  		}
  		else {
  			col.colours <- rep("white", ncol(tpm.filter))
  		}
  		

  		heatmap.2(
  			as.matrix(tpm.filter), #log2(as.matrix(tpm.goi)[-9,]), 
  			trace=input$trace, 
  			density.info="none", 
  			dendrogram=input$dend, 
  			key.xlab=key.label,
  			na.color="black",
  			ColSideColors=col.colours,
        col=main.palette,
        breaks=breaks,
        margins = c(8, 16))
	}

  	output$heatmap <- renderPlot({
  		if(is.null(input$data) || length(as.character(unlist(strsplit(input$filter, "\\s"))))==0) {
  			return(NULL)
  		}
  		goi.heatmap(input)
  	})

  	output$down <- downloadHandler(
  	    filename =  function() {

  	    	#sub(".csv", ".pdf", input$goi)
          "heatmap.pdf"
  	    },
  	    # content is a function with argument file. content writes the plot to the device
  	    content = function(file) {
  	      	pdf(file, width=input$pdfwidth, height=input$pdfheight) # open the pdf device
  	      	goi.heatmap(input)
  	     	dev.off()  # turn the device off
  	    
  	    } 
  	)

  	observe({
  		if (is.null(input$data) || length(as.character(unlist(strsplit(input$filter, "\\s"))))==0) {
    		shinyjs::disable("down")
  		} 
  		else {
    		shinyjs::enable("down")
  		}
	})
})