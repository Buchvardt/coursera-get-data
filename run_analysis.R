#Setup
library("tidyverse")

#Explore dir
# > list.dirs()
# [1] "."                                        "./UCI HAR Dataset"                        "./UCI HAR Dataset/test"                  
# [4] "./UCI HAR Dataset/test/Inertial Signals"  "./UCI HAR Dataset/train"                  "./UCI HAR Dataset/train/Inertial Signals"

#consult with ./UCI HAR Dataset/REAdME.txt

#read activity that maps to label
activity <- read.csv2("./UCI HAR Dataset/activity_labels.txt", sep = " ", header = FALSE)
colnames(activity) <- c("label", "activity")
activity$activity <- tolower(activity$activity)

#read features
features <- read.csv2("./UCI HAR Dataset/features.txt", sep = " ", header = FALSE)
colnames(features) <- c("col_index", "name")

#get indicies of features with mean or std
feat_indicies <- grep("-mean[()]|-std[()]", features$name)

# Load train --------------------------------------------------------------

#read train subsetting inly std and mean
train <- read.table("./UCI HAR Dataset/train/X_train.txt")[ ,feat_indicies]

#renaming train columns
names(train) <- features[feat_indicies, "name"]

#read train labels
train_labels <- read.table("./UCI HAR Dataset/train/Y_train.txt")
colnames(train_labels) <- "label"

#join activity with train_labels
train_labels <- inner_join(train_labels, activity) %>% select(activity)

#cbind with train
train <- cbind(train, train_labels)

# Load test _--------------------------------------------------------------

#read test subsetting only std and mean
test <- read.table("./UCI HAR Dataset/test/X_test.txt")[ ,feat_indicies]

#renaming train columns
names(test) <- features[feat_indicies, "name"]

#read train labels
test_labels <- read.table("./UCI HAR Dataset/test/Y_test.txt")
colnames(test_labels) <- "label"

#join activity with test_labels
test_labels <- inner_join(test_labels, activity) %>% select(activity)

#cbind with train
test <- cbind(test, test_labels)


# rbind train and test ----------------------------------------------------
tidy_data <- rbind(train, test)




# Group by subject and activity -------------------------------------------

#create a second, independent tidy data set with the average of each variable 
#for each activity and each subject.

#read in train and test subjects
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#rbind in same order as above train+test
all_subjects <- rbind(train_subjects, test_subjects)
colnames(all_subjects) <- "subject"

#cbind with tidy_data
analysis_data <- cbind(tidy_data, all_subjects)


#group by subject and activity then summarise mean of each column
analysis_data <- analysis_data %>% group_by(subject, activity) %>% summarise_all(funs(mean))
