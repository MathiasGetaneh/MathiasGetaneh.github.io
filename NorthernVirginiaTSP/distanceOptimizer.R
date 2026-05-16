setwd("~/GMU/Semester 10 (Spring 2026)/OR541/Final Project")
#places = read.csv("sf12010placedistance100miles.csv")
#VA is described as state 51 in file
#VA = subset(places, state1 == 51 & state2 == 51)
#write.csv(VA, "VAPlaces.csv", row.names = F)
VA2 = read.csv("VAPlaces.csv")
relevantPlaces = data.frame(data = 0, ncol = 2)
colnames(relevantPlaces) = c("PlaceCode", "Name")
relevantPlaces[1,] = c(26496, "Fairfax")
relevantPlaces[2,] = c(03000, "Arlington")
relevantPlaces[3,] = c(47064, "Lorton")
relevantPlaces[4,] = c(54144, "Mount Vernon")
relevantPlaces[5,] = c(01000, "Alexandria")
relevantPlaces[6,] = c(14744, "Chantilly")
relevantPlaces[7,] = c(48952, "Manassas")
relevantPlaces[8,] = c(44984, "Leesburg")
relevantPlaces[9,] = c(29744, "Fredericksburg")
relevantPlaces[10,] = c(29968, "Front Royal")

desiredPlaces = subset(VA2, place1 == 0)
for (i in 1:nrow(relevantPlaces)) {
  for (j in 1:nrow(relevantPlaces)) {
    if ((i != j) & (i < j)) {
      temp1 = subset(VA2, place1 == relevantPlaces[i,1] & place2 == relevantPlaces[j,1])
      temp2 = subset(VA2, place1 == relevantPlaces[j,1] & place2 == relevantPlaces[i,1])
      desiredPlaces = rbind(desiredPlaces, temp1, temp2)
      rm(temp1, temp2)
    }
  }
}
TSPMatrix = matrix(data = 0, nrow = nrow(relevantPlaces), ncol = nrow(relevantPlaces))
colnames(TSPMatrix) = relevantPlaces[,2]
rownames(TSPMatrix) = relevantPlaces[,2]
for (i in 1:nrow(relevantPlaces)) {
  temp = subset(desiredPlaces, place1 == relevantPlaces[i,1])
  for (j in 1:nrow(relevantPlaces)) {
    if (i != j) {
      temp2 = subset(temp, place2 == relevantPlaces[j,1])
      TSPMatrix[i,j] = temp2[1,3]
      rm(temp2)
    }
  }
  rm(temp)
}
rm(i,j)
placeChecks = matrix(data = 0, nrow = nrow(relevantPlaces), ncol = 4)
colnames(placeChecks) = c("PlaceCode", "Name", "Place1", "Place2")
for (i in 1:nrow(relevantPlaces)) {
  placeChecks[i,1] = relevantPlaces[i,1]
  placeChecks[i,2] = relevantPlaces[i,2]
  placeChecks[i,3] = sum(desiredPlaces$place1 == relevantPlaces[i,1])
  placeChecks[i,4] = sum(desiredPlaces$place2 == relevantPlaces[i,1])
}
write.csv(TSPMatrix, "VATSP.csv")
