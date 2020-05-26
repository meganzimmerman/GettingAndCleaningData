README for run_analysis.R

DOWNLOADING DATA AND SETTING UP DIRECTORY STRUCTURE
Set working directory to location where you'd like to perform the analysis

create zipURL variable which specifies location of the dataset on the web

download the data to a zip file (ProjectData.zip) and unzip using the R unzip function.

enter into the unzipped directory (UCI HAR Dataset) for analysis

STEP 1 : MERGE DATA SETS
* Read the x_test.txt/y_test.txt as well as the x_train.txt/y_train.txt in order to
  read the data and the feature class headers associated with each row. Also read the
  subject_test and subject_train txt files to add the subject info for the person
  who performed each test.
* rbind the train and test data frames (feature vectors with 561 measurements in each row)
* add new column to include label and subject info

STEP 2: EXTRACT ONLY MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION
* read the features.txt to get the header information for each column
* assign the headers to the data frame columns and determine which ones contain "mean" and "std"
* create a second data frame, "extracted_df" with the mean_cols and stdv_cols along 
  with the label and subject cols added in the first step

STEP 3: USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVIITES
* read the activity_labels.txt to link the integer values (data_df$labels) to an activity class (e.g. walking, standing)
* assign the character activitylabel using the integer values. This SHOULD be done with merge but I was having
  an issue with the class types

STEP 4: APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES
* update the headers of the extracted_df to be more human readable

STEP 5: CREATE A TIDY DATASET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND SUBJECT
* use the linking functionality to combine group_by (subject,activitylabel) and summarize_all(funs(mean))

