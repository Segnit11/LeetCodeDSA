---
title: "Project_GNAC_Soccer"
author: "Segni"
date: "2024-11-23"
output: html_document
---

#----------------------------------------------------------------------------------------------------------------
# R Markdown Setup
#----------------------------------------------------------------------------------------------------------------
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
#Library and Main File

# Set the working directory to the main project folder
mainfile = "/Users/segnitulu/Library/Mobile Documents/com~apple~CloudDocs/R Shared folder/GNAC_Soccer_Project"
coinRDir = "/Users/segnitulu/Desktop/CBC/Cbc-2.3.2-mac-osx-x86_64-gcc4.3.3-parallel/bin"
setwd(mainfile)

library(lpSolve)
library(lpSolveAPI)
library(readxl)
library(lubridate)
```

```{r}

#----------------------------------------------------------------------------------------------------------------
# SETTING SCHEDULE PARAMETERS
#----------------------------------------------------------------------------------------------------------------
HomeMin = 5
AwayMin = 5
homeMax = 4
awayMax = 4
byeSpacing = 1
lastDaysHomeGames = 3
minHomeOnWeekends = 3
byeOpponentMax  = 4

womensHomeMax = homeMax
mensHomeMax = homeMax
womensAwayMax = awayMax
mensAwayMax = awayMax

longTeamsOnWeekends <- TRUE

# prep file names for outputs
  mensCSV = paste("m",
                  homeMax,
                  awayMax,
                  byeSpacing,
                  lastDaysHomeGames,
                  minHomeOnWeekends,
                  byeOpponentMax,
                  ".csv",
                  sep = "_")
  womensCSV = paste("w",
                  homeMax,
                  awayMax,
                  byeSpacing,
                  lastDaysHomeGames,
                  minHomeOnWeekends,
                  byeOpponentMax,
                  ".csv",
                  sep = "_")
```

Helper Functions

```{r}
#Generate Constraint
generateConstraint = function(regexList,valueList,ineq,rhs)
{
  newConstraint <- matrix(0,1,length(namesOfVariables))
  colnames(newConstraint) <- namesOfVariables
  for(ii in 1:length(regexList))
  {
    regex <- regexList[ii]
    indicesToModify <- grep(pattern = regex,namesOfVariables)
    newConstraint[indicesToModify] <- valueList[ii]
  }
  constraintMatrix[newRowCounter,] <<- newConstraint
  inequalities[newRowCounter,1] <<- ineq
  rightHandSide[newRowCounter,1] <<- rhs
  newRowCounter <<- newRowCounter + 1
}
cleanUpModel = function()
{
  whereIsZero <- which(abs(constraintMatrix) %*% matrix(1,ncol(constraintMatrix),1) == 0)
  if(length(whereIsZero) > 0)
  {
    constraintMatrix <<- constraintMatrix[-whereIsZero, ]
    inequalities <<- inequalities[-whereIsZero, ,drop=FALSE]
    rightHandSide <<- rightHandSide[-whereIsZero, ,drop=FALSE]
  }
}

padModel = function(numberOfRowsToAdd)
{
  oldNumberOfConstraints <- nrow(constraintMatrix)
  constraintMatrix <<- rbind(constraintMatrix,matrix(0,numberOfRowsToAdd,ncol(constraintMatrix)))
  inequalities <<- rbind(inequalities,matrix("",numberOfRowsToAdd,1))
  rightHandSide <<- rbind(rightHandSide,matrix(0,numberOfRowsToAdd,1))
  nrc <- oldNumberOfConstraints + 1
  return(nrc)
}
#this takes in the output of formatInput
getOppenents = function(m,team)
{
  allteams = colnames(m)
  teamRow = allteams[which(m[team,] == "1")]
  print(teamRow)
  return(teamRow)
}
```

Creating Lists

```{r}
excel_sheets("GNAC_Soccer.xlsx") 


MenTeams <-read_excel("GNAC_Soccer.xlsx",  
                       sheet = "TeamsMens")
WomenTeams<-read_excel("GNAC_Soccer.xlsx",  
                       sheet = "TeamsWomens")
Dates <-read_excel("GNAC_Soccer.xlsx", 
                       sheet = "2025Dates") 
  

menTeams = as.matrix(MenTeams)
namesOfMensTeams = menTeams[,1]
namesOfMensTeams

womenTeams = as.matrix(WomenTeams)
namesOfWomensTeams = womenTeams[,1]
namesOfWomensTeams

playDates = as.matrix(Dates)
numericDates = as.numeric(ymd(playDates[,2]))

numericDates



```

Creating Variables

```{r}
namesOfVariables = c()

# Exclude "SMU" from the list of teams
filteredTeams <- setdiff(menTeams, "SMU")

# Create an empty list to store the playlists
menPlayList1 <- vector(mode = 'list', length = length(filteredTeams))

# Assign team names as list names
names(menPlayList1) <- filteredTeams

# Populate the list
for (team in filteredTeams) {
  menPlayList1[[team]] <- setdiff(filteredTeams, team) # Exclude the team itself
}

# Output the list
# menPlayList1


# Create an empty list to store the playlists
womenPlayList1 <- vector(mode = 'list', length = length(womenTeams))

# Assign team names as list names
names(womenPlayList1) <- womenTeams

# Populate the list
for (team in womenTeams) {
  womenPlayList1[[team]] <- setdiff(womenTeams, team) # Exclude the team itself
}

# Output the list
# womenPlayList1


for(t1 in namesOfMensTeams)
{
  opponents = menPlayList1[[t1]]
  for(t2 in opponents)
  {
    for(dateNumber in numericDates)
    {
      dayOfWeek = wday(as.Date(dateNumber,origin = lubridate::origin))
      newVariable = paste("x",t1,t2,dateNumber,dayOfWeek,"Men",sep = ".")
      namesOfVariables = c(namesOfVariables,newVariable)

    }
  }
}


for(t1 in namesOfWomensTeams)
{
  opponents = womenPlayList1[[t1]]
  for(t2 in opponents)
  {
    for(dateNumber in numericDates)
    {
      dayOfWeek = wday(as.Date(dateNumber,origin = lubridate::origin))
      newVariable = paste("x",t1,t2,dateNumber,dayOfWeek,"Women",sep = ".")
      namesOfVariables = c(namesOfVariables,newVariable)
    }
  }
}


```

Constraints

```{r}
#Creating constraint matrix
constraintMatrix = matrix(0,0,length(namesOfVariables))
colnames(constraintMatrix) = namesOfVariables
inequalities = matrix("",0,1)
rightHandSide = matrix(0,0,1)

```

```{r}
#ONLY ONE GAME PER TEAM ON EACH PLAY DATE
#Men

newRowCounter = padModel(numberOfRowsToAdd = length(numericDates) * length(namesOfMensTeams))

for(date in numericDates){
  for(t in namesOfMensTeams){
    
    regexList = c(
                  paste("^x",t,".*",date,".*","Men",sep = "\\."),
                  paste("^x",".*",t,date,".*","Men",sep = "\\.")
                  )
    valueList = c(
                  1,
                  1
                  )
    newIneq = "<="
    newRhs = 1
    generateConstraint(regexList,valueList,newIneq,newRhs)
  }
}
cleanUpModel()
#Women need equal to since they need to fill out all games
newRowCounter = padModel(numberOfRowsToAdd = length(numericDates) * length(namesOfWomensTeams))

for(date in numericDates){
  for(t in namesOfWomensTeams){
    regexList = c(paste("^x",t,".*",date,".*","Women",sep = "\\."),
                  paste("^x",".*",t,date,".*","Women",sep = "\\."))
    valueList = c(1,
                  1)
    newIneq = "<="
    newRhs = 1
    generateConstraint(regexList,valueList,newIneq,newRhs)
  }
}

cleanUpModel()
```


Men's play 12 games per season
```{r}
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams))

  for(t in namesOfMensTeams){
    regexList = c(paste("^x",t,".*",".*",".*","Men",sep = "\\."),
                  paste("^x",".*",t,".*",".*","Men",sep = "\\."))
                  
    valueList = rep(1, length(regexList))
    newIneq = "="
    newRhs = 12
    generateConstraint(regexList,valueList,newIneq,newRhs)
  }

cleanUpModel()
```

Women play 13 games per season
```{r}
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams))

  for(t in namesOfWomensTeams){
    regexList = c(paste("^x",t,".*",".*",".*","Women",sep = "\\."),
                  paste("^x",".*",t,".*",".*","Women",sep = "\\."))

    valueList = rep(1, length(regexList))
    newIneq = "="
    newRhs = 13
    generateConstraint(regexList,valueList,newIneq,newRhs)
  }

cleanUpModel()
```

Min amount of home and away games per season
```{r}
#Men's Home
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams))

for(t in namesOfMensTeams){
    regexList = c(paste("^x",t,".*",".*",".*","Men",sep = "\\."))

    valueList = rep(1, length(regexList))
    newIneq = ">="
    newRhs = 5
    generateConstraint(regexList,valueList,newIneq,newRhs)
}

cleanUpModel()
#Men's Away
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams))

  for(t in namesOfMensTeams){
    regexList = c(paste("^x",".*",t,".*",".*","Men",sep = "\\."))

    valueList = rep(1, length(regexList))
    newIneq = ">="
    newRhs = 5
    generateConstraint(regexList,valueList,newIneq,newRhs)
  }

cleanUpModel()

#Women's Home
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams))

  for(t in namesOfWomensTeams){
    regexList = c(paste("^x",t,".*",".*",".*","Women",sep = "\\."))

    valueList = rep(1, length(regexList))
    newIneq = ">="
    newRhs = 5
    generateConstraint(regexList,valueList,newIneq,newRhs)
  }

cleanUpModel()
#Women's Away
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams))

  for(t in namesOfWomensTeams){
    regexList = c(paste("^x",".*",t,".*",".*","Women",sep = "\\."))

    valueList = rep(1, length(regexList))
    newIneq = ">="
    newRhs = 5
    generateConstraint(regexList,valueList,newIneq,newRhs)
  }

cleanUpModel()
```


No more than three Home games per season

```{r}
#for Men's Home
# Loop to ensure no team has more than 3 consecutive home games over 4 consecutive days
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams) * (length(numericDates) - 3))  # Account for 4 consecutive dates

# Iterate over each team
for (t in namesOfMensTeams) {
  # Check all possible 4-day consecutive sequences
  for (i in 1:(length(numericDates) - 3)) {
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    date3 = numericDates[i+2]
    date4 = numericDates[i+3]

    # Define regex patterns for the consecutive 4 home games
    regexList = c(
      paste("^x", t, ".*", date1, ".*", "Men", sep = "\\."),
      paste("^x", t, ".*", date2, ".*", "Men", sep = "\\."),
      paste("^x", t, ".*", date3, ".*", "Men", sep = "\\."),
      paste("^x", t, ".*", date4, ".*", "Men", sep = "\\.")
    )

    # Set coefficients for all variables in this sequence
    valueList = rep(1, length(regexList))

    # Create the constraint (<= 3 consecutive home games)
    newIneq = "<="
    newRhs = 3
    generateConstraint(regexList, valueList, newIneq, newRhs)
  }
}

cleanUpModel()

#Women's HOme games
# Loop to ensure no team has more than 3 consecutive home games over 4 consecutive days
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams) * (length(numericDates) - 3))  # Account for 4 consecutive dates

# Iterate over each team
for (t in namesOfWomensTeams) {
  # Check all possible 4-day consecutive sequences
  for (i in 1:(length(numericDates) - 3)) {
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    date3 = numericDates[i+2]
    date4 = numericDates[i+3]

    # Define regex patterns for the consecutive 4 home games
    regexList = c(
      paste("^x", t, ".*", date1, ".*", "Women", sep = "\\."),
      paste("^x", t, ".*", date2, ".*", "Women", sep = "\\."),
      paste("^x", t, ".*", date3, ".*", "Women", sep = "\\."),
      paste("^x", t, ".*", date4, ".*", "Women", sep = "\\.")
    )

    # Set coefficients for all variables in this sequence
    valueList = rep(1, length(regexList))

    # Create the constraint (<= 3 consecutive home games)
    newIneq = "<="
    newRhs = 3
    generateConstraint(regexList, valueList, newIneq, newRhs)
  }
}

cleanUpModel()  # Clean up any unused rows or constraints

```



No more than three away games per season

```{r}
# Loop to ensure no team has more than 3 consecutive away games over 4 consecutive days for men's teams
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams) * (length(numericDates) - 3))  # Account for 4 consecutive dates

# Iterate over each team for men's away games
for (t in namesOfMensTeams) {
  # Check all possible 4-day consecutive sequences
  for (i in 1:(length(numericDates) - 3)) {
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    date3 = numericDates[i+2]
    date4 = numericDates[i+3]
    
    # Define regex patterns for the consecutive 4 away games for men's teams
    regexList = c(
      paste("^x",  t,".*", ".*", date1, ".*", "Men", sep = "\\."),  # Date 1
      paste("^x",  t,".*", ".*", date2, ".*", "Men", sep = "\\."),  # Date 2
      paste("^x",  t,".*", ".*", date3, ".*", "Men", sep = "\\."),  # Date 3
      paste("^x",  t,".*", ".*", date4, ".*", "Men", sep = "\\.")   # Date 4
    )
    
    # Set coefficients for all variables in this sequence
    valueList = rep(1, length(regexList))
    
    # Create the constraint (<= 3 consecutive away games)
    newIneq = "<="
    newRhs = 3
    generateConstraint(regexList, valueList, newIneq, newRhs)
  }
}

cleanUpModel()  # Clean up any unused rows or constraints

# Loop to ensure no team has more than 3 consecutive away games over 4 consecutive days for women's teams
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams) * (length(numericDates) - 3))  # Account for 4 consecutive dates

# Iterate over each team for women's away games
for (t in namesOfWomensTeams) {
  # Check all possible 4-day consecutive sequences
  for (i in 1:(length(numericDates) - 3)) {
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    date3 = numericDates[i+2]
    date4 = numericDates[i+3]
    
    # Define regex patterns for the consecutive 4 away games for women's teams
    regexList = c(
      paste("^x", ".*", t, ".*", date1, ".*", "Women", sep = "\\."),  # Date 1
      paste("^x", ".*", t, ".*", date2, ".*", "Women", sep = "\\."),  # Date 2
      paste("^x", ".*", t, ".*", date3, ".*", "Women", sep = "\\."),  # Date 3
      paste("^x", ".*", t, ".*", date4, ".*", "Women", sep = "\\.")   # Date 4
    )
    
    # Set coefficients for all variables in this sequence
    valueList = rep(1, length(regexList))
    
    # Create the constraint (<= 3 consecutive away games)
    newIneq = "<="
    newRhs = 3
    generateConstraint(regexList, valueList, newIneq, newRhs)
  }
}

cleanUpModel()  # Clean up any unused rows or constraints

```

Only play with one opponent once per seoason

```{r}
newRowCounter = padModel(length(namesOfMensTeams)*length(namesOfMensTeams))
#Women
for(n1 in 1:(length(namesOfMensTeams)-1)){
  for(n2 in (n1+1):length(namesOfMensTeams)){
    t1 = namesOfMensTeams[n1]
    t2 = namesOfMensTeams[n2]
      regexList = c()
        for(date in numericDates){
          regexList = c(regexList,
                        paste("^x",t1,t2,date,".*","Men",sep = "\\."),
                        paste("^x",t2,t1,date,".*","Men",sep = "\\."))
        }
      valueList = rep(1,length(regexList))
      newIneq = "="
      newRhs = 1
      generateConstraint(regexList,valueList,newIneq,newRhs)
    }
  }
cleanUpModel()
#EACH WOMEN'S PLAYS EACH Half 2 opponenet as designated by totalSecond exactly once
#firstHalf = head(numericDates, n = length(numericDates)/2).  Mens will follow due to other constraints coupling them together

newRowCounter = padModel(length(namesOfWomensTeams)*length(namesOfWomensTeams))
#Women
for(n1 in 1:(length(namesOfWomensTeams)-1)){
  for(n2 in (n1+1):length(namesOfWomensTeams)){
    t1 = namesOfWomensTeams[n1]
    t2 = namesOfWomensTeams[n2]
        regexList = c()
        for(date in numericDates){
          regexList = c(regexList,
                        paste("^x",t1,t2,date,".*","Women",sep = "\\."),
                        paste("^x",t2,t1,date,".*","Women",sep = "\\."))
        }
        valueList = rep(1,length(regexList))
        newIneq = "="
        newRhs = 1
        generateConstraint(regexList,valueList,newIneq,newRhs)
      }
    }
  #clean up the constraint matrix
  cleanUpModel()

```

```{r}
#Create LP object
LP = make.lp(NROW(constraintMatrix),NCOL(constraintMatrix))

# Load the SpecialDates sheet
specialDates <- read_excel("GNAC_Soccer.xlsx", sheet = "SpecialDates")

# Extract relevant columns (Teams and SpecialDates)
teamSpecialDates <- as.data.frame(specialDates[, c("Teams", "SpecialDates")])

# Convert special dates to numeric format for matching (if applicable)
teamSpecialDates$SpecialDates <- as.numeric(ymd(teamSpecialDates$SpecialDates))

# Initialize the objective function
objectiveFunction <- matrix(0, 1, length(namesOfVariables))
colnames(objectiveFunction) <- namesOfVariables


# Loop through each team and its special dates
for (i in 1:nrow(teamSpecialDates)) {
  team <- teamSpecialDates$Teams[i]
  specialDate <- teamSpecialDates$SpecialDates[i]
  
  # Handle TBD special dates (specialDate == 0)
  
  # Regex to match variables for the specific team and special date
  regexPattern <- paste0("^x\\.", team, "\\..*\\.", specialDate, "\\..*")
  
  # Find indices of matching variables in namesOfVariables
  indicesToModify <- grep(regexPattern, namesOfVariables)
  
  # Update the objective function with a weight of 5
  objectiveFunction[indicesToModify] <- 5
}
# Set variables as binary
for (var in 1:length(namesOfVariables)) {
    set.type(LP, var, "binary")
}


```

```{r}

set.objfn(LP, objectiveFunction)

# Set optimization sense (maximize or minimize)
lp.control(LP,sense='max')

# Apply constraints row by row
for (rowCounter in 1:NROW(constraintMatrix)) {
  set.row(LP, rowCounter, as.numeric(constraintMatrix[rowCounter, ]))
  set.constr.type(LP, inequalities[rowCounter, 1], rowCounter)
  set.rhs(LP, rightHandSide[rowCounter, 1], rowCounter)
}
maxNodes = 10000000
setwd(coinRDir)
write.lp(LP, 'problem.mps', type='mps')
system(paste0("cbc.exe problem.mps maxN ",maxNodes," solve solution LPSolution.txt exit"))

```

```{r}
# Extract the solution vector

#coinOrCbcSolutionParser = function('LPSolution.txt',namesOfVariables){
dataFromCoinOrCBC = data.frame(read.table(text=readLines("/Users/segnitulu/Desktop/CBC/Cbc-2.3.2-mac-osx-x86_64-gcc4.3.3-parallel/bin/LPSolution.txt")[count.fields("/Users/segnitulu/Desktop/CBC/Cbc-2.3.2-mac-osx-x86_64-gcc4.3.3-parallel/bin/LPSolution.txt") == 4]))
partialSolutionLocations = dataFromCoinOrCBC$V2
partialSolutionValues = dataFromCoinOrCBC$V3
partialSolutionLocations= gsub("C","",partialSolutionLocations)
partialSolutionLocations = as.numeric(partialSolutionLocations)
fullSolutionVector = rep(0,length(namesOfVariables))
for(ii in 1:length(partialSolutionLocations)){
  fullSolutionVector[partialSolutionLocations[ii]] = partialSolutionValues[ii]
}
names(fullSolutionVector) = namesOfVariables
# return(fullSolutionVector)
# }
fullSolutionVector = as.matrix(fullSolutionVector)
fullSolutionVector = t(fullSolutionVector)
solutionVector = colnames(fullSolutionVector) [which(fullSolutionVector[1,] == 1)]

#Solution
solutionVector
solutionVectorFirstHalf  = solutionVector
# Men's schedule
scheduleMen = matrix("", nrow = length(namesOfMensTeams), ncol = length(playDates[,2]))
row.names(scheduleMen) = namesOfMensTeams
colnames(scheduleMen) = as.character(as_date(ymd(playDates[,2])))

# Populate men's schedule
for (t1 in namesOfMensTeams) {
  for (t2 in namesOfMensTeams) {
    if (t1 != t2) { # Avoid self-matches
      for (date in numericDates) {
        dayOfWeek = wday(as.Date(date, origin = lubridate::origin))
        
        # Check for home match
        newVariableHome = paste("x", t1, t2, date, dayOfWeek, "Men", sep = ".")
        if (newVariableHome %in% solutionVector) {
          scheduleMen[t2, as.character(as_date(date))] = paste0("@ ", t1)
        }
        
        # Check for away match
        newVariableAway = paste("x", t2, t1, date, dayOfWeek, "Men", sep = ".")
        if (newVariableAway %in% solutionVector) {
          scheduleMen[t2, as.character(as_date(date))] = paste0("v ", t1)
        }
      }
    }
  }
}

# Women's schedule
scheduleWomen = matrix("", nrow = length(namesOfWomensTeams), ncol = length(playDates[,2]))
row.names(scheduleWomen) = namesOfWomensTeams
colnames(scheduleWomen) = as.character(as_date(playDates[,2]))

# Populate women's schedule
for (t1 in namesOfWomensTeams) {
  for (t2 in namesOfWomensTeams) {
    if (t1 != t2) { # Avoid self-matches
      for (date in numericDates) {
        dayOfWeek = wday(as.Date(date, origin = lubridate::origin))
        # Check for home match
        newVariableHome = paste("x", t1, t2, date, dayOfWeek, "Women", sep = ".")
        if (newVariableHome %in% solutionVector) {
          scheduleWomen[t2, as.character(as_date(date))] = paste0("@ ", t1)
        }
        
        # Check for away match
        newVariableAway = paste("x", t2, t1, date, dayOfWeek, "Women", sep = ".")
        if (newVariableAway %in% solutionVector) {
          scheduleWomen[t2, as.character(as_date(date))] = paste0("v ", t1)
        }
      }
    }
  }
}

# View schedules
View(scheduleMen)
View(scheduleWomen)

# Save schedules to CSV files
write.csv(scheduleMen, file = mensCSV, row.names = TRUE)
write.csv(scheduleWomen, file = womensCSV, row.names = TRUE)

```
