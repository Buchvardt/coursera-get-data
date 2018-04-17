#Downlod data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "dataset.zip")

#Unzip
zipF<- "dataset.zip"
outDir<-"dataset"
unzip(zipF,exdir=outDir)
