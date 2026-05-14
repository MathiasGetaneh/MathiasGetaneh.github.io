library(dplyr)
library(ggplot2)
setwd("/Users/mathi/Documents/GMU/Semester 9 (Fall 2025)/AIT580/Final Project")
#Importing data
housingdata <- read.csv("hpi_master2.csv", header=TRUE, sep=";", skip = 0)

#Adding extra columns for changes in indices
change_index = data.frame(matrix(nrow=nrow(housingdata), ncol=4))
housingdata = cbind(housingdata, change_index)
#Renaming columns
lookup = c(Year = "yr", Month = "period", change_nsa = 'X1', change_sa = 'X2', prop_change_nsa = 'X3', prop_change_sa = 'X4')
housingdata = rename(housingdata, all_of(lookup))
#Adding Index
Index <- c(1:nrow(housingdata))
State <- data.frame(matrix(nrow=nrow(housingdata), ncol=1))
colnames(State) = c("State")
splitInt = which(colnames(housingdata)=="place_id")
housingdata = cbind(Index,housingdata[,1:splitInt],State,housingdata[,(splitInt+1):ncol(housingdata)])
rm(State)
#Adding information about changes in index and state locations
for (x in 2:nrow(housingdata)) {
  #Checking for changes in index
  #Checks that the place_id, hpi_flavor, and hpi_type all match
  if ((housingdata[x-1, 'place_id'] == housingdata[x, 'place_id']) & 
    (housingdata[x-1, 'hpi_flavor'] == housingdata[x, 'hpi_flavor']) &
    (housingdata[x-1, 'hpi_type'] == housingdata[x, 'hpi_type'])) {
    housingdata[x, 'change_nsa'] = housingdata[x, 'index_nsa'] - housingdata[x-1, 'index_nsa']
    housingdata[x, 'prop_change_nsa'] = (housingdata[x,'change_nsa'])/housingdata[x-1, 'index_nsa'];
    if (is.null(housingdata[x, 'index_sa']) | (is.null(housingdata[x-1, 'index_sa']))) {
      housingdata[x, 'change_sa'] = NULL;
      housingdata[x, 'prop_change_sa'] = NULL;
    }
    else {
      housingdata[x, 'change_sa'] = housingdata[x, 'index_sa'] - housingdata[x-1, 'index_sa']
      housingdata[x, 'prop_change_sa'] = (housingdata[x,'change_sa'])/housingdata[x-1, 'index_sa'];
    }
  }
  #Finding states
  #Checking for state level
  if (housingdata[x,'level'] == 'State') {
    housingdata[x,'State'] = housingdata[x,'place_id']
  } 
  #Checking for states of MSA
  if (housingdata[x,'level'] == 'MSA') {
    housingdata[x,'State'] = unlist(strsplit(housingdata[x,'place_name'], ", "))[2]
  }
}

#Finding null values
nullvals = data.frame(matrix(nrow=1, ncol=ncol(housingdata)))
rownames(nullvals)='Name'
colnames(nullvals) = names(housingdata)
for (i in 1:ncol(housingdata)) {
  nullvals[i] = c(sum(is.na(housingdata[i])))
}

#Nominal statistics and plot
hpi_type2 = unique(housingdata['hpi_type'])
hpi_type = data.frame(matrix(nrow=2, ncol=nrow(hpi_type2)))
for (x in 1:nrow(hpi_type2)) {
  hpi_type[x] = c(hpi_type2[x,1], sum(housingdata$hpi_type == hpi_type2[x,1]))
}
hpi_type = t(hpi_type)
hpi_type = data.frame(matrix=hpi_type)
names = c("hpi_type", "Count")
colnames(hpi_type) = names
hpi_type$Count = as.numeric(hpi_type$Count)
type <- ggplot(hpi_type, mapping = aes(x=hpi_type, y=Count)) + geom_bar(stat = "identity")
type + labs(title = "Number of each type of development")

#Ordinal statistics and plot
hpi_flavor2 = unique(housingdata['hpi_flavor'])
hpi_flavor = data.frame(matrix(nrow=2, ncol=nrow(hpi_flavor2)))
for (x in 1:nrow(hpi_flavor2)) {
  hpi_flavor[x] = c(hpi_flavor2[x,1], sum(housingdata$hpi_flavor == hpi_flavor2[x,1]))
}
hpi_flavor = t(hpi_flavor)
hpi_flavor = data.frame(matrix=hpi_flavor)
names = c("hpi_flavor", "Count")
colnames(hpi_flavor) = names
hpi_flavor$Count = as.numeric(hpi_flavor$Count)
flavor = ggplot(hpi_flavor, mapping = aes(x=hpi_flavor, y=Count)) + geom_bar(stat = "identity")
flavor + labs(title = "Amount of each record type recorded")

#Ratio statistics and plot
housingdata = cbind(housingdata, Time=NA)
for (i in 1:nrow(housingdata)) {
  if (housingdata$frequency[i] == "quarterly") {
    month = 1+3*(housingdata$Month[i]-1)
    housingdata$Time[i] = paste(housingdata$Year[i], "-", month, "-1", sep="")
    rm(month)
  } 
  if (housingdata$frequency[i] == "monthly") {
    housingdata$Time[i] = paste(housingdata$Year[i], "-", housingdata$Month[i], "-1", sep="")
  }
}
housingdata$Time = as.Date(housingdata$Time)
statedata = filter(housingdata ,level == 'State' & hpi_flavor == 'all-transactions')
#statedata = rename(statedata, State='place_name')

hpi_index = ggplot(statedata, mapping = aes(x=Time, y=index_nsa, group=State, color=State)) + geom_line()
hpi_index + labs(x='Time', y='Housing Index, Non-Adjusted',title = "Non-adjusted Housing Index per State over Time")

#Creating list of negative indices with starting points
#Getting index data
negative_index_nsa = data.frame(matrix(nrow=0, ncol=ncol(housingdata)))
colnames(negative_index_nsa) = colnames(housingdata)
rowNum = 1
for (i in 1:nrow(housingdata)) {
  if (is.na(housingdata[i,]$change_nsa) == FALSE) {
    if (housingdata[i,]$change_nsa < 0) {
      negative_index_nsa[rowNum,1] = i
      rowNum = rowNum + 1
    } else if (is.na(housingdata[(i+1),]$change_nsa) == FALSE) {
      if (housingdata[(i+1),]$change_nsa < 0) {
        negative_index_nsa[rowNum,1] = i
        rowNum = rowNum + 1
      }
    } 
  } 
}
#Replacing data
for (i in 1:nrow(negative_index_nsa)) {
  rowNum = negative_index_nsa[i,1]
  negative_index_nsa[i,] = housingdata[rowNum,]
}
rm(rowNum)
negative_index_nsa = subset(housingdata, housingdata$change_nsa <= 0)

#Interval statistics and plot

#Checking State vs MPA levels
states = unique(statedata$State)
msadata = subset(housingdata, housingdata$level == "MSA")
localdata = subset(housingdata, is.na(housingdata$State) == FALSE)
rm(i)
for (i in states) {
  specificStateData = subset(localdata, localdata$State == i)
  temp3 = length(unique(specificStateData$place_name))
  if ((temp3 > 1) & (temp3 < 5)) {
    titleName = subset(specificStateData, specificStateData$level == "State")[1,]$place_name
    plotTitle = paste("Changes in Non-adjusted Housing Index in", titleName)
    statePlot = ggplot(data=specificStateData, aes(x=Time, y=prop_change_nsa, group=place_name, color=place_name)) + geom_line() + 
      labs(x='Time', y='Proportional Change in Housing Index, Non-Adjusted',title = plotTitle, color="Location")
    pngTitle = paste("nsa_", titleName, sep="")
    pngTitle = paste(pngTitle, ".png", sep = "")
    ggsave(pngTitle, plot=statePlot, width=6, height=4, dpi=300)
  }
}
#ggplot(data=specificStateData, aes(x=Time, y=index_nsa, group=place_name, color=place_name)) + geom_line() + 
#  labs(x='Time', y='Housing Index, Non-Adjusted',title = plotTitle, color = "Location")
write.table(housingdata, file = "hpiWithIndexChange.csv", sep=";", row.names = FALSE, na="")

#Cleaning useless variables
rm(hpi_type2)
rm(change_index)
rm(hpi_flavor2)
rm(lookup)
rm(names)
rm(i)
rm(x)
rm(Index)

