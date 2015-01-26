# datasciencecoursera
Coursera The Getting and Cleaning Data Course Project

According to the comment inserted in the code, the main steps are:
- STEP 1 Getting raw data: check availability of data and download it, in case
- STEP 2 Merging the data in a single data set
- STEP 3 Extract only the mean and std for each measurement
- STEP 4 Use descriptive activity names to name the activity in the data set
- STEP 5 Appropriate labels the data set with descriptive variable names
- STEP 6 Create the new tydy data set with the average of each variable for each activity and each subject

# STEP 1
Check availability of data, using file.exist function on "UCI HAR Dataset" directory
if not exists, download from original repository and unzip the file.
Upload Test and Train dataset about variables,subject and activity.

# STEP 2
Use of dplyr library to manipulate easier and faster the dataset.
Trasform each dataset in a tbl_df class object
Use proper columns names in the subject and a activity data both for train and test
Insert data label factor ("test","train") in test and train datasets
Merge test information as Columns bind between data,activity,subject info about test
Merge train information as Columns bind between data,activity,subject info about train
Unified previous dataset in only one as rows bind between test and train information

# STEP 3
Select the right column index using grep function to search "mean" and "std" words in the names of feature_labels
Use that index set to select the right measurements variables plus data, activity and subjects factors

# STEP 4
Use mutate to insert in the activity factor the proper description provided by activity_labels

# STEP 5
Select the right column name according the previuos set of index
Use of for function to seek the proper column name and force the name change according to the value in faeature_labels 
# STEP 6
REmove data factor from final data set
Force definition of subject as factor object.
Use aggregate to calculate mean by columns (variables) split by activity and subject
Prepare data to be write down on "tidy_dataset.txt" file


