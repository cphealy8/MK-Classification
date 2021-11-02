# Load Data and source files
load("../Data/LSK/LSK_All_Plus.RData")

source("evplot.R")
library(rgl)

# Set which dataset is going to be used.
Data <- LSK_Features
Labels <- LSK_Labels

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
Data$Treatment <- '-TPO'

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

Region[R1Inds] <- 'R1+TPO'
Region[R2Inds] <- 'R2+TPO'
Region[R3Inds] <- 'R3+TPO'
Region[R4Inds] <- 'R4+TPO'

Data$Region <- Region

Data$Treatment <- '+TPO'

Data2 <- Data
Labels2 <- Labels

# COMBINE THE DATASETS
# FeatureData <- rbind(Data1,Data2)
FeatureData <- Data1

########################################
# Subset the dataset to look at only lineage negative cells
FeatureData <- subset(FeatureData,Region!='Lin+')
Region <- FeatureData$Region
Treatment <- FeatureData$Treatment
Sca1 <- FeatureData$Sca1
Ckit <- FeatureData$Ckit
FeatureData$Region <- NULL # We need to omit this before PCA
FeatureData$Treatment <- NULL # We need to omit this before PCA
FeatureData$Sca1 <- NULL
FeatureData$Ckit <- NULL

########################################
# Perform PCA on the dataset.
data.pca <- prcomp(FeatureData,center = TRUE,scale. = TRUE) # This is the actual PCA

summary(data.pca) # This displays the results of the PCA


# Some useful transformations of the Data
loadings <- data.pca$rotation
scores <- data.pca$x
correlations <- t(loadings)*data.pca$sdev

# Reappend Regions to the dataframe
FeatureData$Region <- Region


# Prepare the extra data
ExData <- subset(Data2,Region!='Lin+')
ExRegion <- ExData$Region
ExTreatment <- ExData$Treatment
ExCkit <- ExData$Ckit
ExSca1 <- ExData$Sca1
ExData$Region <- NULL # We need to omit this before PCA
ExData$Treatment <- NULL # We need to omit this before PCA
ExData$Sca1 <- NULL # We need to omit this before PCA
ExData$Ckit <- NULL # We need to omit this before PCA

##################
data.Regions.Plus <- c(FeatureData$Region,ExRegion)
data.Treatments.Plus <-c(Treatment,ExTreatment)
data.Sca1.Plus <- c(Sca1,ExSca1)
data.Ckit.Plus <- c(Ckit,ExCkit)
s.sc <- scale(ExData,center = data.pca$center)
s.pred <- s.sc %*% data.pca$rotation

data.plusproj.pca <- data.pca
data.plusproj.pca$x <- rbind(data.plusproj.pca$x,s.pred)






## Bi-Plot
pdat <- as.data.frame(data.plusproj.pca$x)
pdat$Region <- data.Regions.Plus
pdat$Treatment <- data.Treatments.Plus
pdat$Ckit <- data.Ckit.Plus
pdat$Sca1 <- data.Sca1.Plus

# Center and normalize expression data.
pdat$Ckit <- (pdat$Ckit-min(pdat$Ckit))/max(pdat$Ckit)
pdat$Sca1 <- (pdat$Sca1-min(pdat$Sca1))/max(pdat$Sca1)

pdat <- subset(pdat,Treatment=="+TPO")

ManCols <- c('#000000','#336633','#ff3333','#336699')
ManShapes <- c(17,18,19,15)


g <- ggplot(pdat,aes(x=PC1,y=PC2,color=Region,shape=Region))+
  geom_point(size=0.5,alpha=0.3)+
  stat_ellipse(level=0.99,size=1,color="white")+
  stat_ellipse(level=0.99,size=0.5)+
  scale_color_manual(values=ManCols)+
  scale_shape_manual(values=ManShapes)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK+TPO_PC1vPC2.pdf',width=2.25,height=2.25,units="in")


g <- ggplot(pdat,aes(x=PC1,y=PC3,color=Region,shape=Region))+
  geom_point(size=0.5,alpha=0.3)+
  stat_ellipse(level=0.99,size=1,color="white")+
  stat_ellipse(level=0.99,size=0.5)+
  scale_color_manual(values=ManCols)+
  scale_shape_manual(values=ManShapes)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK+TPO_PC1vPC3.pdf',width=2.25,height=2.25,units="in")


g <- ggplot(pdat,aes(x=PC2,y=PC3,color=Region,shape=Region))+
  geom_point(size=0.5,alpha=0.3)+
  stat_ellipse(level=0.99,size=1,color="white")+
  stat_ellipse(level=0.99,size=0.5)+
  scale_color_manual(values=ManCols)+
  scale_shape_manual(values=ManShapes)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK+TPO_PC2vPC3.pdf',width=2.25,height=2.25,units="in")

