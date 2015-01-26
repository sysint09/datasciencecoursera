##
## run_analysis.R
##
## This first line will likely take a few seconds. Be patient!
## 
## Check availability of data 
## setwd("DataScience/03_Getting_and_Cleaning_Data/Course Project/")
##
## ---
## Getting raw data
## ---
##
## set path of data repository
datarepository<-"UCI HAR Dataset"
if(!file.exists(datarepository)) {
      ## if raw data is not available download file from source URL
      fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileUrl,destfile="./getdata_projectfiles_UCI HAR Dataset.zip",method="curl")
      ## unzip raw data structure 
      unzip("./getdata_projectfiles_UCI HAR Dataset.zip")
}
## ---
## Upload raw data
## ---
activity_names<-read.table(paste(datarepository,"activity_labels.txt",sep="/"))
feature_labels<-read.table(paste(datarepository,"features.txt",sep="/"))
## Test raw data
acttest<-read.table(paste(datarepository,"test","Y_test.txt",sep="/"))
subjecttest<-read.table(paste(datarepository,"test","subject_test.txt",sep="/"))
datatest<-read.table(paste(datarepository,"test","X_test.txt",sep="/"))
## Train raw data
acttrain<-read.table(paste(datarepository,"train","Y_train.txt",sep="/"))
subjecttrain<-read.table(paste(datarepository,"train","subject_train.txt",sep="/"))
datatrain<-read.table(paste(datarepository,"train","X_train.txt",sep="/"))
##
## USE dplyr package
library(dplyr)
## -- 
## STEP 1: merging the training and the test sets to create one data set
## --
dtest<-tbl_df(datatest)
stest<-tbl_df(subjecttest)
atest<-tbl_df(acttest)
dtrain<-tbl_df(datatrain)
strain<-tbl_df(subjecttrain)
atrain<-tbl_df(acttrain)
## Prepare data before merging
stest<-rename(stest,subject=V1)
strain<-rename(strain,subject=V1)
atest<-rename(atest,activity=V1)
atrain<-rename(atrain,activity=V1)
## mark type of data selection 
dtest<-mutate(dtest,data="test")
dtrain<-mutate(dtrain,data="train")
##
## merge in one dataset
##
dtest<-bind_cols(dtest,stest,atest)
dtrain<-bind_cols(dtrain,strain,atrain)
dset<-bind_rows(dtest,dtrain)
## --
## STEP 2: Extracs only mean and std for each measurement
## --
## identify proper index from feature_labels
idstd<-grep("std",feature_labels$V2)
idmean<-grep("mean",feature_labels$V2)
id<-c(idstd,idmean)
## select the right columns from dset and store in dsetvar 
dsetvar<-select(dset,id,data:activity)
## --
## STEP 3: Uses descriptive activity names to name the activities in dsetvar
## --
dsetvar<-mutate(dsetvar,activity=activity_names$V2[activity])
## --
## STEP 4: Appropriately labels the dsetvar with descriptive variable names
## --
## select proper variable names
colnames<-feature_labels[id,]
n<-dim(colnames)[1]
for (i in 1:n) {
      ol<-paste("V",colnames[i,]$V1,sep="")
      nw<-as.character(colnames[i,]$V2)
      ## change names
      names(dsetvar)[names(dsetvar)==ol] <- nw
}
## --
## STEP 5: Tydy data set with average of each variable for each activity and each subject
## --
##
dsetvar<-select(dsetvar,activity,subject,1:79)
dsetvar<-mutate(dsetvar,subject=factor(subject))
nsetvar<-group_by(dsetvar,activity,subject)
t<-aggregate(nsetvar,by=list(nsetvar$activity,nsetvar$subject),FUN="mean")
t<-select(t,-(activity:subject))
t<-rename(t,activity=Group.1,subject=Group.2)
t<-arrange(t,activity,subject)
write.table(t,"tidy_dataset.txt",row.names=FALSE)
