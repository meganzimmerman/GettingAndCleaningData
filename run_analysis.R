# Getting and Cleaning Data
# Week 4 Programming Assignment

setwd("R:/Earthquake/Hazard/Users/MTorpey/Coursera_DataScienceCertification/GettingAndCleaningData")

library(dplyr)

# Info about dataset here:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity
# +Recognition+Using+Smartphones
zipURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Download the zip file from the web
download.file(zipURL,destfile = "ProjectData.zip")

# Extract the files from the zip into a 'ProjectData' directory
# Once extracted, the data are housed within the 'UCI HAR Dataset'
# directory. Within this directory is
# the following directories: test, train
# the following flat files: features.txt, features_info.txt, activity_labels.txt, and README.txt
unzip("ProjectData.zip",exdir="ProjectData")

# CD into unzipped directory
setwd("ProjectData//UCI HAR Dataset")

##############################################################
# 1. Merge the training and train sets to create one data set
#    30% of participant data is in testing set and 70% is in training set

test_df <-read.table("test//X_test.txt",  header=FALSE,stringsAsFactors = FALSE)
test_lbl<-read.table("test//y_test.txt", header=FALSE,stringsAsFactors = FALSE)
test_sub<-read.table("test//subject_test.txt",header=FALSE,stringsAsFactors = FALSE)
#test_accel_tot <-read.table("test//Inertial Signals//total_acc_x_test.txt",header=FALSE,stringsAsFactors = FALSE)
#test_accel_body<-read.table("test//Inertial Signals//body_acc_x_test.txt",header=FALSE,stringsAsFactors = FALSE)
#test_veloc     <-read.table("test//Inertial Signals//body_gyro_x_test.txt",header=FALSE,stringsAsFactors = FALSE)

train_df <-read.table("train//X_train.txt",header=FALSE,stringsAsFactors = FALSE)
train_lbl<-read.table("train//y_train.txt",header=FALSE,stringsAsFactors = FALSE)
train_sub<-read.table("train//subject_train.txt",header=FALSE,stringsAsFactors = FALSE)
#train_accel_tot <-read.table("train//Inertial Signals//total_acc_x_train.txt",header=FALSE,stringsAsFactors = FALSE)
#train_accel_body<-read.table("train//Inertial Signals//body_acc_x_train.txt",header=FALSE,stringsAsFactors = FALSE)
#train_veloc     <-read.table("train//Inertial Signals//body_gyro_x_train.txt",header=FALSE,stringsAsFactors = FALSE)

# Bind feature vectors, labels, subjects, accel_tot, accel_body, veloc (body_gyro) 
data_df    <-rbind(train_df,test_df)

label_vec  <-rbind(train_lbl,test_lbl)
subject_vec<-rbind(train_sub,test_sub)
#accel_tot  <-rbind(train_accel_tot,test_accel_tot)
#accel_body <-rbind(train_accel_body,test_accel_body)
#veloc      <-rbind(train_veloc,test_veloc)

data_df$label     <-as.vector(label_vec)
data_df$subject   <-as.integer(unlist((subject_vec)))
#data_df$accel_tot <-as.vector(accel_tot)
#data_df$accel_body<-as.vector(accel_body)
#data_df$veloc     <-as.vector(veloc)


######################################################################################
# 2. Extract only the measurements on the mean and standard deviation for each measurement
#    Read features.txt which contains the info about each of the 561 values in the feature vector
features<-read.table("features.txt",header=FALSE,stringsAsFactors = FALSE)

# Replace headers
names(data_df)[1:NROW(features)]<-features$V2
mean_cols<-grep("mean",names(data_df))
stdv_cols<-grep("std", names(data_df))

# Get columns that are for mean, std, and final 2 columns added earlier with label and subject
extracted_df<-data_df[,c(mean_cols,stdv_cols,562,563)]


######################################################################################
# 3. Use descriptive activity names to name the activities in the data set
#   Activity labels links the class labels to the activity name
activity_labels<-read.table("activity_labels.txt",header=FALSE,stringsAsFactors = FALSE)
extracted_df$activitylabel<-0
# It's better to use merge for this, but since it's only 6 labels we can do it manually
extracted_df[which(extracted_df$label==1),]$activitylabel<- activity_labels[1,2]
extracted_df[which(extracted_df$label==2),]$activitylabel<- activity_labels[2,2]
extracted_df[which(extracted_df$label==3),]$activitylabel<- activity_labels[3,2]
extracted_df[which(extracted_df$label==4),]$activitylabel<- activity_labels[4,2]
extracted_df[which(extracted_df$label==5),]$activitylabel<- activity_labels[5,2]
extracted_df[which(extracted_df$label==6),]$activitylabel<- activity_labels[6,2]

######################################################################################
# 4. Appropriately label the data set with descriptive variable names
names(extracted_df)<-gsub("Acc","Accelerometer",names(extracted_df))
names(extracted_df)<-gsub("Gyro","Gyroscope",names(extracted_df))
names(extracted_df)<-gsub("Mag","Magnitude",names(extracted_df))
names(extracted_df)<-gsub("^t","Time",names(extracted_df))
names(extracted_df)<-gsub("^f","Frequency",names(extracted_df))
names(extracted_df)<-gsub("tBody","TimeBody",names(extracted_df))
names(extracted_df)<-gsub("-mean()","Mean",names(extracted_df))
names(extracted_df)<-gsub("-std()","StandardDev",names(extracted_df))
names(extracted_df)<-gsub("-freq()","Frequency",names(extracted_df))


######################################################################################
# 5. Create a second, independent tidy data set (from the one created above)
#    with the average of each variable for each activity and each subject

# Average of each variable (561 variables) for each activity (6 activities) for each subject (30 subjects)
# total rows = 561*6*30 = 100980
TidyData <- extracted_df %>%
  group_by(subject,activitylabel) %>%
  summarize_all(funs(mean))
write.table(TidyData,"TidyData.txt",row.names=FALSE)
