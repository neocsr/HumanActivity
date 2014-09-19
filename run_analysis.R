# Getting and Cleaning Data Course Project

## Tasks

# 1. Merges the training and the test sets to create one data set.

print("Loading test and train datasets...")
trainSet <- read.csv("./X_train.txt", sep = "", header = FALSE)
testSet <- read.csv("./X_test.txt", sep = "", header = FALSE)

print("Joining train and test...")
rawSet <- rbind(trainSet, testSet)

# 2. Extracts only the measurements on the mean and standard deviation
#    for each measurement.

print("Reading features...")
features <- read.csv("./features.txt", sep = "", header = FALSE)
selectedFeatures <- features[grep("mean\\(\\)|std\\(\\)", features[, 2]), ]
dataset <- rawSet[, selectedFeatures[, 1]]

# 3. Uses descriptive activity names to name the activities in the data set

print("Building descriptive activity names...")
activityLabels <- read.csv("./activity_labels.txt", sep = "", header = FALSE)

activitiesTrain <- read.csv("./y_train.txt", sep = "", header = FALSE)
activitiesTest <- read.csv("./y_test.txt", sep = "", header = FALSE)

activities <- rbind(activitiesTrain, activitiesTest)
activities$id <- 1:nrow(activities)
activitiesMerged <- merge(activities, activityLabels, by.x = "V1", by.y = "V1", all = FALSE)

activitiesWithLabels <- activitiesMerged[order(activitiesMerged$id), ]

# 4. Appropriately labels the data set with descriptive variable names.

print("Reading subjects data...")
subjectsTrain <- read.csv("./subject_train.txt", sep = "", header = FALSE)
subjectsTest <- read.csv("./subject_test.txt", sep = "", header = FALSE)

subjects <- rbind(subjectsTrain, subjectsTest)

print("Labeling columns...")
datasetLabels <- gsub("  ", " ",
                      gsub("-", " ",
                           gsub("mean\\(\\)", "Mean",
                                gsub("std\\(\\)", "Std",
                                     gsub("^f", "Frequency ",
                                          gsub("^t", "Time ",
                                               gsub("([A-Z])", " \\1", selectedFeatures[, 2], perl = TRUE)))))))
names(dataset) <- datasetLabels
names(activitiesWithLabels) <- c("Activity Code", "Id", "Activity")
names(subjects) <- "Subject"

print("Merging final 'messy' dataset...")
messy <- cbind(subjects, activitiesWithLabels, dataset)

# 5. From the data set in step 4, create a second, independent tidy
#    data set with the average of each variable for each activity and each subject.

library(dplyr)

print("Generating 'tidy' dataset using dplyr...")
messy <- tbl_df(messy)

tidy <- messy %>%
  select(-`Activity Code`, -Id) %>%
  group_by(Subject, Activity) %>%
  summarise_each(funs(mean))

write.table(tidy, file = "tidy.txt", row.names = FALSE)
print("File 'tidy.txt' was generated.")

# Rscript run_analysis.R