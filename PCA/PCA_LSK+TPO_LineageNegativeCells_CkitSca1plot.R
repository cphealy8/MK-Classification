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
#FeatureData$BDI.R7 <- NULL # Creates NANs




#######################################################################
# Preprocessing for PCA
# FeatureData$Area <- scale(FeatureData$Area,center=TRUE,scale=TRUE)
# FeatureData$Diameter <- scale(FeatureData$Diameter,center=TRUE,scale=TRUE)
# FeatureData$Height <- scale(FeatureData$Height,center=TRUE,scale=TRUE)
# FeatureData$Length <- scale(FeatureData$Length,center=TRUE,scale=TRUE)
# FeatureData$Major.Axis.Intensity <- scale(FeatureData$Major.Axis.Intensity,center=TRUE,scale=TRUE)
# FeatureData$Major.Axis <- scale(FeatureData$Major.Axis,center=TRUE,scale=TRUE)
# FeatureData$Minor.Axis.Intensity <- scale(FeatureData$Minor.Axis.Intensity,center=TRUE,scale=TRUE)
# FeatureData$Minor.Axis <- scale(FeatureData$Minor.Axis,center=TRUE,scale=TRUE)
# FeatureData$Perimeter <- scale(FeatureData$Perimeter,center=TRUE,scale=TRUE)
# FeatureData$Spot.Area.Min <- scale(FeatureData$Spot.Area.Min,center=TRUE,scale=TRUE)
# FeatureData$Thickness.Max <- scale(FeatureData$Thickness.Max,center=TRUE,scale=TRUE)
# FeatureData$Thickness.Min <- scale(FeatureData$Thickness.Min,center=TRUE,scale=TRUE)
# FeatureData$Width <- scale(FeatureData$Width,center=TRUE,scale=TRUE)
# FeatureData$Aspect.Ratio.Intensity <- scale(FeatureData$Aspect.Ratio.Intensity,center=TRUE,scale=TRUE)
# FeatureData$Aspect.Ratio <- scale(FeatureData$Aspect.Ratio,center=TRUE,scale=TRUE)
# FeatureData$Circularity <- scale(FeatureData$Circularity,center=TRUE,scale=TRUE)
# FeatureData$Compactness <- scale(FeatureData$Compactness,center=TRUE,scale=TRUE)
# FeatureData$Elongatedness <- scale(FeatureData$Elongatedness,center=TRUE,scale=TRUE)
# FeatureData$Lobe.Count <- scale(FeatureData$Lobe.Count,center=TRUE,scale=TRUE)
# FeatureData$Shape.Ratio <- scale(FeatureData$Shape.Ratio,center=TRUE,scale=TRUE)
# FeatureData$Symmetry.2 <- scale(FeatureData$Symmetry.2,center=TRUE,scale=TRUE)
# FeatureData$Symmetry.3 <- scale(FeatureData$Symmetry.3,center=TRUE,scale=TRUE)
# FeatureData$Symmetry.4 <- scale(FeatureData$Symmetry.4,center=TRUE,scale=TRUE)
# FeatureData$BDI.R3 <- scale(FeatureData$BDI.R3 ,center=TRUE,scale=TRUE)
# FeatureData$BDI.R7 <- scale(FeatureData$BDI.R7 ,center=TRUE,scale=TRUE)
# FeatureData$Contrast <- scale(FeatureData$Contrast,center=TRUE,scale=TRUE)
# FeatureData$Modulation <- scale(FeatureData$Modulation,center=TRUE,scale=TRUE)
# FeatureData$Spot.Count <- scale(FeatureData$Spot.Count,center=TRUE,scale=TRUE)
# FeatureData$Std.Dev <- scale(FeatureData$Std.Dev,center=TRUE,scale=TRUE)

########################################
# Perform PCA on the dataset.
data.pca <- prcomp(FeatureData,center=TRUE,scale=TRUE) # This is the actual PCA

summary(data.pca) # This displays the results of the PCA


# Some useful transformations of the Data
loadings <- data.pca$rotation
scores <- data.pca$x
correlations <- t(loadings)*data.pca$sdev
EigVals <- data.pca$sdev^2

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
#ExData$BDI.R7 <- NULL

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

pdat <- subset(pdat,Treatment=="+TPO")
# Center and normalize expression data.
alp <- 0.01

logCkit <- log10(ExCkit)
qCkit <- c(log10(quantile(ExCkit,alp)),log10(quantile(ExCkit,1-alp)))

logSca1 <- log10(Sca1)
qSca1<- c(log10(quantile(ExSca1,alp)),log10(quantile(ExSca1,1-alp)))




g <- ggplot(NULL,aes(x=logCkit))+
  geom_histogram()+
  annotate("segment",x=qCkit[1],xend=qCkit[1],y=0,yend=2000,color="red")+
  annotate("segment",x=qCkit[2],xend=qCkit[2],y=0,yend=2000,color="red")
print(g)

g <- ggplot(NULL,aes(x=logSca1))+
  geom_histogram()+
  annotate("segment",x=qSca1[1],xend=qSca1[1],y=0,yend=2000,color="red")+
  annotate("segment",x=qSca1[2],xend=qSca1[2],y=0,yend=2000,color="red")
print(g)

Sca1Cols = c("black","blue")
CkitCols = c("black","green")

## OVERRIDE ##
qCkit <- c(2.97,4.31)
qSca1 <- c(1.42,4.12)


###PLOTS###

g <- ggplot(pdat,aes(x=PC1,y=PC2,color=Sca1))+
  geom_point(alpha=0.3,size=1,shape=16)+
  #coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=Sca1Cols,trans="log",limits=10^qSca1,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK+TPO_PC1vPC2_Sca1Expression.pdf',width=2.25,height=2.25,units="in")

g <- ggplot(pdat,aes(x=PC1,y=PC2,color=Ckit))+
  geom_point(alpha=0.3,size=1,shape=16)+
  #coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=CkitCols,trans="log",limits=10^qCkit,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK+TPO_PC1vPC2_cKitExpression.pdf',width=2.25,height=2.25,units="in")



g <- ggplot(pdat,aes(x=PC1,y=PC3,color=Sca1))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=Sca1Cols,trans="log",limits=10^qSca1,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK+TPO_PC1vPC3_Sca1Expression.pdf',width=2.25,height=2.25,units="in")

g <- ggplot(pdat,aes(x=PC1,y=PC3,color=Ckit))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=CkitCols,trans="log",limits=10^qCkit,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK+TPO_PC1vPC3_cKitExpression.pdf',width=2.25,height=2.25,units="in")



g <- ggplot(pdat,aes(x=PC2,y=PC3,color=Sca1))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=Sca1Cols,trans="log",limits=10^qSca1,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK+TPO_PC2vPC3_Sca1Expression.pdf',width=2.25,height=2.25,units="in")

g <- ggplot(pdat,aes(x=PC2,y=PC3,color=Ckit))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=CkitCols,trans="log",limits=10^qCkit,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK+TPO_PC2vPC3_cKitExpression.pdf',width=2.25,height=2.25,units="in")



manbreaks = c(1000,10000)
## For Legends
g <- ggplot(pdat,aes(x=PC1,y=PC2,color=Sca1))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=Sca1Cols,trans="log",limits=10^qSca1,oob=squish,breaks=c(100,1000,10000))+
  theme(text = element_text(size=8))
print(g)
ggsave('Sca1Colorbar.pdf',width=2.25,height=2.25,units="in")

g <- ggplot(pdat,aes(x=PC1,y=PC2,color=Ckit))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=CkitCols,trans="log",limits=10^qCkit,oob=squish,breaks=c(1000,10000))+
  theme(text = element_text(size=8))
print(g)
ggsave('CKitColorbar.pdf',width=2.25,height=2.25,units="in")

pdat$Sca1Log = log10(pdat$Sca1)
pdat$CKitLog = log10(pdat$Ckit)


## 3D scatterplots
regCounts <- count(pdat,'Region')
nsamps <- round(1*min(regCounts$freq))

R1Samps <- sample_n(subset(pdat,Region=='R1+TPO'),nsamps)
R2Samps <- sample_n(subset(pdat,Region=='R2+TPO'),nsamps)
R3Samps <- sample_n(subset(pdat,Region=='R3+TPO'),nsamps)
R4Samps <- sample_n(subset(pdat,Region=='R4+TPO'),nsamps)

sampdat <- rbind(R1Samps,R2Samps,R3Samps,R4Samps)

library(plotly)
p <- plot_ly(sampdat, x = ~PC1, y = ~PC2, z = ~PC3, color = ~Region, colors = c('#010202','#397F3D','#E93726','#3A54A4'),
             marker = list(size = 5, opacity = 1,line=list(color ='rgb(255,255,255)',width=1))) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'PC1'),
                      yaxis = list(title = 'PC2'),
                      zaxis = list(title = 'PC3')))

p


## Checking for normality
datasample = sample(FeatureData$Length,5000,replace=TRUE)
hist(datasample)
shapiro.test(datasample)

hist(log10(datasample))
shapiro.test(log10(datasample))