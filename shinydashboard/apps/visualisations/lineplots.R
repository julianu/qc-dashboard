# function for plotting the data as lines
# a standalone-function to make all plots look (and behave) similir
linePlotData <- function(plotData = c(), col = NULL, type = "b") {
  plot(x = c(1:length(plotData)),
    y = plotData,
    type = type,
    xlab = "",
    ylab = "",
    col = col,
    lwd = 3
  )
}


#
# plots the data with lines and uses the data given by the refDataIdx for
# calculation of mean and standard deviations, which are also highlighted in
# the plot
#
linePlotWithMeanData <- function(plotData = c(), col = NULL, refDataIdx = c()) {
  # plot only the lines (to set-up the plot area)
  linePlotData(plotData = plotData, col=col, type="c");

  if (length(refDataIdx) < 1) {
    refDataIdx = c(1:length(plotData))
  }

  meanData <- mean(plotData[refDataIdx])
  stddev <- sd(plotData[refDataIdx])

  rect(0, meanData - 3*stddev,
    length(plotData)+1, meanData + 3*stddev,
    density = NULL,
    col = "lightgray", border = NA)

  rect(0, meanData - 2*stddev,
    length(plotData)+1, meanData + 2*stddev,
    density = NULL,
    col = "gray", border = NA)

  rect(0, meanData - stddev,
    length(plotData)+1, meanData + stddev,
    density = NULL,
    col = "darkgray", border = NA)

  abline(h = meanData, untf = FALSE)

  # re-plot only the lines
  lines(x = c(1:length(plotData)),
    y = plotData,
    col=col,
    type="c",
    lwd=3
  )

  # plot data points inside 3*SD area
  plotIndices <- which((plotData >= meanData - 3*stddev) & (plotData <= meanData + 3*stddev))
  lines(
    x = plotIndices,
    y = plotData[plotIndices],
    col=col,
    type="p",
    lwd=3
  )

  # plot data points outside 3*SD area
  plotIndices <- which((plotData < meanData - 3*stddev) | (plotData > meanData + 3*stddev))
  lines(
    x = plotIndices,
    y = plotData[plotIndices],
    col="red",
    type="p",
    pch=4,
    lwd=3
  )
}
