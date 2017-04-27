


# Packages 
library(reshape2)

# Download and unzip data
setwd("~/data science/Coursera/Data_Science_Spe/course3")

download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "getdata-projectfiles-UCI HAR Dataset.zip", 
              method = "curl")

unzip(zipfile = "getdata-projectfiles-UCI HAR Dataset.zip")



## test part
# Get list of activity by merging y_test.txt and activity_labels.txt
activ_file = paste("UCI HAR Dataset",  "activity_labels.txt", sep = "/")
y_test_file = paste("UCI HAR Dataset", "test", "y_test.txt",        sep = "/")

activ <- read.table(file = activ_file, col.names = c("id", "activity"))
y_test <- read.table(file = y_test_file, col.names = c("id"))

activ_merge_test <- merge(activ, y_test, by.x="id", by.y="id")
activ_merge_test <- activ_merge_test[,c("activity"), drop = FALSE]

# Get a list of all subjects
subject_file = paste("UCI HAR Dataset", "test", "subject_test.txt", sep = "/")
subject_test <- read.table(file = subject_file,col.names = c("Subject"))

# get a list of the features in a vector so it can be used with col.names
feature_file = paste("UCI HAR Dataset", "features.txt", sep ="/")
features  <- read.table(file = feature_file, col.names = c("f.id", "f.name"))
features  <- features[,2]

# Now, all the features are column names for the X_test file 
x_test_file <- paste("UCI HAR Dataset", "test", "X_test.txt", sep = "/")
x_test <- read.table(file = x_test_file,col.names = features)


# Put all the above in one dataframe. 
test_combined <- cbind(subject_test, activ_merge_test, x_test)



## train part
# Get list of activity by merging y_train.txt and activity_labels.txt

y_train_file = paste("UCI HAR Dataset", "train", "y_train.txt", sep = "/")
y_train <- read.table(file = y_train_file, col.names = c("id"))

activ_merge_train <- merge(activ, y_train, by.x="id", by.y="id")
activ_merge_train <- activ_merge_train[,2, drop = FALSE]

# Get a list of all subjects
subject_file = paste("UCI HAR Dataset", "train", "subject_train.txt", sep = "/")
subject_train <- read.table(file = subject_file, col.names = c("Subject"))

# Now, all the features are column names for the X_trainfile 
x_train_file <- paste("UCI HAR Dataset", "train", "X_train.txt", sep = "/")
x_train <- read.table(file = x_train_file, col.names = features)

colnames(activ_merge_test)
# Put all the above in one dataframe. 
train_combined <- cbind(subject_train, activ_merge_train, x_train)




## Common part
# Combine test and train _combined
complete_data <- rbind(test_combined, train_combined) 


# Extracts only the measurements on the mean and standard deviation for each measurement.
# Use REGEXP
mean_std_cols <- grep("mean|std", colnames(complete_data), value=TRUE)
data_mean_std <- complete_data[,c("Subject","activity",mean_std_cols)]



# From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.
second_data_set <- melt(data_mean_std, id.vars=c("Subject","activity"))

