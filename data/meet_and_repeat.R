library(dplyr)
library(tidyr)


#Read data into df
BPRS <- read.csv('https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt', sep=' ')
RATS <- read.csv('https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt', sep='\t')

#See that it looks ok
head(BPRS)
head(RATS)
dim(BPRS)
dim(RATS)

#Explore structures

str(BPRS)
str(RATS)

#In both data sets, each row represents one subject (e.g. individual rats). Measured outcome values at different time-points are given in separate columns
#Currently both data sets consist of only integer values but actually "subject" and "treatment" in BPRS and "ID" and "Group" variables in RATS are categorical

#Converting categorical variables to factors

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

str(BPRS)
str(RATS)

#Save data in short format

write.csv(RATS, 'data/rats_short.csv')
write.csv(BPRS, 'data/bprs_short.csv')

#Convert datasets to long format for the analysis with gather()

BPRSL <- gather(BPRS, key = weeks, value = bprs, -treatment, -subject)
RATSL <- gather(RATS, key = days, value = weight, -ID, -Group)

glimpse(BPRSL)
glimpse(RATSL)

#In long format data, subjects are on rows but each subject has separate row for each analyzed timepoint

#I want to already make weeks and days numeric for BPRSL and RATSL, respectively to enable drawing graphs

BPRSL <- mutate(BPRSL, week = substr(BPRSL$weeks, 5, 5))
RATSL <- mutate(RATSL, day = substr(RATSL$days, 3, 4))

#Lets drop old time-point columns too

BPRSL <- dplyr::select(BPRSL, -weeks)
RATSL <- dplyr::select(RATSL, -days)

head(BPRSL)
head(RATSL)

#Save datasets for analysis part

write.csv(BPRSL, 'data/BPRSL.csv', row.names = FALSE)
write.csv(RATSL, 'data/RATSL.csv', row.names = FALSE)