# Coursera_3_GettingAndCleaningData-
Getting and Cleaning Data course - Assignment

This assisgment requires to create a tidy data set and save it into a *.txt file runing through 5 main steps of processing and cleaning entry data. Raw entry data files should be storied in the work directory. Below you can find peices of code and detailed comments to make explicit the step's functionality. 
# 1. Merge the training and test sets to create one data set.
x_train <- read.table("train/X_train.txt", sep = " ") ## length(x_train[,1]) gives 7352 rows
x_test <- read.table("test/X_test.txt", sep = " ")    ## length(x_test[,1])  gives 2947 rows
x_data <- rbind(x_train, x_test)                      ## combine datasets together, gives 10299 rows 

y_train <- read.table("train/y_train.txt", sep = " ") ## length(y_train[,1]) gives 7352 rows
y_test <- read.table("test/y_test.txt", sep = " ")    ## length(y_test[,1])  gives 2947 rows
y_data <- rbind(y_train, y_test)                      ## combine datasets together, gives 10299 rows 

subject_train <- read.table("train/subject_train.txt", sep = " ")   
subject_test <- read.table("test/subject_test.txt", sep = " ")   
subject_data <- rbind(subject_train, subject_test)    ## combine datasets together, gives 10299 rows            

# 2. Extract only the measurements on the mean and standard deviation:  
features <- read.table("features.txt", sep = " ")  ## read column names for the x_data data set from the "features.txt" file
## select required column numbers and names
mean_columns <- data.frame( colnumber = grep("-mean\\(\\)", features[, 2], ## the mean column contains "-mean()" in a string
                                              ignore.case = TRUE,
                                              invert = FALSE,
                                              value = FALSE), 
                              colname = grep("-mean\\(\\)", features[, 2], ## the standard deviation contains "-std()" in a string
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
## bind together mean and std data columns indexes, names and labels
columns <- rbind (mean_columns, std_columns)
x_data_final <- x_data[, columns[,1]];  ## subset the desired data
names(x_data_final) <- columns[,2];     ## give names to the selected columns

# 3. Use descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt") # read the "activity_labels.txt" file
y_data_final <- data.frame(activity = activities[ y_data[,1] , 2]) ## parce activity ID to activity names and name the column as "activity"

# 4.Appropriately label the data set with descriptive variable names
names(subject_data) <- "subject" ## give a name before include it into the final data set

data_final <- cbind( subject_data, y_data_final, x_data_final) ## bind all three data sets in a single object

# 5.Create a second, independent tidy data set with the average of each variable for each activity and each subject
avg_data <- ddply( data_final,    ## for each subset it applys a function, then combines result rows into a data frame.
                   .(subject, activity),  ## variables to split data by 
                   function(x) { colMeans( x[,3:ncol(data_final)]) } )
## save output result into *.txt file
write.table(avg_data, "avg_data.txt", row.name = FALSE)
