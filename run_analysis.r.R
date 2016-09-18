if(!file.exists("./data")){dir.create("./data")}
data_zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(data_zip,destfile="./data/Dataset.zip")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

trainx <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainsubj <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
testx <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
testy <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testsubj <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
feature <- read.table('./data/UCI HAR Dataset/features.txt')
activityLabel = read.table('./data/UCI HAR Dataset/activity_labels.txt')

colnames(trainx) <- feature[,2] 
colnames(trainy) <-"actId"
colnames(trainsubj) <- "subjId"
colnames(testx) <- feature[,2] 
colnames(testy) <- "actId"
colnames(testsubj) <- "subjId"
colnames(activityLabel) <- c('actId','actType')

train <- cbind(trainy, trainsubj, trainx)
test <- cbind(testy, testsubj, testx)
mergetestandtrain <- rbind(train, test)

columnnames <- colnames(mergetestandtrain)

meanstd <- (grepl("actId" , columnnames) | grepl("subjId" , columnnames) | grepl("mean.." , columnnames) | grepl("std.." , columnnames))
meanandstdsubset <- mergetestandtrain[ , meanstd == TRUE]
activitynames <- merge(meanandstdsubset, activityLabel,by='actId',all.x=TRUE)

seconddataset <- aggregate(. ~subjId + actId, activitynames, mean)
seconddataset_final <- seconddataset[order(seconddataset$subjId, seconddataset$actId),]
write.table(seconddataset_final,"seconddataset_final.txt", row.name=FALSE)
