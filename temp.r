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

#-------------------------------------------------------------------
# Directories and Libraries
#-------------------------------------------------------------------

# Set the working directory to the main project folder
mainfile = "/Users/segnitulu/Library/Mobile Documents/com~apple~CloudDocs/R Shared folder/GNAC_Soccer_Project"
setwd(mainfile)

library(lpSolve)
library(lpSolveAPI)
library(readxl)
library(lubridate)
```
## GNAC

GNAC stands for Great Northwest Athletic Conference, a collegiate athletic conference affiliated with the NCAA's Division II. Founded in 2001, GNAC includes schools primarily located in the northwestern United States and western Canada. Member institutions compete in a variety of sports, ranging from basketball and soccer to cross country and track & field.

## Problem Constraints and Parameterization

The objective of this problem is to create an optimized scheduling system for soccer teams within the GNAC Conference, where the teams are divided into men's and women's teams. The main goal is to assign matchups between teams such that each team plays once per available date, either as a home team or an away team. The solution must adhere to the constraint that no team plays multiple games on the same day.

The model also accounts for various elements:

T: Set of teams (both men's and women's).
D: Set of available play dates.
G: Set of genders (men's and women's teams).
Tt: Set of specific teams to be matched with each team in the season.
Xt1,t2,d,w(d),g: Binary decision variable representing if teamt1 hosts or visits team t2 on date d, where w(d) is the day of the week.

In this model:
  - X t1,t2,d,w(d),Men’s is 1 if men's team t1 hosts team t2 on date d, and 0 otherwise.
  - X t2,t1,d,w(d),Men’s is 1 if men's team t2 hosts team t1 on date d, and 0 otherwise.
  - Similarly, there is an analogous variable for women's teams.

The constraints of the model ensure that each team plays only one game on any given date and that all teams must be scheduled to play at least once in the season.

#----------------------------------------------------------------------------------------------------------------
# SETTING SCHEDULE PARAMETERS
#----------------------------------------------------------------------------------------------------------------
```{r}

mensMinHomeGames = 8
womensMinHomeGames = 9
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

#----------------------------------------------------------------------------------------------------------------
# Helper Functions
#----------------------------------------------------------------------------------------------------------------
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

#----------------------------------------------------------------------------------------------------------------
# Reading Data and Creating Lists
#----------------------------------------------------------------------------------------------------------------
```{r}
excel_sheets("GNAC_Soccer.xlsx") 


MenTeams <-read_excel("GNAC_Soccer.xlsx",  
                       sheet = "TeamsMens")
WomenTeams<-read_excel("GNAC_Soccer.xlsx",  
                       sheet = "TeamsWomens")
Dates <-read_excel("GNAC_Soccer.xlsx", 
                       sheet = "2025Dates") 

maxNodes = 100000

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


Model Creation: Creating Variables
In the model creation phase, we define the decision variables used for scheduling:

Xt1,t2,d,w(d),g: Binary variable indicating whether a match is scheduled between team t1 and team t2 on date d for gender g.
These variables will help track which teams play each other and whether they are the home or away team.

#----------------------------------------------------------------------------------------------------------------
# Creating Variables
#----------------------------------------------------------------------------------------------------------------
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


Constraint Formulation and Matrix Setup
The core of the scheduling model involves the formulation of constraints to ensure that each team plays exactly once per date and either hosts or visits another team. These constraints will be set up in matrix form to be incorporated into the optimization model.

Matrix Setup for Constraints:
1. Men's Teams: For each men’s team t1, the sum of all variables indicating whether the team hosts or is hosted by another team on each available date should equal 1.
2. Women's Teams: For each women’s team t1, the sum of all variables indicating whether the team hosts or is hosted by another team on each available date should equal 1.

#----------------------------------------------------------------------------------------------------------------
# Constraints and Matrix Setup
#----------------------------------------------------------------------------------------------------------------
```{r}
#Creating constraint matrix
constraintMatrix = matrix(0,0,length(namesOfVariables))
colnames(constraintMatrix) = namesOfVariables
inequalities = matrix("",0,1)
rightHandSide = matrix(0,0,1)

```

#----------------------------------------------------------------------------------------------------------------
# Constraint 1. EACH TEAM SHOULD PLAY ONCE PER AVAILABLE DATE
#----------------------------------------------------------------------------------------------------------------
```{r}
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
    newIneq = "="
    newRhs = 1
    generateConstraint(regexList,valueList,newIneq,newRhs)
  }
}
#Women need equal to since they need to fill out all games
newRowCounter = padModel(numberOfRowsToAdd = length(numericDates) * length(namesOfWomensTeams))

for(date in numericDates){
  for(t in namesOfWomensTeams){
    regexList = c(paste("^x",t,".*",date,".*","Women",sep = "\\."),
                  paste("^x",".*",t,date,".*","Women",sep = "\\."))
    valueList = c(1,
                  1)
    newIneq = "="
    newRhs = 1
    generateConstraint(regexList,valueList,newIneq,newRhs)
  }
}

cleanUpModel()
```

#----------------------------------------------------------------------------------------------------------------
# Constraint 2. No two teams should play each other more than once per season
#----------------------------------------------------------------------------------------------------------------

```{r}
# newRowCounter = padModel(numberOfRowsToAdd = choose(length(namesOfMensTeams), 2))  # Number of team pairs

# Pad the constraint matrix for the new constraints
numTeams = length(namesOfMensTeams)
numDates = length(numericDates)
newRowCounter = padModel(numberOfRowsToAdd = numTeams * (numTeams - 1))

# Print the dimensions of constraintMatrix and newRowCounter for debugging
print(dim(constraintMatrix))  # Check the current dimensions of the matrix
print(newRowCounter)          # Check the row counter value before assignment


for (t1 in namesOfMensTeams) {
  for (t2 in namesOfMensTeams) {
    if (t1 != t2) { # Avoid self-matching
      # Regex patterns for matches between t1 and t2
      regexList = c(
        paste("^x", t1, t2, ".*", "Men", sep = "\\."),  # t1 hosts t2
        paste("^x", t2, t1, ".*", "Men", sep = "\\.")   # t2 hosts t1
      )
      valueList = c(1, 1)  # Count both home and away matches
      newIneq = "<="
      newRhs = 1  # At most one match per season
      generateConstraint(regexList, valueList, newIneq, newRhs)
    }
  }
}

# Pad the constraint matrix for the new constraints
numTeams = length(namesOfWomensTeams)
numDates = length(numericDates)
newRowCounter = padModel(numberOfRowsToAdd = numTeams * (numTeams - 1))

# Print the dimensions of constraintMatrix and newRowCounter for debugging
print(dim(constraintMatrix))  # Check the current dimensions of the matrix
print(newRowCounter)          # Check the row counter value before assignment
# 
# # Repeat for women's teams
# newRowCounter = padModel(numberOfRowsToAdd = choose(length(namesOfWomensTeams), 2))

for (t1 in namesOfWomensTeams) {
  for (t2 in namesOfWomensTeams) {
    if (t1 != t2) { # Avoid self-matching
      regexList = c(
        paste("^x", t1, t2, ".*", "Women", sep = "\\."),  # t1 hosts t2
        paste("^x", t2, t1, ".*", "Women", sep = "\\.")   # t2 hosts t1
      )
      valueList = c(1, 1)  # Count both home and away matches
      newIneq = "<="
      newRhs = 1  # At most one match per season
      generateConstraint(regexList, valueList, newIneq, newRhs)
    }
  }
}
```

```{r}

feasibilityCheck <- function(namesOfVariables, constraintMatrix, inequalities, rightHandSide) {
  print(paste("Total Variables:", length(namesOfVariables)))
  print(paste("Total Constraints:", nrow(constraintMatrix)))
  print("Checking feasibility...")
  # Use a basic solver or manually test variable assignments to ensure all constraints can be satisfied.
  testSolution <- matrix(0, nrow=1, ncol=length(namesOfVariables))
  colnames(testSolution) <- namesOfVariables
  for (i in 1:nrow(constraintMatrix)) {
    lhs <- sum(constraintMatrix[i, ] * testSolution)
    if ((inequalities[i] == "=" && lhs != rightHandSide[i]) ||
        (inequalities[i] == "<=" && lhs > rightHandSide[i]) ||
        (inequalities[i] == ">=" && lhs < rightHandSide[i])) {
      print(paste("Constraint failed at row:", i))
      return(FALSE)
    }
  }
  print("Feasibility check passed.")
  return(TRUE)
}


```


The objective of the scheduling model is to maximize the satisfaction coefficients for every special date a team requests to play at home.
#----------------------------------------------------------------------------------------------------------------
# LP Solve
#----------------------------------------------------------------------------------------------------------------
```{r}
# Create Linear Programming (LP) object
LP = make.lp(NROW(constraintMatrix), NCOL(constraintMatrix))

# Load the SpecialDates sheet from the Excel file
specialDates <- read_excel("GNAC_Soccer.xlsx", sheet = "SpecialDates")

# Extract relevant columns: Teams and their associated SpecialDates
teamSpecialDates <- as.data.frame(specialDates[, c("Teams", "SpecialDates")])

# Convert SpecialDates to numeric format for easier matching (if applicable)
teamSpecialDates$SpecialDates <- as.numeric(ymd(teamSpecialDates$SpecialDates))

# Initialize the objective function with zeros
objectiveFunction <- matrix(0, 1, length(namesOfVariables))
colnames(objectiveFunction) <- namesOfVariables

# Loop through each team and its associated special dates to adjust the objective function
for (i in 1:nrow(teamSpecialDates)) {
  team <- teamSpecialDates$Teams[i]            # Current team
  specialDate <- teamSpecialDates$SpecialDates[i]  # Associated special date
  
  # Handle cases where the special date is undefined (e.g., specialDate == 0)
  
  # Construct a regex pattern to match variables for the team and special date
  regexPattern <- paste0("^x\\.", team, "\\..*\\.", specialDate, "\\..*")
  
  # Identify indices of matching variables in namesOfVariables
  indicesToModify <- grep(regexPattern, namesOfVariables)
  
  # Assign a weight of 5 to the matching variables in the objective function
  objectiveFunction[indicesToModify] <- 5
}

# Set the objective function in the LP model
set.objfn(LP, objectiveFunction)

# Define the optimization goal (maximize or minimize)
lp.control(LP, sense = 'max')

# Apply constraints to the LP model, row by row
for (rowCounter in 1:NROW(constraintMatrix)) {
  set.row(LP, rowCounter, as.numeric(constraintMatrix[rowCounter, ]))  # Set constraint coefficients
  set.constr.type(LP, inequalities[rowCounter, 1], rowCounter)        # Define the constraint type
  set.rhs(LP, rightHandSide[rowCounter, 1], rowCounter)               # Set the RHS value for the constraint
}

# Export the LP problem to an MPS file
write.lp(LP, "problem.mps", type = "mps")

# Run CBC solver using system call
maxNodes <- 1000  # Set your maxNodes value
system(paste0("cbc problem.mps maxN ", maxNodes, " solve solution.txt exit"))

# Read the CBC solution
cbc_solution <- readLines("solution.txt")
print(cbc_solution)

# Now you can use the solution to extract the optimal solution vector
# Assuming the solution vector is in the "solution.txt" file or a similar format
# Example of how to parse the solution if CBC outputs the solution in a standard format
solutionVector <- grep("^x", cbc_solution, value = TRUE)

# Generate the schedule for men's teams
scheduleMen = matrix("", nrow = length(namesOfMensTeams), ncol = length(playDates[, 2]))
row.names(scheduleMen) = namesOfMensTeams
colnames(scheduleMen) = as.character(as_date(ymd(playDates[, 2])))

# Populate the men's schedule matrix with match information
for (t1 in namesOfMensTeams) {
  for (t2 in namesOfMensTeams) {
    if (t1 != t2) { # Avoid scheduling matches against the same team
      for (date in numericDates) {
        dayOfWeek = wday(as.Date(date, origin = lubridate::origin))  # Determine the day of the week
        
        # Check if there's a home match for t1
        newVariableHome = paste("x", t1, t2, date, dayOfWeek, "Men", sep = ".")
        if (newVariableHome %in% solutionVector) {
          scheduleMen[t2, as.character(as_date(date))] = paste0("@ ", t1)  # Mark as away match for t2
        }
        
        # Check if there's an away match for t1
        newVariableAway = paste("x", t2, t1, date, dayOfWeek, "Men", sep = ".")
        if (newVariableAway %in% solutionVector) {
          scheduleMen[t2, as.character(as_date(date))] = paste0("v ", t1)  # Mark as home match for t2
        }
      }
    }
  }
}

# Generate the schedule for women's teams
scheduleWomen = matrix("", nrow = length(namesOfWomensTeams), ncol = length(playDates[, 2]))
row.names(scheduleWomen) = namesOfWomensTeams
colnames(scheduleWomen) = as.character(as_date(playDates[, 2]))

# Populate the women's schedule matrix with match information
for (t1 in namesOfWomensTeams) {
  for (t2 in namesOfWomensTeams) {
    if (t1 != t2) { # Avoid scheduling matches against the same team
      for (date in numericDates) {
        dayOfWeek = wday(as.Date(date, origin = lubridate::origin))  # Determine the day of the week
        
        # Check if there's a home match for t1
        newVariableHome = paste("x", t1, t2, date, dayOfWeek, "Women", sep = ".")
        if (newVariableHome %in% solutionVector) {
          scheduleWomen[t2, as.character(as_date(date))] = paste0("@ ", t1)  # Mark as away match for t2
        }
        
        # Check if there's an away match for t1
        newVariableAway = paste("x", t2, t1, date, dayOfWeek, "Women", sep = ".")
        if (newVariableAway %in% solutionVector) {
          scheduleWomen[t2, as.character(as_date(date))] = paste0("v ", t1)  # Mark as home match for t2
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
