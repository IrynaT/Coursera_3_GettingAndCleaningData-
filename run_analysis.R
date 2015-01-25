library(plyr)
x_train <- read.table("train/X_train.txt", sep = " ") # length(x_train[,1])
x_test <- read.table("test/X_test.txt", sep = " ")    # length(x_test[,1])
# combine datasets together 
x_data <- rbind(x_train, x_test)                      # length(x_data[,1])    

y_train <- read.table("train/y_train.txt", sep = " ") # length(y_train[,1])
y_test <- read.table("test/y_test.txt", sep = " ")    # length(y_test[,1])
# combine datasets together 
y_data <- rbind(y_train, y_test)                      # length(y_data[,1])  

subject_train <- read.table("train/subject_train.txt", sep = " ") # length(subject_train[,1])  
subject_test <- read.table("test/subject_test.txt", sep = " ")    # length(subject_test[,1])  
# combine datasets together 
subject_data <- rbind(subject_train, subject_test)                # length(subject_data[,1])  
# read column names for data set x_data from the file "features.txt"
features <- read.table("features.txt", sep = " ")

mean_columns <- data.frame( colnumber = grep("-mean\\(\\)", features[, 2], 
                                              ignore.case = TRUE,
                                              invert = FALSE,
                                              value = FALSE), 
                              colname = grep("-mean\\(\\)", features[, 2], 
                                              ignore.case = TRUE,
                                              invert = FALSE,
                                              value = TRUE),
                              coltype = "mean")
std_columns   <- data.frame( colnumber = grep("-std\\(\\)", features[, 2], 
                                               ignore.case = TRUE,
                                               invert = FALSE,
                                               value = FALSE), 
                               colname = grep("-std\\(\\)", features[, 2], 
                                              ignore.case = TRUE,
                                              invert = FALSE,
                                              value = TRUE),
                               coltype = "std")
# bind together mean and std data columns indexes, names and labels
columns <- rbind (mean_columns, std_columns)
# head(columns, 10)        # check data and column names in columns

x_data_final <- x_data[, columns[,1]];  # subset the desired columns
names(x_data_final) <- columns[,2];     # give names to the selected columns

activities <- read.table("activity_labels.txt")
# replace/parce activity ID to activity names in data set y, name the column as "activity"
y_data_final <- data.frame(activity = activities[ y_data[,1] , 2]) 
# head(y_data_final, 10)  # check data and column names in y_data_final

names(subject_data) <- "subject" # name the future column of data_final data set as "subject"

# bind all three the data sets in a single object
data_final <- cbind( subject_data, y_data_final, x_data_final) 
# head(data_final, 10) ; length(data_final[,1])

# For each subset of a data frame data_final, ddply() applys a function, 
# then combines result rows into a data frame.
avg_data <- ddply( data_final, 
                   .(subject, activity),  # variables to split data by (exclude columns from calculation of mean())
                   function(x) { colMeans( x[,3:ncol(data_final)]) } )
write.table(avg_data, "avg_data.txt", row.name = FALSE)
