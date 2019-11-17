#Nea Bister 14.11.2019 data wrangling
#Joining together dataset from Math and Portuguese language course participants for analysis exercise in Chapter 3
#Data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

#Read math and portuguese course data
math <- read.csv('data/student-mat.csv', sep=';')
por <- read.csv('data/student-por.csv', sep=';')

#Explore data
str(math)
str(por)

head(math)
head(por)
dim(math)
dim(por)

#Join datasets

library(dplyr)

#Identifier columns

identifiers <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
joined_data <- inner_join(math, por, by = identifiers, suffix = c('.math', '.por'))

colnames(joined_data)
glimpse(joined_data)

#Select and generate df from only selected identifiers

alc <- select(joined_data, one_of(identifiers))

dim(alc)
str(alc)

#Columns not used for joining (now duplicate columns  in joined_data coming from both por and math data sets)

not_joined <- colnames(math)[!colnames(math) %in% identifiers]
not_joined

#Combine duplicate columns from math and por datasets to have only one value for each variable, if numeric take average, if string, take first

for(column_name in  not_joined) {
  #make a vector of vectors having same initial name e.g. math
  columns <- select(joined_data, starts_with(column_name))
  #select first column to test if it is numeric, if yes, take rowMean and round it, if not (else), take first value (from math dataset)
  #append values to alc df that only had columns that were used for inner joining
  first_column <- select(columns, 1)[[1]]
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(columns))
  } else {
    alc[column_name] <- first_column
  }
}

glimpse(alc)
dim(alc)

#Dalc = weekday consumption, Walc = weekend consumption, add column (alc_use) of average of Dalc and Walc 

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
dim(alc)

#high_use TRUE if alc_use > 2, FALSE if <= 2

alc <- mutate(alc, high_use = alc_use > 2)

#Glimpse to check everything is correct (compare to the final dataframe provided)
glimpse(alc)

ready_data <- read.csv('http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/alc.txt', sep=',')
dim(ready_data)
glimpse(ready_data)

#Save the final df to .csv

write.csv(alc, 'data/create_alc.csv', row.names = FALSE)

#Test read

test <- read.csv('data/create_alc.csv')
head(test)
dim(test)