
#1.downloading and unzipping file from web
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data") #unzipping

#Reading Train file
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Reading Test file
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#merging train, test dataset
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)



#Reading feature & activity info
# reading feature file
feature <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels
a_label <- read.table('./data/UCI HAR Dataset/activity_labels.txt')
a_label[,2] <- as.character(a_label[,2])



#2.extract feature cols & names named 'mean, std'
selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)


#3. extract data by cols & using descriptive name
x_data <- x_data[selectedCols]
allData <- cbind(subject_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)


allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)

#4.Appropriately labels the data set with descriptive variable names. #==>done

#5. Generating tidy data set
meltingData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltingData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)