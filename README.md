Getting and Cleaning Data course - Assignment

This assisgment requires to create a tidy data set and save it into a *.txt file runing through 5 main steps of processing and cleaning entry data. Raw entry data files should be storied in the work directory. Below you can find peices of code and detailed comments to make explicit the step's functionality. 

### 1. Merge the training and test sets to create one data set.
**x_train** <- read.table("train/X_train.txt", sep = " ");
**x_test** <- read.table("test/X_test.txt", sep = " ");
*combine datasets together, gives 10299 rows*
**x_data** <- rbind(x_train, x_test);

**y_train** <- read.table("train/y_train.txt", sep = " ");
**y_test** <- read.table("test/y_test.txt", sep = " ");
*combine datasets together, gives 10299 rows*
**y_data** <- rbind(y_train, y_test);                  

**subject_train** <- read.table("train/subject_train.txt", sep = " ");   
**subject_test** <- read.table("test/subject_test.txt", sep = " ");   
*combine datasets together, gives 10299 rows*            
**subject_data** <- rbind(subject_train, subject_test);

### 2. Extract only the measurements on the mean and standard deviation:  

*read column names for the x_data data set from the "features.txt" file*

**features** <- read.table("features.txt", sep = " "); 

*select required column numbers and names: the mean column contains "-mean()" in a string and the standard deviation contains "-std()" in a string*

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
## bind together mean and std data columns indexes, names and labels
columns <- rbind (mean_columns, std_columns)
 *subset the desired data*
 
**x_data_final** <- x_data[, columns[,1]]; 

*give names to the selected columns*\n

names(x_data_final) <- columns[,2];    

### 3. Use descriptive activity names to name the activities in the data set

*read the "activity_labels.txt" file*
**activities** <- read.table("activity_labels.txt");

*parce activity ID to activity names and name the column as "activity"*
**y_data_final** <- data.frame(activity = activities[ y_data[,1] , 2]); 

### 4.Appropriately label the data set with descriptive variable names
names(subject_data) <- "subject" ## give a name before include it into the final data set

*bind all three data sets in a single object*

**data_final** <- cbind( subject_data, y_data_final, x_data_final);


### 5.Create a second, independent tidy data set with the average of each variable for each activity and each subject

*for each subset it applys a function, then combines result rows into a data frame.*

**avg_data** <- ddply( data_final,   
                   .(subject, activity),  ## variables to split data by 
                   function(x) { colMeans( x[,3:ncol(data_final)]) } );
                   
*save output result into *.txt file*

write.table(avg_data, "avg_data.txt", row.name = FALSE)
