#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url, destfile = "exercise.zip")

library(plyr)

# NOTE: Assumes run from basedir of the data set

# define data groups
groups <- c("test","train")

# Read global files - activity_labels & Features
activities <- read.table("activity_labels.txt", header = FALSE, sep = "")
names(activities) <- c("act_id","activity")

features <- read.table("Features.txt", header = FALSE, sep = "")
names(features) <- c("metric_id","metric")
# Massage feature names
features$metric <- sub("\\(\\)", "", features$metric)
features$metric <- gsub("-", "_", features$metric)


result <- data.frame()# create empty result data frame

# now for each group process 
for (group in groups) {
    setwd(group)    # chnage dir to the specific group

    # read subject_{test|train}.txt
    subj.file <- paste("subject_", group, ".txt", sep="")
    subj_xref <- read.table(subj.file, header = FALSE, sep = "")
    names(subj_xref) <- "subj_id"
    
    # read y_{test|train}.txt
    act.file <- paste("y_", group, ".txt", sep="")
    act_xref <- read.table(act.file, header = FALSE, sep = "")
    names(act_xref) <- "act_id"
    
    # merge activity labels with y_* on act_id
    act_xref <- merge(act_xref, activities)
    
    # Read x (real metrics)
    data.file <- paste("X_", group, ".txt", sep="")
    data <- read.table(data.file, header = FALSE, sep = "")
    
    # add features as cols
    names(data) <- features$metric
    
    # select the mean & Stdev cols
    reqd_cols <- grep("_mean|_std", features$metric , perl=T)
    data_sub <- data[,reqd_cols]
    
    # add activity
    data_sub <- cbind(act_xref$activity, data_sub)
    data_cols <- names(data_sub)
    data_cols[1] <- "activity"
    names(data_sub) <- data_cols
    
    # add subject
    data_sub <- cbind(subj_xref, data_sub)
    
    result <- rbind(result, data_sub)
    
    setwd("..")    # change dir back to base dir
}


# write the result data
write.table(result, "Exercise_Tidy.txt", row.name=FALSE) 

sum_result <- ddply(result, c("subj_id","activity"),
      function(X) {
        # Use colMeans to get mean of all cols except 1 & 2
        temp <- colMeans(X[,-c(1,2)])
        # turn back into df
        temp <- as.data.frame(t(temp))
        
        # get col names from data, then prepend the key colnames
        col_names <- names(temp)
        col_names <- c("subj_id","activity",col_names)
        
        # get the key data
        keys <- X[1,c(1,2)]

        #Bind keys & the summarised data
        res <- cbind(keys, temp)

        # reset the names
        names(res) = col_names
        
        # return the temp result
        res
      }
    )

# write the summarised result data
write.table(sum_result, "Exercise_Mean_Tidy.txt", row.name=FALSE) 
