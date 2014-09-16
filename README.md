#run_analysis.R

##Assumptions
*Zip file is separately downloaded and unzipped
*SCript is run from the base directory of the unzipped file - UCI HAR Dataset

##Outputs
*Exercise_Tidy.txt - The initial, unsummarised tidy data
*Exercise_Mean_Tidy.txt - The tidy data summarised by subject and activity

##Processing

*Read the global files - activity_labels.tx & Features.txt
*Massage the Feature label text to remove brackets & dashes
* For each of the data groups (test & train)
**cd to the group subdirectory
**Read the group specific files - subject_*.txt, y_*.txt, X_*.txt
**Restrict the x_* data to the _mean & _std columns
**Merge y_* with the activity_labels
**cbind the x_* data with the subject & activity data
**Add the final df to 'result'
*Write the resul df to Exercise_Tidy.txt
*create summary by taking mean of all columns by subject and activity
*Write the summarised result to Exercise_Mean_Tidy.txt
