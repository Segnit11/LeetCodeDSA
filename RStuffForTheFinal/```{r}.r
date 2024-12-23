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
            paste("b" , t, date1, "Men", sep = "\\."),
      paste("^x", t, ".*", date2, ".*", "Men", sep = "\\."),
            paste("b" , t, date2, "Men", sep = "\\."),
      paste("^x", t, ".*", date3, ".*", "Men", sep = "\\."),
            paste("b" , t, date3, "Men", sep = "\\."),
       paste("^x", t, ".*", date4, ".*", "Men", sep = "\\."),
            paste("b" , t, date4, "Men", sep = "\\."),
       paste("^x", t, ".*", date5, ".*", "Men", sep = "\\."),
            paste("b" , t, date5, "Men", sep = "\\.")

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
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams) * (length(numericDates) - 3))  # Allocate rows for constraints
for (t in namesOfWomensTeams) {  # Iterate through all women's teams
  for (i in 1:(length(numericDates) - 3)) {  # Check all possible 4-day sequences
    # Assign 4 consecutive dates
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    date3 = numericDates[i+2]
    date4 = numericDates[i+3]

    # Create regex patterns to match home games on each date for the team
    regexList = c(
      paste("^x", t, ".*", date1, ".*", "Women", sep = "\\."),
            paste("b" , t, date1, "Women", sep = "\\."),
      paste("^x", t, ".*", date2, ".*", "Women", sep = "\\."),
            paste("b" , t, date2, "Women", sep = "\\."),
      paste("^x", t, ".*", date3, ".*", "Women", sep = "\\."),
            paste("b" , t, date3, "Women", sep = "\\."),
      paste("^x", t, ".*", date4, ".*", "Women", sep = "\\."),
            paste("b" , t, date4, "Women", sep = "\\.")

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
          paste("b" , t, date1, "Men", sep = "\\."),
      paste("^x", ".*", t, ".*", date2, ".*", "Men", sep = "\\."),
          paste("b" , t, date2, "Men", sep = "\\."),
      paste("^x", ".*", t, ".*", date3, ".*", "Men", sep = "\\."),
          paste("b" , t, date3, "Men", sep = "\\."),
      paste("^x", ".*", t, ".*", date4, ".*", "Men", sep = "\\."),
          paste("b" , t, date4, "Men", sep = "\\."),
      paste("^x", ".*", t, ".*", date5, ".*", "Men", sep = "\\."),
          paste("b" , t, date5, "Men", sep = "\\.")
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
newRowCounter = padModel(numberOfRowsToAdd = length(namesOfWomensTeams) * (length(numericDates) - 3))  # Allocate rows for constraints
for (t in namesOfWomensTeams) {  # Iterate through all women's teams
  for (i in 1:(length(numericDates) - 3)) {  # Check all possible 4-day sequences
    # Assign 4 consecutive dates
    date1 = numericDates[i]
    date2 = numericDates[i+1]
    date3 = numericDates[i+2]
    date4 = numericDates[i+3]

    # Create regex patterns to match away games on each date for the team
    regexList = c(
      paste("^x", ".*", t, ".*", date1, ".*", "Women", sep = "\\."),
          paste("b" , t, date1, "Women", sep = "\\."),
      paste("^x", ".*", t, ".*", date2, ".*", "Women", sep = "\\."),
          paste("b" , t, date2, "Women", sep = "\\."),
      paste("^x", ".*", t, ".*", date3, ".*", "Women", sep = "\\."),
          paste("b" , t, date3, "Women", sep = "\\."),
      paste("^x", ".*", t, ".*", date4, ".*", "Women", sep = "\\."),
          paste("b" , t, date4, "Women", sep = "\\.")
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