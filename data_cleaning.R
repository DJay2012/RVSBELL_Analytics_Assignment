library(readxl)
library(dplyr)
library(lubridate)

#Loading the dataset
df <- read_excel("Employees data.xlsx", sheet = "Employees data")

##Checking data
head(df)

#Missing Values Handling
df$Name[is.na(df$Name)] <- "Unknown"
df$Department[is.na(df$Department)] <- "Unassigned"
df$Salary[is.na(df$Salary)] <- mean(df$Salary, na.rm = TRUE)
df <- df[!is.na(df$Age) & !is.na(df$DOB), ]

#Column Format Stnadardization
df$DOB <- as.Date(df$DOB)
df$`Joining Date` <- as.Date(df$`Joining Date`)
df$`Performance Score` <- as.factor(df$`Performance Score`)

#New Columns
df$Tenure <- as.integer(difftime(Sys.Date(), df$`Joining Date`, units = "weeks") / 52.25)
df$`Experience Level` <- cut(df$Tenure, 
                             breaks = c(-Inf, 1, 5, 10, Inf),
                             labels = c("New", "Junior", "Mid", "Senior"))

#Saving the cleaned dataset
write.csv(df, "cleaned_employees.csv", row.names = FALSE)
