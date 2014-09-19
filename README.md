# Getting and Cleaning Data Course Project

## Human Activity Recognition Using Smartphones Data

The script *run_analysis.R* contains the commands to process and clean the dataset.

The five steps outlined in the instructions of the assignment are indicated as comments in this script.

The required data files are in the same root directory with the script.

The script can be run from *RStudio* after setting the working directory to the scripts directory:
    
    > setwd("~/Getting and Cleaning Data/Assignment")
    > source("run_analysis.R")

Alternatively the script can be run from a *terminal* session:

    > cd "~/Getting and Cleaning Data/Assignment"
    > Rscript run_analysis.R

This script will generate a file called *tidy.txt* which contains the final dataset. 
It contains the average of all the features grouped by subject and activity.

The file *CodeBook.md* describes this dataset.