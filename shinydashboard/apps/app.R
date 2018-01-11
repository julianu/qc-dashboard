library(shinydashboard)
library(jsonlite)
library(DT)


######
# select data for visualization (hard-coded now)
######
qcml_files <- c(
  "C_elegans_LS_01_run1_07Nov13_Pippin_13-06-18.qcML",
  "C_elegans_LS_02_run1_07Nov13_Pippin_13-06-18.qcML",
  "C_elegans_LS_03_run1_07Nov13_Pippin_13-06-18.qcML",
  "C_elegans_LS_04_run1_07Nov13_Pippin_13-06-18.qcML",
  "C_elegans_LS_05_run1_07Nov13_Pippin_13-06-18.qcML",
  "C_elegans_LS_06_run1_07Nov13_Pippin_13-06-18.qcML",
  "C_elegans_LS_07_run1_07Nov13_Pippin_13-06-18.qcML",
  "C_elegans_LS_08_run1_07Nov13_Pippin_13-06-18.qcML",
  "C_elegans_LS_09_run1_07Nov13_Pippin_13-06-18.qcML"
)


# parse actual data from json files (for now)
json_files_elegans_QC_0000029 <- c(
  "./json_examples/elegans_01_QC_0000029.json",
  "./json_examples/elegans_02_QC_0000029.json",
  "./json_examples/elegans_03_QC_0000029.json",
  "./json_examples/elegans_04_QC_0000029.json",
  "./json_examples/elegans_05_QC_0000029.json",
  "./json_examples/elegans_06_QC_0000029.json",
  "./json_examples/elegans_07_QC_0000029.json",
  "./json_examples/elegans_08_QC_0000029.json",
  "./json_examples/elegans_09_QC_0000029.json"
)
qc_data_QC_0000029 <- c();
for (i in 1:length(json_files_elegans_QC_0000029)) {
  qc_data_QC_0000029[i] <- fromJSON(txt=json_files_elegans_QC_0000029[i])$"QC:0000029"
}

json_files_elegans_QC_0000030 <- c(
  "./json_examples/elegans_01_QC_0000030.json",
  "./json_examples/elegans_02_QC_0000030.json",
  "./json_examples/elegans_03_QC_0000030.json",
  "./json_examples/elegans_04_QC_0000030.json",
  "./json_examples/elegans_05_QC_0000030.json",
  "./json_examples/elegans_06_QC_0000030.json",
  "./json_examples/elegans_07_QC_0000030.json",
  "./json_examples/elegans_08_QC_0000030.json",
  "./json_examples/elegans_09_QC_0000030.json"
)
qc_data_QC_0000030 <- c();
for (i in 1:length(json_files_elegans_QC_0000030)) {
  qc_data_QC_0000030[i] <- fromJSON(txt=json_files_elegans_QC_0000030[i])$"QC:0000030"
}

json_files_elegans_QC_0000032 <- c(
  "./json_examples/elegans_01_QC_0000032.json",
  "./json_examples/elegans_02_QC_0000032.json",
  "./json_examples/elegans_03_QC_0000032.json",
  "./json_examples/elegans_04_QC_0000032.json",
  "./json_examples/elegans_05_QC_0000032.json",
  "./json_examples/elegans_06_QC_0000032.json",
  "./json_examples/elegans_07_QC_0000032.json",
  "./json_examples/elegans_08_QC_0000032.json",
  "./json_examples/elegans_09_QC_0000032.json"
)
qc_data_QC_0000032 <- c();
for (i in 1:length(json_files_elegans_QC_0000032)) {
  qc_data_QC_0000032[i] <- fromJSON(txt=json_files_elegans_QC_0000032[i])$"QC:0000032"
}

# this function gets the qcval as fson from the given source (which is hard
# coded for now and in the json examplke file) and the actual files (which are
# mapped for now).
# source might later on be something like eiher the qcML files or a database
getQcData <- function(source = NULL, qcfiles = c(), qcval = NULL) {
  values <- c();
  for (file in qcfiles) {
    values <- c(values, getQcDataForFile(file, qcval))
  }

  return(values)
}

# almost everything hard coded for now
getQcDataForFile <- function(qcfile = NULL, qcval = NULL) {
  idx = match(qcfile, qcml_files, nomatch = -1)
  retval <- NaN
  if (idx > 0) {
    if (qcval == "QC:0000029") {
      retval <- qc_data_QC_0000029[idx]
    } else if (qcval == "QC:0000030") {
      retval <- qc_data_QC_0000030[idx]
    } else if (qcval == "QC:0000032") {
      retval <- qc_data_QC_0000032[idx]
    }
  }
  return(retval)
}


# function for plotting the data as lines
# a standalone-function to make all plots look (and behave) similir
linePlotData <- function(plotData = c(), col = NULL) {
  plot(x = c(1:length(plotData)),
    y = plotData,
    type = "l",
    xlab="",
    ylab="",
    col=col,
    lwd=3
  )
}





# setting up the dashboard
side_menu <- sidebarMenu(
  menuItem("Startpage", tabName = "startpage", icon = icon("dashboard")),
  menuItem("nr of Identification", tabName = "nr_identifications_tab", icon = icon("line-chart"))
)

# Define UI for app that draws a histogram ----
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
      )

    )
  )
)


# Define server logic required to draw a histogram ----
server <- function(input, output) {


  output$debugText <- renderText({
    paste("hello, no debug",
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


  # render the number of proteins (QC:0000032)
  output$nrProteinsLineChart <- renderPlot({
    if (length(input$fileSelectTable_rows_selected) < 1) {
      # if nothing is selected, take all data
      qcfiles <- qcml_files
    } else {
      qcfiles <- qcml_files[sort(input$fileSelectTable_rows_selected)]
    }

    proteinData <- getQcData(qcfiles = qcfiles, qcval = "QC:0000032")
    #psmData <- getQcData(qcfiles = qcfiles, qcval = "QC:0000029")

    linePlotData(plotData = proteinData, col = "aquamarine4")
  })

  # render the number of peptides (QC:0000030)
  output$nrPeptidesLineChart <- renderPlot({
    if (length(input$fileSelectTable_rows_selected) < 1) {
      # if nothing is selected, take all data
      qcfiles <- qcml_files
    } else {
      qcfiles <- qcml_files[sort(input$fileSelectTable_rows_selected)]
    }

    peptideData <- getQcData(qcfiles = qcfiles, qcval = "QC:0000030")
    linePlotData(plotData = peptideData, col = "darkorange")
  })

  # render the number of PSMs (QC:0000029)
  output$nrPSMsLineChart <- renderPlot({
    if (length(input$fileSelectTable_rows_selected) < 1) {
      # if nothing is selected, take all data
      qcfiles <- qcml_files
    } else {
      qcfiles <- qcml_files[sort(input$fileSelectTable_rows_selected)]
    }

    psmsData <- getQcData(qcfiles = qcfiles, qcval = "QC:0000029")
    linePlotData(plotData = psmsData, col = "firebrick3")
  })
}


# run the app
shinyApp(ui = ui, server = server)
