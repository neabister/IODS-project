#human developmental index -> life achievements
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

#gender inequality index -> gender inequality
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Data dimensions
dim(hd)
dim(gii)
#Data structures
str(hd)
str(gii)
#Data summaries
summary(hd)
summary(gii)

#New descriptive names, I think abbreviatiations are clear and better to use this short names
hdi_data <- hd
gii_data <- gii

#Check that length of unique values in Country column is same as number of rows in the data set -> each row represent different country
length(unique(gii_data$Country))

#Mutations: ratio of edu2F / edu2M (females/males with 2ndary education)
#ratio of labF / labM (females/males with labour force participation)

gii_data <- mutate(gii_data, edu2_FM_ratio = Population.with.Secondary.Education..Female. / Population.with.Secondary.Education..Male.)
gii_data <- mutate(gii_data, lab_FM_ratio = Labour.Force.Participation.Rate..Female. /  Labour.Force.Participation.Rate..Male.)
head(gii_data)

#Join two datasets
joined_data <- inner_join(gii_data, hdi_data, by = c('Country'))
dim(joined_data)
head(joined_data)

#Save data
write.csv(joined_data, 'data/human.csv', row.names = FALSE)


#Test read
test <- read.csv('data/human.csv')
head(test)
dim(test)