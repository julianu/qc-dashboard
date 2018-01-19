library(jsonlite)

file_path <- "./qc_data_retriever/static_json_impl/"
json_files_path <- paste(file_path, "json_examples/", sep="");

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
  "elegans_01_QC_0000029.json",
  "elegans_02_QC_0000029.json",
  "elegans_03_QC_0000029.json",
  "elegans_04_QC_0000029.json",
  "elegans_05_QC_0000029.json",
  "elegans_06_QC_0000029.json",
  "elegans_07_QC_0000029.json",
  "elegans_08_QC_0000029.json",
  "elegans_09_QC_0000029.json"
)
json_files_elegans_QC_0000029 <- paste(json_files_path, json_files_elegans_QC_0000029, sep="")
qc_data_QC_0000029 <- c();
for (i in 1:length(json_files_elegans_QC_0000029)) {
  qc_data_QC_0000029[i] <- fromJSON(txt=json_files_elegans_QC_0000029[i])$"QC:0000029"
}

json_files_elegans_QC_0000030 <- c(
  "elegans_01_QC_0000030.json",
  "elegans_02_QC_0000030.json",
  "elegans_03_QC_0000030.json",
  "elegans_04_QC_0000030.json",
  "elegans_05_QC_0000030.json",
  "elegans_06_QC_0000030.json",
  "elegans_07_QC_0000030.json",
  "elegans_08_QC_0000030.json",
  "elegans_09_QC_0000030.json"
)
json_files_elegans_QC_0000030 <- paste(json_files_path, json_files_elegans_QC_0000030, sep="")
qc_data_QC_0000030 <- c();
for (i in 1:length(json_files_elegans_QC_0000030)) {
  qc_data_QC_0000030[i] <- fromJSON(txt=json_files_elegans_QC_0000030[i])$"QC:0000030"
}

json_files_elegans_QC_0000032 <- c(
  "elegans_01_QC_0000032.json",
  "elegans_02_QC_0000032.json",
  "elegans_03_QC_0000032.json",
  "elegans_04_QC_0000032.json",
  "elegans_05_QC_0000032.json",
  "elegans_06_QC_0000032.json",
  "elegans_07_QC_0000032.json",
  "elegans_08_QC_0000032.json",
  "elegans_09_QC_0000032.json"
)
json_files_elegans_QC_0000032 <- paste(json_files_path, json_files_elegans_QC_0000032, sep="")
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
