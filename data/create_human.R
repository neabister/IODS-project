library(stringr)
library(dplyr)
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


#CHAPTER 5 DATA WRANGLING STARTS FROM HERE

#Transform GNI column to numeric (making new column named GNI)
joined_data <- mutate(joined_data, GNI = str_replace(joined_data$Gross.National.Income..GNI..per.Capita, pattern = ',', replace = '') %>% as.numeric)
#Checking it looks like it should
joined_data$GNI
dim(joined_data)

#Exclude extra columns

cols_to_keep <- c('Country', 'edu2_FM_ratio', 'lab_FM_ratio', 'Expected.Years.of.Education', 'Life.Expectancy.at.Birth', 'GNI', 'Maternal.Mortality.Ratio',
                  'Adolescent.Birth.Rate', 'Labour.Force.Participation.Rate..Female.')
data_columns <- dplyr::select(joined_data, which=one_of(cols_to_keep))

#Rename columns with shorter names (because didnt understand earlier to do it...)
names(data_columns) <- c('Country', 'Edu2.FM', 'Labo.FM', 'Edu.Exp', 'Life.Exp', 'GNI', 'Mat.Mor', 'Ado.Birth', 'Parli.F')

#Remova NAs

complete_data <- filter(data_columns, complete.cases(data_columns) == TRUE)

#Remove regions, I assume the only regions are the last 7 as was shown in DataCamp exercise... I dont think there is a good way to figure them out
#Other than just going through one by one...

last_7 <- nrow(complete_data) - 7
complete_data <- complete_data[1:last_7,]
dim(complete_data)

#Countries as rownames

rownames(complete_data) <- complete_data$Country
complete_data <- dplyr::select(complete_data, -Country)

dim(complete_data)

#For reason I don't understand, I seem to have one extra row in final data... thus, I will use the ready made data for the analysis.
