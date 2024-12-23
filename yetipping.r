---
title: "Project_GNAC_Soccer"
author: "Segni"
date: "2024-11-23"
output: html_document
---

#-----------------------------------------------------------------------------------------------------------------
# R Markdown Setup
#-----------------------------------------------------------------------------------------------------------------
```{r setup, include=FALSE}
# Set knitr options to show R code in the output document
knitr::opts_chunk$set(echo = TRUE)

# Define paths for the main project file and CBC solver directory
mainfile = "/Users/segnitulu/Library/Mobile Documents/com~apple~CloudDocs/R Shared folder/GNAC_Soccer_Project"
coinRDir = "/Users/segnitulu/Desktop/CBC/Cbc-2.3.2-mac-osx-x86_64-gcc4.3.3-parallel/bin"

# Set the working directory to the main project folder
setwd(mainfile)

# Load necessary libraries for linear programming, Excel file handling, and date manipulation
library(lpSolve)
library(lpSolveAPI)
library(readxl)
library(lubridate)

```

#-----------------------------------------------------------------------------------------------------------------
# Setting schedule Parameters
#-----------------------------------------------------------------------------------------------------------------
```{r}
# prep file names for outputs
  mensCSV = paste("men_schedule",
                  ".csv",
                  sep = "_")
  womensCSV = paste("women_schedule",
                  ".csv",
                  sep = "_")
  
```

#----------------------------------------------------------------------------------------------------------------
# Helper Functions
#----------------------------------------------------------------------------------------------------------------
```{r}
# Function to generate a constraint for the scheduling problem
generateConstraint = function(regexList, valueList, ineq, rhs) {
  # Initialize a new constraint matrix row with zeros
  newConstraint <- matrix(0, 1, length(namesOfVariables))
  colnames(newConstraint) <- namesOfVariables
  
  # Modify the constraint matrix based on provided regex patterns
  for(ii in 1:length(regexList)) {
    regex <- regexList[ii]
    indicesToModify <- grep(pattern = regex, namesOfVariables)
    newConstraint[indicesToModify] <- valueList[ii]
  }
  
  # Update global constraint matrices and counters
  constraintMatrix[newRowCounter,] <<- newConstraint
  inequalities[newRowCounter,1] <<- ineq
  rightHandSide[newRowCounter,1] <<- rhs
  newRowCounter <<- newRowCounter + 1
}

# Function to remove empty constraints from the model
cleanUpModel = function() {
  whereIsZero <- which(abs(constraintMatrix) %*% matrix(1, ncol(constraintMatrix), 1) == 0)
  if(length(whereIsZero) > 0) {
    constraintMatrix <<- constraintMatrix[-whereIsZero, ]
    inequalities <<- inequalities[-whereIsZero, , drop = FALSE]
    rightHandSide <<- rightHandSide[-whereIsZero, , drop = FALSE]
  }
}

# Function to add padding rows to the model matrices
padModel = function(numberOfRowsToAdd) {
  oldNumberOfConstraints <- nrow(constraintMatrix)
  constraintMatrix <<- rbind(constraintMatrix, matrix(0, numberOfRowsToAdd, ncol(constraintMatrix)))
  inequalities <<- rbind(inequalities, matrix("", numberOfRowsToAdd, 1))
  rightHandSide <<- rbind(rightHandSide, matrix(0, numberOfRowsToAdd, 1))
  nrc <- oldNumberOfConstraints + 1
  return(nrc)
}

# Function to get opponents for a given team based on a matchup matrix
getOppenents = function(m, team) {
  allteams = colnames(m)
  teamRow = allteams[which(m[team, ] == "1")]
  print(teamRow)
  return(teamRow)
}

```

#----------------------------------------------------------------------------------------------------------------
# Reading Data and Creating Lists
#----------------------------------------------------------------------------------------------------------------
```{r}
# Read all sheet names from the Excel file
excel_sheets("GNAC_Soccer.xlsx") 


# Read men's teams, women's teams, and play dates from the Excel file
MenTeams <-read_excel("GNAC_Soccer.xlsx",  
                       sheet = "TeamsMens")
WomenTeams<-read_excel("GNAC_Soccer.xlsx",  
                       sheet = "TeamsWomens")
Dates_Men <-read_excel("GNAC_Soccer.xlsx", 
                       sheet = "2025Dates_Men") 
Dates_Women <-read_excel("GNAC_Soccer.xlsx", 
                       sheet = "2025Dates_Women") 


  

# Convert teams and dates into matrices and extract team names
menTeams = as.matrix(MenTeams)
namesOfMensTeams = menTeams[,1]

womenTeams = as.matrix(WomenTeams)
namesOfWomensTeams = womenTeams[,1]

playDates = as.matrix(Dates)
numericDates = as.numeric(ymd(playDates[,2]))

womensPlayDates = as.matrix(Dates_Women)
womenNumericDates = as.numeric(ymd(womensPlayDates[,2]))
```

#----------------------------------------------------------------------------------------------------------------
# Creating Variables
#----------------------------------------------------------------------------------------------------------------
```{r}
# Initialize an empty list to store variable names
namesOfVariables = c()

# Exclude "SMU" from men's teams and create a schedule for remaining teams
filteredTeams <- setdiff(menTeams, "SMU")
menPlayList1 <- vector(mode = 'list', length = length(filteredTeams))
names(menPlayList1) <- filteredTeams

# Populate men's team schedule by excluding self-matchups
for (team in filteredTeams) {
  menPlayList1[[team]] <- setdiff(filteredTeams, team)
}

# Repeat the process for women's teams
womenPlayList1 <- vector(mode = 'list', length = length(womenTeams))
names(womenPlayList1) <- womenTeams

for (team in womenTeams) {
  womenPlayList1[[team]] <- setdiff(womenTeams, team)
}

# Generate variables for men's matchups
for(t1 in namesOfMensTeams) {
  opponents = menPlayList1[[t1]]
  for(t2 in opponents) {
    for(dateNumber in numericDates) {
      dayOfWeek = wday(as.Date(dateNumber, origin = lubridate::origin))
      newVariable = paste("x", t1, t2, dateNumber, dayOfWeek, "Men", sep = ".")
      namesOfVariables = c(namesOfVariables, newVariable)
    }
  }
}

# Generate variables for women's matchups
for(t1 in namesOfWomensTeams) {
  opponents = womenPlayList1[[t1]]
  for(t2 in opponents) {
    for(dateNumber in womenNumericDates) {
      dayOfWeek = wday(as.Date(dateNumber, origin = lubridate::origin))
      newVariable = paste("x", t1, t2, dateNumber, dayOfWeek, "Women", sep = ".")
      namesOfVariables = c(namesOfVariables, newVariable)
    }
  }
}

#Variables for bye constraint (Men only)
for(t in namesOfMensTeams){
  for(date in numericDates){
    newVariable = paste("b",t,date, "Men", sep = ".")
    namesOfVariables = c(namesOfVariables, newVariable)
  }
}

#Variables for bye constraint (Women only)
for(t in namesOfWomensTeams){
  for(date in womenNumericDates){
    newVariable = paste("b",t,date, "Women", sep = ".")
    namesOfVariables = c(namesOfVariables, newVariable)
  }
}

```

#----------------------------------------------------------------------------------------------------------------
# Constraints and Matrix Setup
#----------------------------------------------------------------------------------------------------------------

# Creating a constraint matrix to define linear programming constraints
# The matrix will have rows added dynamically as constraints are formulated
```{r}
constraintMatrix = matrix(0, 0, length(namesOfVariables))
colnames(constraintMatrix) = namesOfVariables  # Setting column names to match decision variables
inequalities = matrix("", 0, 1)  # Matrix to store inequality operators (e.g., <=, >=, =)
rightHandSide = matrix(0, 0, 1)  # Matrix to store the RHS values of constraints

```

#----------------------------------------------------------------------------------------------------------------
# Constraint 1. EACH TEAM SHOULD PLAY ONCE PER AVAILABLE DATE
#----------------------------------------------------------------------------------------------------------------

# ONLY ONE GAME PER TEAM ON EACH PLAY DATE
# Separate constraints are created for men's and women's teams
# For each date and team, ensure a team either plays as home or away, but not both

```{r}
# Men's constraints
newRowCounter = padModel(numberOfRowsToAdd = length(numericDates) * length(namesOfMensTeams))  # Add rows for all date-team combinations
for (date in numericDates) {
  for (t in namesOfMensTeams) {
    regexList = c(
      paste("^x", t, ".*", date, ".*", "Men", sep = "\\."),  # Matches home games for the team on the date
      paste("^x", ".*", t, date, ".*", "Men", sep = "\\."),   # Matches away games for the team on the date
      paste("b" , t, date, "Men", sep = "\\.")
    )
    valueList = c(1, 1,1)  # Coefficients for home and away games
    newIneq = "="  # At most one game per team per date
    newRhs = 1  # RHS is 1 since a team plays at most once on any given date
    generateConstraint(regexList, valueList, newIneq, newRhs)
  }
}
cleanUpModel()

# Women's constraints
newRowCounter = padModel(numberOfRowsToAdd = length(numericDates) * length(namesOfWomensTeams))  # Similar logic for women's teams
for (date in womenNumericDates) {
  for (t in namesOfWomensTeams) {
    regexList = c(
      paste("^x", t, ".*", date, ".*", "Women", sep = "\\."),
      paste("^x", ".*", t, date, ".*", "Women", sep = "\\."),
      paste("b" , t, date, "Women", sep = "\\.")

    )
    valueList = c(1, 1,1)
    newIneq = "="
    newRhs = 1
    generateConstraint(regexList, valueList, newIneq, newRhs)
  }
}
cleanUpModel()

```

#----------------------------------------------------------------------------------------------------------------
# Constraint 2. TEAM GAMES PER SEASON
#----------------------------------------------------------------------------------------------------------------

# Ensure each team plays a specific number of games in a season (12 for men's, 13 for women's)

```{r}
# Men's play 12 games per season
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams))
for (t in namesOfMensTeams) {
  regexList = c(
    paste("^x", t, ".*", ".*", ".*", "Men", sep = "\\."),  # Matches all home games for the team
    paste("^x", ".*", t, ".*", ".*", "Men", sep = "\\.")   # Matches all away games for the team
  )
  valueList = rep(1, length(regexList))  # Coefficients for the games
  newIneq = "="  # Equality constraint since total games must be exactly 12
  newRhs = 12
  generateConstraint(regexList, valueList, newIneq, newRhs)
}
cleanUpModel()

# Women's play 13 games per season
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams))
for (t in namesOfWomensTeams) {
  regexList = c(
    paste("^x", t, ".*", ".*", ".*", "Women", sep = "\\."),
    paste("^x", ".*", t, ".*", ".*", "Women", sep = "\\.")
  )
  valueList = rep(1, length(regexList))
  newIneq = "="
  newRhs = 13
  generateConstraint(regexList, valueList, newIneq, newRhs)
}
cleanUpModel()

```

#----------------------------------------------------------------------------------------------------------------
# Constraint 3. MINIMUM HOME AND AWAY GAMES PER SEASON
#----------------------------------------------------------------------------------------------------------------

# Ensure each team plays at least 5 home and 5 away games in a season

```{r}
# Men's home games
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams))
for (t in namesOfMensTeams) {
  regexList = c(paste("^x", t, ".*", ".*", ".*", "Men", sep = "\\."))
  valueList = rep(1, length(regexList))  # Coefficients for home games
  newIneq = ">="
  newRhs = 4
  generateConstraint(regexList, valueList, newIneq, newRhs)
}
cleanUpModel()

# Men's away games
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams))
for (t in namesOfMensTeams) {
  regexList = c(paste("^x", ".*", t, ".*", ".*", "Men", sep = "\\."))
  valueList = rep(1, length(regexList))  # Coefficients for away games
  newIneq = ">="
  newRhs = 4
  generateConstraint(regexList, valueList, newIneq, newRhs)
}
cleanUpModel()

#Women's home games
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams))
for(t in namesOfWomensTeams){
  regexList = c(paste("^x",t,".*",".*",".*","Women",sep = "\\."))
  valueList = rep(1, length(regexList))
  newIneq = ">="
  newRhs = 4
  generateConstraint(regexList,valueList,newIneq,newRhs)
}
cleanUpModel()

#Women's away games
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams))
for(t in namesOfWomensTeams){
  regexList = c(paste("^x",".*",t,".*",".*","Women",sep = "\\."))
  valueList = rep(1, length(regexList))
  newIneq = ">="
  newRhs = 4
  generateConstraint(regexList,valueList,newIneq,newRhs)
}
cleanUpModel()

```


```{r}
# Men's home game constraints
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams) * (length(numericDates) -2) ) # Allocate rows for constraints
for (t in namesOfMensTeams) {  # Iterate through all men's teams
  for (i in 1:(length(numericDates) - 2)) {  # Check all possible 4-day sequences
    # Assign 4 consecutive dates
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    date3 = numericDates[i+2]

    # Create regex patterns to match home games on each date for the team
    regexList = c(
            paste("b" , t, date1, "Men", sep = "\\."),
            paste("b" , t, date2, "Men", sep = "\\."),
            paste("b" , t, date3, "Men", sep = "\\.")

    )

    # Coefficients for each game in the sequence
    valueList = rep(1, length(regexList))

    # Define the inequality (at most 3 consecutive home games)
    newIneq = "<="
    newRhs = 2
    generateConstraint(regexList, valueList, newIneq, newRhs)  # Apply the constraint
  }
}

cleanUpModel()  # Finalize the model by removing unused rows

```

#----------------------------------------------------------------------------------------------------------------
# Constraint 4: NO MORE THAN THREE CONSECUTIVE HOME OR AWAY GAMES
#----------------------------------------------------------------------------------------------------------------

# Ensure that no team (Men's or Women's) has more than three consecutive home games in a season.
# This is achieved by iterating through all possible 4-day sequences in the schedule and applying constraints.

```{r}
# Men's home game constraints
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams) * (length(numericDates) - 4))  # Allocate rows for constraints
for (t in namesOfMensTeams) {  # Iterate through all men's teams
  for (i in 1:(length(numericDates) - 4)) {  # Check all possible 4-day sequences
    # Assign 4 consecutive dates
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    date3 = numericDates[i+2]
    date4 = numericDates[i+3]
    date5 = numericDates[i+4]


    # Create regex patterns to match home games on each date for the team
    regexList = c(
      paste("^x", t, ".*", date1, ".*", "Men", sep = "\\."),
            # paste("b" , t, date1, "Men", sep = "\\."),
      paste("^x", t, ".*", date2, ".*", "Men", sep = "\\."),
            # paste("b" , t, date2, "Men", sep = "\\."),
      paste("^x", t, ".*", date3, ".*", "Men", sep = "\\."),
            # paste("b" , t, date3, "Men", sep = "\\."),
       paste("^x", t, ".*", date4, ".*", "Men", sep = "\\."),
            # paste("b" , t, date4, "Men", sep = "\\."),
       paste("^x", t, ".*", date5, ".*", "Men", sep = "\\.")
            # paste("b" , t, date5, "Men", sep = "\\.")

    )

    # Coefficients for each game in the sequence
    valueList = rep(1, length(regexList))

    # Define the inequality (at most 3 consecutive home games)
    newIneq = "<="
    newRhs = 3
    generateConstraint(regexList, valueList, newIneq, newRhs)  # Apply the constraint
  }
}

cleanUpModel()  # Finalize the model by removing unused rows

# Women's home game constraints
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams) * (length(womenNumericDates) - 3))  # Allocate rows for constraints
for (t in namesOfWomensTeams) {  # Iterate through all women's teams
  for (i in 1:(length(womenNumericDates) - 3)) {  # Check all possible 4-day sequences
    # Assign 4 consecutive dates
    date1 = womenNumericDates[i]
    date2 = womenNumericDates[i+1]
    date3 = womenNumericDates[i+2]
    date4 = womenNumericDates[i+3]

    # Create regex patterns to match home games on each date for the team
    regexList = c(
      paste("^x", t, ".*", date1, ".*", "Women", sep = "\\."),
            # paste("b" , t, date1, "Women", sep = "\\."),
      paste("^x", t, ".*", date2, ".*", "Women", sep = "\\."),
            # paste("b" , t, date2, "Women", sep = "\\."),
      paste("^x", t, ".*", date3, ".*", "Women", sep = "\\."),
            # paste("b" , t, date3, "Women", sep = "\\."),
      paste("^x", t, ".*", date4, ".*", "Women", sep = "\\.")
            # paste("b" , t, date4, "Women", sep = "\\.")

    )

    # Coefficients for each game in the sequence
    valueList = rep(1, length(regexList))

    # Define the inequality (at most 3 consecutive home games)
    newIneq = "<="
    newRhs = 3
    generateConstraint(regexList, valueList, newIneq, newRhs)  # Apply the constraint
  }
}

cleanUpModel()

```

#------FOR MEN AND WOMEN AWAY GAME-------
```{r}
# Men's away game constraints
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfMensTeams) * (length(numericDates) - 4))  # Allocate rows for constraints
for (t in namesOfMensTeams) {  # Iterate through all men's teams
  for (i in 1:(length(numericDates) - 4)) {  # Check all possible 4-day sequences
    # Assign 4 consecutive dates
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    date3 = numericDates[i+2]
    date4 = numericDates[i+3]
    date5 = numericDates[i+4]


    # Create regex patterns to match away games on each date for the team
    regexList = c(
      paste("^x", ".*", t, ".*", date1, ".*", "Men", sep = "\\."),
          # paste("b" , t, date1, "Men", sep = "\\."),
      paste("^x", ".*", t, ".*", date2, ".*", "Men", sep = "\\."),
          # paste("b" , t, date2, "Men", sep = "\\."),
      paste("^x", ".*", t, ".*", date3, ".*", "Men", sep = "\\."),
          # paste("b" , t, date3, "Men", sep = "\\."),
      paste("^x", ".*", t, ".*", date4, ".*", "Men", sep = "\\."),
          # paste("b" , t, date4, "Men", sep = "\\."),
      paste("^x", ".*", t, ".*", date5, ".*", "Men", sep = "\\.")
          # paste("b" , t, date5, "Men", sep = "\\.")
    )

    # Coefficients for each game in the sequence
    valueList = rep(1, length(regexList))

    # Define the inequality (at most 3 consecutive away games)
    newIneq = "<="
    newRhs = 3
    generateConstraint(regexList, valueList, newIneq, newRhs)  # Apply the constraint
  }
}

cleanUpModel()  # Finalize the model by removing unused rows

# Women's away game constraints
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams) * (length(womenNumericDates) - 3))  # Allocate rows for constraints
for (t in namesOfWomensTeams) {  # Iterate through all women's teams
  for (i in 1:(length(womenNumericDates) - 3)) {  # Check all possible 4-day sequences
    # Assign 4 consecutive dates
    date1 = womenNumericDates[i]
    date2 = womenNumericDates[i+1]
    date3 = womenNumericDates[i+2]
    date4 = womenNumericDates[i+3]

    # Create regex patterns to match away games on each date for the team
    regexList = c(
      paste("^x", ".*", t, ".*", date1, ".*", "Women", sep = "\\."),
          # paste("b" , t, date1, "Women", sep = "\\."),
      paste("^x", ".*", t, ".*", date2, ".*", "Women", sep = "\\."),
          # paste("b" , t, date2, "Women", sep = "\\."),
      paste("^x", ".*", t, ".*", date3, ".*", "Women", sep = "\\."),
          # paste("b" , t, date3, "Women", sep = "\\."),
      paste("^x", ".*", t, ".*", date4, ".*", "Women", sep = "\\.")
          # paste("b" , t, date4, "Women", sep = "\\.")
    )

    # Coefficients for each game in the sequence
    valueList = rep(1, length(regexList))

    # Define the inequality (at most 3 consecutive away games)
    newIneq = "<="
    newRhs = 3
    generateConstraint(regexList, valueList, newIneq, newRhs)  # Apply the constraint
  }
}

cleanUpModel()

```

#----------------------------------------------------------------------------------------------------------------
# Constraint 5. ONLY PLAY WITH ONE OPPONENT ONCE PER SEASON
#----------------------------------------------------------------------------------------------------------------

# Ensure that each pair of teams plays only once per season.

```{r}
# Men's teams
newRowCounter = padModel(length(namesOfMensTeams) * length(namesOfMensTeams))  # Allocate rows for constraints
for (n1 in 1:(length(namesOfMensTeams) - 1)) {
  for (n2 in (n1 + 1):length(namesOfMensTeams)) {  # Iterate through all unique team pairs
    t1 = namesOfMensTeams[n1]
    t2 = namesOfMensTeams[n2]
    regexList = c()
    for (date in numericDates) {  # Create regex for all dates
      regexList = c(regexList,
                    paste("^x", t1, t2, date, ".*", "Men", sep = "\\."),
                    paste("^x", t2, t1, date, ".*", "Men", sep = "\\."))
    }
    # Coefficients for each game
    valueList = rep(1, length(regexList))
    # Define the equality (exactly 1 game between each pair)
    newIneq = "="
    newRhs = 1
    generateConstraint(regexList, valueList, newIneq, newRhs)  # Apply the constraint
  }
}

cleanUpModel()

# Women's teams
newRowCounter = padModel(length(namesOfWomensTeams) * length(namesOfWomensTeams))  # Allocate rows for constraints
for (n1 in 1:(length(namesOfWomensTeams) - 1)) {
  for (n2 in (n1 + 1):length(namesOfWomensTeams)) {  # Iterate through all unique team pairs
    t1 = namesOfWomensTeams[n1]
    t2 = namesOfWomensTeams[n2]
    regexList = c()
    for (date in womenNumericDates) {  # Create regex for all dates
      regexList = c(regexList,
                    paste("^x", t1, t2, date, ".*", "Women", sep = "\\."),
                    paste("^x", t2, t1, date, ".*", "Women", sep = "\\."))
    }
    # Coefficients for each game
    valueList = rep(1, length(regexList))
    # Define the equality (exactly 1 game between each pair)
    newIneq = "="
    newRhs = 1
    generateConstraint(regexList, valueList, newIneq, newRhs)  # Apply the constraint
  }
}

cleanUpModel()

```


#Tuesday/Wednesday Constraint
```{r}
newRowCounter = padModel(length(namesOfMensTeams) * (length(numericDates)-1))  # Allocate rows for constraints
# Loop to enforce constraints based on dayOfWeek (Tuesday and Wednesday)
for (t in namesOfMensTeams) {  # Iterate through all men's teams
  for (i in 1:(length(numericDates) - 1)) {  # Check all consecutive day pairs
    # Assign two consecutive dates
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    
    # Determine dayOfWeek for the dates
    dayOfWeek1 = wday(as.Date(date1, origin = lubridate::origin))
    dayOfWeek2 = wday(as.Date(date2, origin = lubridate::origin))

    # Only consider Tuesday (3) and Wednesday (4) pairs
    if (dayOfWeek1 == 3 && dayOfWeek2 == 4) {
      # Create regex patterns to match games on each date for the team
      regexList = c(
        paste("^x", t, ".*", date1, dayOfWeek1, "Men", sep = "\\."),
        paste("^x", ".*", t, date1, dayOfWeek1, "Men", sep = "\\."),
        paste("^x", t, ".*", date2, dayOfWeek2, "Men", sep = "\\."),       
        paste("^x", ".*", t, date2, dayOfWeek2, "Men", sep = "\\.")
      )
      
      # Coefficients for Tuesday-Wednesday pair
    valueList = rep(1, length(regexList))

      # Define the equality constraint (sum of Tuesday and Wednesday games = 1)
      newIneq = "<="
      newRhs = 1
      generateConstraint(regexList, valueList, newIneq, newRhs)  # Apply the constraint
    }
  }
}
cleanUpModel()

newRowCounter = padModel(length(namesOfWomensTeams) *(length(womenNumericDates)-1))  # Allocate rows for constraints
# Loop to enforce constraints based on dayOfWeek (Tuesday and Wednesday)
for (t in namesOfWomensTeams) {  # Iterate through all men's teams
  for (i in 1:(length(womenNumericDates) - 1)) {  # Check all consecutive day pairs
    # Assign two consecutive dates
    date1 = womenNumericDates[i]
    date2 = womenNumericDates[i+1]
    
    # Determine dayOfWeek for the dates
    dayOfWeek1 = wday(as.Date(date1, origin = lubridate::origin))
    dayOfWeek2 = wday(as.Date(date2, origin = lubridate::origin))

    # Only consider Tuesday (3) and Wednesday (4) pairs
    if (dayOfWeek1 == 3 && dayOfWeek2 == 4) {
      # Create regex patterns to match games on each date for the team
      regexList = c(
        paste("^x", t, ".*", date1, dayOfWeek1, "Women", sep = "\\."),
        paste("^x", ".*", t, date1, dayOfWeek1, "Women", sep = "\\."),
        paste("^x", t, ".*", date2, dayOfWeek2, "Women", sep = "\\."),
        paste("^x", ".*", t, date2, dayOfWeek2, "Women", sep = "\\.")
      )
      
      # Coefficients for Tuesday-Wednesday pair
    valueList = rep(1, length(regexList))

      # Define the equality constraint (sum of Tuesday and Wednesday games = 1)
      newIneq = "<="
      newRhs = 1
      generateConstraint(regexList, valueList, newIneq, newRhs)  # Apply the constraint
    }
  }
}
cleanUpModel()
```
#-----------------------------------------------------------------------------------------------------------------
# LP Solve
#-----------------------------------------------------------------------------------------------------------------
```{r}
# Create LP object
LP = make.lp(NROW(constraintMatrix), NCOL(constraintMatrix))

# Load the SpecialDates sheet
# This sheet contains team-specific special dates to be accounted for in the scheduling.
specialDates <- read_excel("GNAC_Soccer.xlsx", sheet = "SpecialDates")

# Extract relevant columns (Teams and SpecialDates)
# Ensures only necessary data is retained for processing.
teamSpecialDates <- as.data.frame(specialDates[, c("Teams", "SpecialDates")])

# Convert special dates to numeric format for matching (if applicable)
# Helps standardize the date format for comparisons and processing.
teamSpecialDates$SpecialDates <- as.numeric(ymd(teamSpecialDates$SpecialDates))

# Initialize the objective function
# Objective function values are initially set to zero and later updated based on criteria.
objectiveFunction <- matrix(0, 1, length(namesOfVariables))
colnames(objectiveFunction) <- namesOfVariables

# Loop through each team and its special dates
# Assigns higher weights to special dates for prioritization in scheduling.
for (i in 1:nrow(teamSpecialDates)) {
  team <- teamSpecialDates$Teams[i]
  specialDate <- teamSpecialDates$SpecialDates[i]
  
  # Handle TBD special dates (specialDate == 0)
  # A placeholder for any specific logic regarding unassigned dates.

  # Regex to match variables for the specific team and special date
  regexPattern <- paste0("^x\\.", team,  ".*", specialDate ,".*",  ".*")
  
  # Find indices of matching variables in namesOfVariables
  indicesToModify <- grep(regexPattern, namesOfVariables)
  
  # Update the objective function with a weight of 5
  # Prioritizes scheduling based on the matched special dates.
  objectiveFunction[indicesToModify] <- 5
}

# Set variables as binary
# All decision variables are binary, representing yes/no outcomes in the LP model.
for (var in 1:length(namesOfVariables)) {
    set.type(LP, var, "binary")
}
```

#-----------------------------------------------------------------------------------------------------------------
# Define and Solve LP
#-----------------------------------------------------------------------------------------------------------------

```{r}
# Set the objective function
# Configures the LP model to use the specified objective function.
set.objfn(LP, objectiveFunction)

# Set optimization sense (maximize or minimize)
# Determines whether to maximize or minimize the objective function.
lp.control(LP, sense = 'max')

# Apply constraints row by row
# Sequentially loads constraints into the LP model based on the defined constraint matrix.
for (rowCounter in 1:NROW(constraintMatrix)) {
  set.row(LP, rowCounter, as.numeric(constraintMatrix[rowCounter, ]))
  set.constr.type(LP, inequalities[rowCounter, 1], rowCounter)
  set.rhs(LP, rightHandSide[rowCounter, 1], rowCounter)
}

# Export LP problem to MPS format
# Saves the problem in a standard format for external solvers like CBC.
maxNodes = 10000000
setwd(coinRDir)
write.lp(LP, 'problem.mps', type = 'mps')

# Solve the LP using CBC
# Executes CBC solver with a node limit and outputs the solution to a file.
# system(paste0("cbc problem.mps maxN ", maxNodes, " solve solution LPSolution.txt exit"))

```

#-----------------------------------------------------------------------------------------------------------------
# Extract and Parse Solution
#-----------------------------------------------------------------------------------------------------------------

```{r}

# Read and process the solution vector from the CBC solver output
dataFromCoinOrCBC <- data.frame(read.table(
  text = readLines("/Users/segnitulu/Desktop/CBC/Cbc-2.3.2-mac-osx-x86_64-gcc4.3.3-parallel/bin/LPSolution.txt")[count.fields("/Users/segnitulu/Desktop/CBC/Cbc-2.3.2-mac-osx-x86_64-gcc4.3.3-parallel/bin/LPSolution.txt") == 4]
))
partialSolutionLocations <- dataFromCoinOrCBC$V2
partialSolutionValues <- dataFromCoinOrCBC$V3

# Map solution indices to variables
# Converts solver indices into variable names for interpretation.
partialSolutionLocations <- gsub("C", "", partialSolutionLocations)
partialSolutionLocations <- as.numeric(partialSolutionLocations)
fullSolutionVector <- rep(0, length(namesOfVariables))
for (ii in 1:length(partialSolutionLocations)) {
  fullSolutionVector[partialSolutionLocations[ii]] <- partialSolutionValues[ii]
}
names(fullSolutionVector) <- namesOfVariables

# Transform the solution vector into a matrix for analysis
fullSolutionVector <- as.matrix(fullSolutionVector)
fullSolutionVector <- t(fullSolutionVector)
solutionVector <- colnames(fullSolutionVector)[which(fullSolutionVector[1, ] == 1)]

# Extract and organize schedules for men's and women's teams
# Formats and populates schedules for easier analysis and export.
scheduleMen <- matrix("", nrow = length(namesOfMensTeams), ncol = length(playDates[, 2]))
row.names(scheduleMen) <- namesOfMensTeams
colnames(scheduleMen) <- as.character(as_date(ymd(playDates[, 2])))

# Populate men's schedule with home and away matches
for (t1 in namesOfMensTeams) {
  for (t2 in namesOfMensTeams) {
    if (t1 != t2) { # Avoid self-matches
      for (date in numericDates) {
        dayOfWeek <- wday(as.Date(date, origin = lubridate::origin))
        
        # Check for home match
        newVariableHome <- paste("x", t1, t2, date, dayOfWeek, "Men", sep = ".")
        if (newVariableHome %in% solutionVector) {
          scheduleMen[t1, as.character(as_date(date))] <- paste0("v ", t2)
        }
        
        # Check for away match
        newVariableAway <- paste("x", t2, t1, date, dayOfWeek, "Men", sep = ".")
        if (newVariableAway %in% solutionVector) {
          scheduleMen[t1, as.character(as_date(date))] <- paste0("@ ", t2)
        }
      }
    }
  }
}

# Repeat the same process for women's schedule
scheduleWomen <- matrix("", nrow = length(namesOfWomensTeams), ncol = length(playDates[, 2]))
row.names(scheduleWomen) <- namesOfWomensTeams
colnames(scheduleWomen) <- as.character(as_date(playDates[, 2]))
for (t1 in namesOfWomensTeams) {
  for (t2 in namesOfWomensTeams) {
    if (t1 != t2) { # Avoid self-matches
      for (date in womenNumericDates) {
        dayOfWeek <- wday(as.Date(date, origin = lubridate::origin))
        
        # Check for home match
        newVariableHome <- paste("x", t1, t2, date, dayOfWeek, "Women", sep = ".")
        if (newVariableHome %in% solutionVector) {
          scheduleWomen[t1, as.character(as_date(date))] <- paste0("v ", t2)
        }
        
        # Check for away match
        newVariableAway <- paste("x", t2, t1, date, dayOfWeek, "Women", sep = ".")
        if (newVariableAway %in% solutionVector) {
          scheduleWomen[t1, as.character(as_date(date))] <- paste0("@ ", t2)
        }
      }
    }
  }
}


# View schedules in R and save them to CSV files
View(scheduleMen)
View(scheduleWomen)

mensCSV <- "/Users/segnitulu/Library/Mobile Documents/com~apple~CloudDocs/R Shared folder/GNAC_Soccer_Project/mens_schedule.csv"
womensCSV <- "/Users/segnitulu/Library/Mobile Documents/com~apple~CloudDocs/R Shared folder/GNAC_Soccer_Project/womens_schedule.csv"

write.csv(scheduleMen, file = mensCSV, row.names = TRUE)
write.csv(scheduleWomen, file = womensCSV, row.names = TRUE)

```