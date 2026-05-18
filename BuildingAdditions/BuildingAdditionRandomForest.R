#Library for making SVMs
library(e1071)
#Library for making Regression Trees
library(rpart)
library(rpart.plot)
#Library for plotting
library(ggplot2)
#Library for making random forests
library(ranger)
buildings = read.csv("Building_Additions_-6591872933771953326.csv")
buildings = buildings[,c(4,3,2,5:6,1)]
summary(buildings)
unique(buildings$Source)
#buildings$Building.Addition.Type = as.factor(buildings$Building.Addition.Type)
buildings$Source = as.factor(buildings$Source)
#buildings$GlobalID = as.factor(buildings$GlobalID)
#buildings$OBJECTID = as.factor(buildings$OBJECTID)
summary(buildings)
buildingsTrimmed = buildings
buildingsTrimmed$GlobalID <- NULL
buildingsTrimmed$OBJECTID <- NULL
#Removing other from buildingsTrimmed
buildingsTrimmed = subset(buildingsTrimmed, Building.Addition.Type != "OTHER")
buildingsTrimmed$Building.Addition.Type = as.factor(buildingsTrimmed$Building.Addition.Type)
#Separating by source
#This is because otherwise, the SVM is just too large to compile in a reasonable
#time.
eagleview22 = subset(buildingsTrimmed, Source == "EAGLEVIEW 2022")
eagleview23 = subset(buildingsTrimmed, Source == "EAGLEVIEW 2023")
ortho09 = subset(buildingsTrimmed, Source == "ORTHO2009")
stereo07 = subset(buildingsTrimmed, Source == "STEREO MODELS 2007")
stereo09 = subset(buildingsTrimmed, Source == "STEREO MODELS 2009")
stereo17 = subset(buildingsTrimmed, Source == "STEREO MODELS 2017")
#Removing source (it'd all be the same in these subsets, right?)
eagleview22$Source <- NULL
eagleview23$Source <- NULL
ortho09$Source <- NULL
stereo07$Source <- NULL
stereo09$Source <- NULL
stereo17$Source <- NULL
#Note: SVMs are made splitting specific sources for the sake of processing speed
#svmEagle22 = svm(Building.Addition.Type ~ Shape__Area + Shape__Length, data = eagleview22)
#summary(svmEagle22)
#Regression trees
overallTree = rpart(Building.Addition.Type ~ ., data = buildingsTrimmed, 
                    control = rpart.control(minsplit = 2))
rpart.plot(overallTree)
#Specific sources
eagle22Tree = rpart(Building.Addition.Type ~ ., data = eagleview22, 
                    control = rpart.control(minsplit = 2))
rpart.plot(eagle22Tree, main = "Eagleview 2022")
eagle23Tree = rpart(Building.Addition.Type ~ ., data = eagleview23, 
                    control = rpart.control(minsplit = 2))
rpart.plot(eagle23Tree, main = "Eagleview 2023")
stereo07Tree = rpart(Building.Addition.Type ~ ., data = stereo07, 
                     control = rpart.control(minsplit = 2))
rpart.plot(stereo07Tree, main = "Stereo Models 2007")
stereo09Tree = rpart(Building.Addition.Type ~ ., data = stereo09, 
                     control = rpart.control(minsplit = 2))
rpart.plot(stereo09Tree, main = "Stereo Models 2009")
stereo17Tree = rpart(Building.Addition.Type ~ ., data = stereo17, 
                     control = rpart.control(minsplit = 2))
rpart.plot(stereo17Tree, main = "Stereo Models 2017")
#FIXME: Replace with a random forest tree
library(ranger)
set.seed(662)
train.idx <- sample(x = nrow(buildingsTrimmed), 
                    size = 0.7*nrow(buildingsTrimmed))
buildingsTrimmed.train <- buildingsTrimmed[train.idx, ]
buildingsTrimmed.test <- buildingsTrimmed[-train.idx, ]
#Possible values for tree
#treeNums = c(9,100,200,300,400,500,1000,1100,1200,1300,1400)
treeNums = c(9,10,20,30,40,50,60,70,80,90,100,110,120)
OOBErrors = matrix(data = 0, nrow = length(treeNums),ncol = 2)
colnames(OOBErrors) = c("NumTrees", "OOB.Error")
minPredError = 0
for (i in 1:nrow(OOBErrors)) {
  OOBErrors[i,1] = treeNums[i]
  rf0 = ranger(Building.Addition.Type ~ ., data = buildingsTrimmed.train, 
               num.trees = treeNums[i], write.forest = TRUE)
  OOBErrors[i,2] = rf0$prediction.error
  #Saving tree here for interpretation
  if (i == 1) {
    rf = rf0
    minPredError = rf0$prediction.error
  }
  else {
    if (rf0$prediction.error < minPredError) {
      rf = rf0
      minPredError = rf0$prediction.error
    }
  }
}
#Finding true value for tree
bestNumTree = OOBErrors[which.min(OOBErrors[,2]),1]
#Plotting Number of Trees vs. OOB Error
ggplot(data = OOBErrors, mapping = aes(x = NumTrees, y = OOB.Error)) +
  geom_line() +
  labs(x = "Number of Trees", y = "OOB Error", title = "Number of Trees vs OOB Error")
#rf <- ranger(Building.Addition.Type ~ ., data = buildingsTrimmed.train, 
#             num.trees = bestNumTree,write.forest = TRUE)
pred <- predict(rf, data = buildingsTrimmed.test)
rf_confusion_matrix = table(Actual = buildingsTrimmed.test$Building.Addition.Type, 
                            Predicted = predictions(pred))
rf_confusion_matrix
#Accuracy of Model
sensitivity = matrix(data = 0, nrow = 4, ncol = 2)
colnames(sensitivity) = c("Name", "Sensitivity")
sensitivity[,1] = colnames(rf_confusion_matrix)
for (i in 1:nrow(sensitivity)) {
  sensitivity[i,2] = rf_confusion_matrix[i,i]/sum(rf_confusion_matrix[i,])
}
ggplot(data = sensitivity, mapping = aes(x = Name, y = Sensitivity)) +
  geom_bar(stat = "identity") +
  labs(title = "Sensitivity of each Building Addition Type")
accuratePredictions = sum(diag(rf_confusion_matrix))/sum(rf_confusion_matrix)
numAccuratePredictions = sum(diag(rf_confusion_matrix))
wrongPredictions = 1 - accuratePredictions
numWrongPredictions = sum(rf_confusion_matrix)-sum(diag(rf_confusion_matrix))
#Testing importance of factors
rf2 <- ranger(Building.Addition.Type ~ ., data = buildingsTrimmed.train, mtry=3,
              num.trees=bestNumTree, importance="impurity", write.forest = TRUE)
importance(rf2)
pred2 = predict(rf2, data = buildingsTrimmed.test)
table(Actual = buildingsTrimmed.test$Building.Addition.Type, 
      Predicted = predictions(pred2))
