# Nea Bister 11.8.2019 
# Chapter 2: Regression and model validation - Data wrangling

#Read data file
data <- read.table('http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt', sep='\t', header=TRUE)

#Import required libraries
library(dplyr)

#Explore data
dim(data)
str(data)

#Data has 60 columns (variables) and 183 rows (observations). All but one variable are integers. One is factor with 2 levels for gender

#Exclude observations with 0 Points
data_with_points <- filter(data, Points != 0)

#Scale attitude (division by 10) although it was not clearly instructed in the exercise but in example wrangled data it seems to be so...
data_with_points$attitude = data_with_points$Attitude / 10

#Create new analysis dataset df that contains only gender, age, attitude and points

keep_columns <- c('gender', 'Age', 'attitude', 'Points')
analysis_dataset <- select(data_with_points, one_of(keep_columns))

#Change all column names to lower case
colnames_lower <- c()

for(i in colnames(analysis_dataset)) {
  lower_case <- tolower(i)
  colnames_lower <- c(colnames_lower, lower_case)
}

colnames_lower
colnames(analysis_dataset) <- colnames_lower


#Group questions to deep, stra and surf
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
stra_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
surf_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")

#Select columns by groups
deep_columns <- select(data_with_points, one_of(deep_questions))
stra_columns <- select(data_with_points, one_of(stra_questions))
surf_columns <- select(data_with_points, one_of(surf_questions))

#Calculate row means and add column to analysis dataset df
analysis_dataset$deep <- rowMeans(deep_columns)
analysis_dataset$stra <- rowMeans(stra_columns)
analysis_dataset$surf <- rowMeans(surf_columns)


#Check that everything is right
dim(analysis_dataset)
head(analysis_dataset)

#Write final analysis dataset as csv
write.csv(analysis_dataset, file = 'data/analysis_dataset.csv', row.names = FALSE)

#Test that file is easily readable and correct
test_read = read.csv('data/analysis_dataset.csv')

head(test_read)
str(test_read)
dim(test_read)