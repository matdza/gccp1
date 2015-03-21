#Start the program 
#Clean my dir
rm(list=ls());

#Include Packages  if required
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Getting and loading the activity labels text file
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Getting and loadinf data column namaes
features <- read.table("./UCI HAR Dataset/features.txt")[,2]


#Getting Mean and standard deviation  for each measurement
extract_features <- grepl("mean|std", features)


#  getting y and  x test data 
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Get mean and standard deviation for each measurement.
X_test = X_test[,extract_features]

# Get activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Data Binding
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# getting and processing X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# getting standard and deviation and mean
X_train = X_train[,extract_features]

# Loading  activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Data Binding
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Mergeing  test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Applying the  mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
#Write tidy data to a file
write.table(tidy_data, file = "./tidy_data.txt",row.names=FALSE)
