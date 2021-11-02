# Load Data and source files
load("../Data/LSK/LSK_Labels.RData")
load("../Data/LSK/LSK_Data.RData")

source("evplot.R")
library(rgl)

# Set which dataset is going to be used.
FeatureData <- LSK_Features
FeatureLabels <- LSK_Labels

# Omit things if necessary
source("OmitNucleusData.R")
source("OmitSignalData.R")
source("OmitTextureData.R")

# Assign categorical variables to each sample.
nEx <- nrow(FeatureData)

LinNeg <- factor(rep(FALSE,nEx),levels=c(TRUE,FALSE))

LinNegInds <- is.element(rownames(FeatureData),na.omit(FeatureLabels$LinNeg))

LinNeg[LinNegInds] <- 'TRUE'



Region <- factor(rep('Lin+',nEx),levels=c('Lin+','R1','R2','R3','R4'))

R1Inds <- is.element(rownames(FeatureData),na.omit(FeatureLabels$R1))
R2Inds <- is.element(rownames(FeatureData),na.omit(FeatureLabels$R2))
R3Inds <- is.element(rownames(FeatureData),na.omit(FeatureLabels$R3))
R4Inds <- is.element(rownames(FeatureData),na.omit(FeatureLabels$R4))

Region[R1Inds] <- 'R1'
Region[R2Inds] <- 'R2'
Region[R3Inds] <- 'R3'
Region[R4Inds] <- 'R4'

# Perform PCA on the dataset.
data.pca <- prcomp(FeatureData,center = TRUE,scale. = TRUE) # This is the actual PCA

summary(data.pca) # This displays the results of the PCA


# Plotting PCA
library(ggbiplot)
FeatureData$Group <- Region

g1 <- ggbiplot(data.pca,ellipse = TRUE, groups=FeatureData$Group, obs.scale=1,var.scale=1,var.axes=FALSE,alpha=0.1)+
  scale_color_brewer(palette="Set2")
print(g1)

# To get the relationship/correlation between the variables and the PCs look at.
rcorr <- data.frame(abs(data.pca$rotation))
rcorr <- rcorr[order(rcorr$PC3),]

loadings <- data.pca$rotation
scores <- data.pca$x

correlations <- t(loadings)*data.pca$sdev
plot(data.pca,type="l",main="")

ev <- data.pca$sdev^2
evplot(ev)

#GroupCols <- c("#e41a1c","#377eb8","#4daf4a","#984ea3","#ff7f00") # Color Brewer Set 1
GroupCols <- c("#66c2a5","#fc8d62","#8da0cb","#e78ac3","#a6d854") # Color Brewer Set 2
GroupAlphas <- c(0.1,0.2,0.2,0.2,0.2)
plot3d(scores[,1:3],size=5,col=GroupCols[as.integer(FeatureData$Group)],alpha=GroupAlphas[as.integer(FeatureData$Group)])
