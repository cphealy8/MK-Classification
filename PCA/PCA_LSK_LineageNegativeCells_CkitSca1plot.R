# Load Data and source files
load("../Data/LSK/LSK_All_Plus.RData")

source("evplot.R")
library(rgl)
library(devtools)
library(ggbiplot)
library(ggplot2)
library(scales)
library(plyr)
library(dplyr)

# Set which dataset is going to be used.
FeatureData <- LSK_Features
FeatureLabels <- LSK_Labels

# FeatureData <- `LSK+TPOFeatures`
# FeatureLabels <- `LSK_TPO_Labels`


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

FeatureData$Region <- Region

########################################
# Subset the dataset to look at only lineage negative cells
FeatureData <- subset(FeatureData,Region!='Lin+')
Region <- FeatureData$Region
Sca1 <- FeatureData$Sca1
Ckit <- FeatureData$Ckit

# We need to omit these before PCA
FeatureData$Region <- NULL 
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


# Center and normalize expression data.


alp <- 0.01

logCkit <- log10(Ckit)
qCkit <- c(log10(quantile(Ckit,alp)),log10(quantile(Ckit,1-alp)))

logSca1 <- log10(Sca1)
qSca1<- c(log10(quantile(Sca1,alp)),log10(quantile(Sca1,1-alp)))


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

## Bi-Plot
pdat <- as.data.frame(data.pca$x)
pdat$Region <- Region
pdat$cKit <- Ckit
pdat$Sca1 <- Sca1

g <- ggplot(pdat,aes(x=PC1,y=PC2,color=Sca1))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=Sca1Cols,trans="log",limits=10^qSca1,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK_PC1vPC2_Sca1Expression.pdf',width=2.25,height=2.25,units="in")

g <- ggplot(pdat,aes(x=PC1,y=PC2,color=Ckit))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=CkitCols,trans="log",limits=10^qCkit,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK_PC1vPC2_CKitExpression.pdf',width=2.25,height=2.25,units="in")



g <- ggplot(pdat,aes(x=PC1,y=PC3,color=Sca1))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=Sca1Cols,trans="log",limits=10^qSca1,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK_PC1vPC3_Sca1Expression.pdf',width=2.25,height=2.25,units="in")

g <- ggplot(pdat,aes(x=PC1,y=PC3,color=Ckit))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=CkitCols,trans="log",limits=10^qCkit,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK_PC1vPC3_CKitExpression.pdf',width=2.25,height=2.25,units="in")



g <- ggplot(pdat,aes(x=PC2,y=PC3,color=Sca1))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=Sca1Cols,trans="log",limits=10^qSca1,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK_PC2vPC3_Sca1Expression.pdf',width=2.25,height=2.25,units="in")

g <- ggplot(pdat,aes(x=PC2,y=PC3,color=Ckit))+
  geom_point(alpha=0.3,size=1,shape=16)+
  coord_fixed(ratio=1,xlim=c(-25,10),ylim=c(-15,20))+
  theme_bw()+
  scale_color_gradientn(colors=CkitCols,trans="log",limits=10^qCkit,oob=squish)+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK_PC2vPC3_CKitExpression.pdf',width=2.25,height=2.25,units="in")



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
                      zaxis = list(title = 'PC3'),
                      camera = list(eye = list(x = -1.25, y = 1.25, z = 1.25))))

p