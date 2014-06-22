# 1. Merges the training and the test sets to create one data set
setwd(".../UCI_HAR_Dataset/train")

data_subject_train <- read.table("subject_train.txt")
data_subject_train$id_to_merge_train <- 1:nrow(data_subject_train)
data_X_train <- read.table("X_train.txt")
data_X_train$id_to_merge_train <- 1:nrow(data_X_train)
data_Y_train <- read.table("Y_train.txt")
data_Y_train$id_to_merge_train <- 1:nrow(data_Y_train)

data_train_aux <- merge(data_subject_train, data_X_train, by.x="id_to_merge_train", by.y="id_to_merge_train")
data_train_merged <- merge(data_train_aux, data_Y_train, by.x="id_to_merge_train", by.y="id_to_merge_train")

setwd(".../UCI_HAR_Dataset/test")

data_subject_test <- read.table("subject_test.txt")
data_subject_test$id_to_merge_test <- 1:nrow(data_subject_test)
data_X_test <- read.table("X_test.txt")
data_X_test$id_to_merge_test <- 1:nrow(data_X_test)
data_Y_test <- read.table("Y_test.txt")
data_Y_test$id_to_merge_test <- 1:nrow(data_Y_test)

data_test_aux <- merge(data_subject_test, data_X_test, by.x="id_to_merge_test", by.y="id_to_merge_test")
data_test_merged <- merge(data_test_aux, data_Y_test, by.x="id_to_merge_test", by.y="id_to_merge_test")

# Merge all data
data_train_merged$id_to_merge_train <- NULL
data_test_merged$id_to_merge_test <- NULL

data <- rbind(data_train_merged, data_test_merged)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
means <- colMeans(data)
sd <- apply(data, 2, sd)

# 3. Uses descriptive activity names to name the activities in the data set
library(plyr)
data$V1 <- as.factor (mapvalues(data$V1, from = c(1, 2, 3, 4, 5, 6), to = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")))

# 4. Appropriately labels the data set with descriptive variable names
setwd(".../UCI_HAR_Dataset")
varNames <- read.table("features.txt")
varNames_array <- as.character(varNames$V2)

colnames(data)[1] <- "Subject"
colnames(data)[2:562] <- varNames_array
colnames(data)[563] <- "Activity"

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# for each subject
library(plyr)
res <- ddply(data, .(Subject), numcolwise(mean))

write.table(res, "result.txt")