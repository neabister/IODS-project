data <- read.csv('data/analysis_dataset.csv')
head(data)

library(dplyr)
library(bestNormalize)

#Transform variables
age_transformed <- predict(bestNormalize(data$age, allow_orderNorm = FALSE, out_of_sample = FALSE))
attitude_transformed <- predict(bestNormalize(data$attitude, allow_orderNorm = FALSE, out_of_sample = FALSE))
surf_transformed <- predict(bestNormalize(data$surf, allow_orderNorm = FALSE, out_of_sample = FALSE))
stra_transformed <- predict(bestNormalize(data$stra, allow_orderNorm = FALSE, out_of_sample = FALSE))
deep_transformed <- predict(bestNormalize(data$deep, allow_orderNorm = FALSE, out_of_sample = FALSE))
points_transformed <- predict(bestNormalize(data$points, allow_orderNorm = FALSE, out_of_sample = FALSE))

transformations <- c(age_transformed, attitude_transformed, surf_transformed, stra_transformed, deep_transformed, points_transformed)

data_transformed <- bind_cols(original = data, age_transf = age_transformed, attitude_transf = attitude_transformed, points_transf = points_transformed, 
                              deep_transf = deep_transformed, stra_transf = stra_transformed, surf_transf = surf_transformed)

head(data_transformed)

keep_columns <- c('gender', 'age_transf', 'attitude_transf', 'points_transf', 'deep_transf', 'stra_transf', 'surf_transf')
transformed_df <- select(data_transformed, one_of(keep_columns))
head(transformed_df)

library(ggplot2)
library(GGally)

p <- ggpairs(transformed_df, title = "Transformed data", mapping = aes(alpha = 0.4), 
             lower = list(combo = wrap('facethist', bins = 20)))

p

original_data <- ggpairs(data, title = "Original data", mapping = aes(alpha = 0.4), 
                          lower = list(combo = wrap('facethist', bins = 20)))
original_data
#Find best transformation method
#best <- bestNormalize(data$attitude, allow_orderNorm = FALSE, out_of_sample = FALSE)
#best

#Perform transformation (Box cox is best)
#box_cox_attitude <- predict(best)
#box_cox_attitude

#Perform reverse transformation
#attitude2 <- predict(best, newdata = box_cox_attitude, inverse = TRUE)
#attitude2

#Prove the transformation is 1:1
#all.equal(attitude2, data$attitude)

#Histogram from transformed attitude
#MASS::truehist(attitude2)

#data_transformed$test_transf <- box_cox_attitude
#data_transformed

a = "col1"
b = "col2"
d = data.frame(a=c(1,2,3),b=c(4,5,6))

d

names(d) <- c(a,b)

d

d$col1 + 1

d[, a] + 1

d$newCol = d$col1 + 1

d

d$newNewCol = d[, a] + 1

d

stringcol <- c('newCol')
d[, stringcol]