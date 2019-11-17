#Nea Bister 14.11.2019 data wrangling
#Joining together dataset from Math and Portuguese language course participants for analysis exercise in Chapter 3
#Data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

#Read math and portuguese course data
math <- read.csv('data/student-mat.csv', sep=';')
por <- read.csv('data/student-por.csv', sep=';')

#Explore data
str(math)
str(por)

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



ready_data <- read.csv('http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/alc.txt', sep=',')
