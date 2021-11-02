# Load Data and source files
load("../Data/LSK/LSK_All_Plus.RData")
#tst
source("evplot.R")
library(rgl)
library(ggplot2)
library(scales)
library(plyr)
library(dplyr)

# Set which dataset is going to be used.
Data <- LSK_Features
Labels <- LSK_Labels

# Logtransform 

# Assign categorical variables to each sample.
nEx <- nrow(Data)

LinNeg <- factor(rep(FALSE,nEx),levels=c(TRUE,FALSE))

LinNegInds <- is.element(rownames(Data),na.omit(Labels$LinNeg))

LinNeg[LinNegInds] <- 'TRUE'

Region <- rep('Lin+',nEx)

R1Inds <- is.element(rownames(Data),na.omit(Labels$R1))
R2Inds <- is.element(rownames(Data),na.omit(Labels$R2))
R3Inds <- is.element(rownames(Data),na.omit(Labels$R3))
R4Inds <- is.element(rownames(Data),na.omit(Labels$R4))

Region[R1Inds] <- 'R1'
Region[R2Inds] <- 'R2'
Region[R3Inds] <- 'R3'
Region[R4Inds] <- 'R4'

Data$Region <- Region
Data$Treatment <- 'NoTPO'

Data1 <- Data
Labels1 <- Labels


# Load Data and source files
load("../Data/LSK/LSK_All_Plus.RData")

source("evplot.R")
library(rgl)

# Set which dataset is going to be used.
Data <- `LSK_TPO_Features`
Labels <- `LSK_TPO_Labels`

nEx <- nrow(Data)

LinNeg <- factor(rep(FALSE,nEx),levels=c(TRUE,FALSE))

LinNegInds <- is.element(rownames(Data),na.omit(Labels$LinNeg))

LinNeg[LinNegInds] <- 'TRUE'

Region <- rep('Lin+',nEx)

R1Inds <- is.element(rownames(Data),na.omit(Labels$R1))
R2Inds <- is.element(rownames(Data),na.omit(Labels$R2))
R3Inds <- is.element(rownames(Data),na.omit(Labels$R3))
R4Inds <- is.element(rownames(Data),na.omit(Labels$R4))

Region[R1Inds] <- 'R1'
Region[R2Inds] <- 'R2'
Region[R3Inds] <- 'R3'
Region[R4Inds] <- 'R4'

Data$Region <- Region

Data$Treatment <- 'TPO'

Data2 <- Data
Labels2 <- Labels

# COMBINE THE DATASETS
FeatureData <- rbind(Data1,Data2)


########################################
# Subset the dataset to look at only lineage negative cells
FeatureData <- subset(FeatureData,Region!='Lin+')
FeatureData <- sample_n(FeatureData,10000)

LSK_NoTPO <- Data1
LSK_TPO <- Data2

LSK_NoTPO <- subset(LSK_NoTPO,Region!='Lin+')
LSK_TPO <- subset(LSK_TPO,Region!='Lin+')

LSK_NoTPO$Treatment <- NULL
LSK_TPO$Treatment <- NULL

##
Data1 <- subset(Data1,Region!='Lin+')
Data2 <- subset(Data2,Region!='Lin+')
Data1 <- sample_n(Data1,nrow(Data2))

EqualData <- rbind(Data1,Data2)

## Export data
#write.csv(LSK_NoTPO,file="LSK_NoTPO.csv")
#write.csv(LSK_TPO,file="LSK_TPO.csv")
#write.csv(FeatureData,file="LSK_Combined.csv")
#write.csv(EqualData,file="LSK_Equal.csv")