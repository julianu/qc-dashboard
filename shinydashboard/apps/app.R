library(shinydashboard)

library(DT)
library(MASS)

# source the way, how the qc data is retrieved
source("./qc_data_retriever/static_json_impl/static_json.R")

# source in the plots
source("./visualisations/lineplots.R")


# setting up the dashboard
side_menu <- sidebarMenu(
  menuItem("Startpage", tabName = "startpage", icon = icon("dashboard")),
  menuItem("nr of Identification", tabName = "nr_identifications_tab", icon = icon("line-chart")),
  menuItem("PCA analysis", tabName = "pca_tab", icon = icon("cogs"))
)

# define UI for the dashboard
ui <- dashboardPage(
  dashboardHeader(title = "EuBIC QC"),
  dashboardSidebar(side_menu),
  dashboardBody(
    tabItems(

      tabItem(tabName = "startpage",
        box(
          title = "select datasets for analysis",
          DT::dataTableOutput(outputId = "fileSelectTable")
        ),
        box(
          title = "selected files",
          verbatimTextOutput('selectedFilesOutput')
        ),


        box(
          title = "debug",
          verbatimTextOutput('debugText')
        )
      ),

      tabItem(tabName = "nr_identifications_tab",
        fluidRow(
          box(
            title = "number of identified proteins",
            plotOutput(outputId = "nrProteinsLineChart")
          ),
          box(
            title = "number of identified peptides",
            plotOutput(outputId = "nrPeptidesLineChart")
          ),
          box(
            title = "number of identified PSMs",
            plotOutput(outputId = "nrPSMsLineChart")
          )
        )
      ),

      tabItem(tabName = "pca_tab",
        fluidRow(
              box(plotOutput(outputId = "plotPcaScores")),
              box(plotOutput(outputId = "plotPcaBi")),
              box(plotOutput(outputId = "plotPcaScree"))
          )
      )

    )
  )
)


# Define server logic required to draw a histogram ----
server <- function(input, output) {

  output$debugText <- renderText({
    paste("no debugging right now",
      collapse = "\n"
    )
  })


  # render the file selection table
  output$fileSelectTable <- DT::renderDataTable(
    data.frame(files = qcml_files)
  )

  output$selectedFilesOutput <- renderText({
    paste(
      qcml_files[sort(input$fileSelectTable_rows_selected)],
      collapse = "\n"
    )
  })


  # model for data to be analyzed
  dataSelected <- reactive({
    if (length(input$fileSelectTable_rows_selected) < 1) {
      # if nothing is selected, take all data
      qcfiles <- qcml_files
    } else {
      qcfiles <- qcml_files[sort(input$fileSelectTable_rows_selected)]
    }

    nr_proteins_metric <- as.numeric(getQcData(qcfiles = qcfiles, qcval = "QC:0000032"))
    nr_peptides_metric <- as.numeric(getQcData(qcfiles = qcfiles, qcval = "QC:0000030"))
    nr_psms_metric <- as.numeric(getQcData(qcfiles = qcfiles, qcval = "QC:0000029"))

    return(data.frame(nr_proteins_metric, nr_peptides_metric, nr_psms_metric))
  })

  # render the number of proteins (QC:0000032)
  output$nrProteinsLineChart <- renderPlot({
    linePlotWithMeanData(plotData = dataSelected()[, "nr_proteins_metric"], col = "aquamarine4")
  })

  # render the number of peptides (QC:0000030)
  output$nrPeptidesLineChart <- renderPlot({
    linePlotWithMeanData(plotData = dataSelected()[, "nr_peptides_metric"], col = "darkorange")
  })

  # render the number of PSMs (QC:0000029)
  output$nrPSMsLineChart <- renderPlot({
    linePlotWithMeanData(plotData = dataSelected()[, "nr_psms_metric"], col = "firebrick3")
  })


  # calculating PCA data
  pcaData <- reactive({
    metrics.pca <- dataSelected()

    robust.cov <- cov.rob(metrics.pca)      # robust covariance
    robust.cor <- cov2cor(robust.cov$cov)   # correlation matrix
    robust.cor.1 <- robust.cov
    robust.cor.1$cov <- robust.cor
    for (i in 1:ncol(metrics.pca)) {
       robust.cor.1$center[i] <- robust.cov$center[i] / sqrt(robust.cov$cov[i, i])
       metrics.pca[, i] <- metrics.pca[, i] / sqrt(robust.cov$cov[i, i])
    }

    return(princomp(metrics.pca, covmat = robust.cor.1, scores = T))
  })

  # plotting PCA data
  output$plotPcaScree <- renderPlot({
     plot(pcaData(), main = "Scree plot")
  })

  output$plotPcaBi <- renderPlot({
     biplot(pcaData(), main = "Biplot")
  })

  output$plotPcaScores <- renderPlot({
     plot(pcaData()$scores[,1], pcaData()$scores[,2],
          main = "PCA scores", xlab = "PC1", ylab = "PC2")
  })
}


# run the app
shinyApp(ui = ui, server = server)
