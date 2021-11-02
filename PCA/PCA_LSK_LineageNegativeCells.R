# Load Data and source files
load("../Data/LSK/LSK_All.RData")

source("evplot.R")
library(rgl)
library(devtools)
install_github("vqv/ggbiplot")
library(ggbiplot)

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
FeatureData$Region <- NULL # We need to omit this before PCA
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

### EV Plot
ev <- data.pca$sdev^2
evplot(ev)


### PC VS. VARIANCE PLOT (SCREE PLOT) ### 
plot(data.pca,type="l",main="")


ManCols <- c('#000000','#336633','#ff3333','#336699')
ManShapes <- c(17,18,19,15)
## Bi-Plot
pdat <- as.data.frame(data.pca$x)
pdat$Region <- Region

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
ggsave('LSK_PC1vPC2.pdf',width=2.25,height=2.25,units="in")

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
ggsave('LSK_PC1vPC3.pdf',width=2.25,height=2.25,units="in")

g <- ggplot(pdat,aes(x=PC2,y=PC3,color=Region,shape=Region))+
  geom_point(size=0.5,alpha=0.3)+
  stat_ellipse(level=0.99,size=1,color="white")+
  stat_ellipse(level=0.99,size=0.5)+
  scale_color_manual(values=ManCols)+
  scale_shape_manual(values=ManShapes)+
  coord_fixed(ratio=1,xlim=c(-15,20),ylim=c(-15,20))+
  theme_bw()+
  theme(text = element_text(size=8),legend.position="none")
print(g)
ggsave('LSK_PC2vPC3.pdf',width=2.25,height=2.25,units="in")


# ### TRIPLOT ###
# #GroupCols <- c("#e41a1c","#377eb8","#4daf4a","#984ea3","#ff7f00") # Color Brewer Set 1
# GroupCols <- c("#fc8d62","#8da0cb","#e78ac3","#a6d854") # Color Brewer Set 2
# 
# plot3d(scores[,1:3],size=6,col=GroupCols[as.integer(FeatureData$Region)-1],alpha=0.5)
# text3d(loadings[,1:3], texts=rownames(loadings), col="red")
# coords <- NULL
# for (i in 1:nrow(loadings)) {
#   coords <- rbind(coords, rbind(c(0,0,0),loadings[i,1:3]))}
# lines3d(coords, col="red", lwd=4)


### PC/VARIABLE CORRELATIONS ###
# rcorr <- data.frame(abs(data.pca$rotation))
rcorr <- data.frame(data.pca$rotation)
rcorr <- rcorr[order(rcorr$PC1),]

nvars <- ncol(rcorr)
cDat <- data.frame(PC =c(rep('PC1',nvars),rep('PC2',nvars),rep('PC3',nvars)))

rcorr <- rcorr[order(rcorr$PC1),]
cvars <- tail(rownames(rcorr),nvars)
ccorrs <- tail(rcorr$PC1,nvars)

rcorr <- rcorr[order(rcorr$PC1),]
cvars <- c(cvars,tail(rownames(rcorr),nvars))
ccorrs <- c(ccorrs,tail(rcorr$PC2,nvars))

rcorr <- rcorr[order(rcorr$PC1),]
cvars <- c(cvars,tail(rownames(rcorr),nvars))
ccorrs <- c(ccorrs,tail(rcorr$PC3,nvars))
   
cDat$Vars <- cvars
cDat$Correlation <- ccorrs

SizeFeats  <- c('Area','Diameter','Height','Length','Major.Axis.Intensity','Minor.Axis.Intensity','Major.Axis','Minor.Axis','Perimeter','Spot.Area.Min','Thickness.Min','Thickness.Max','Width')
ShapeFeats <- c('Aspect.Ratio','Aspect.Ratio.Intensity','Circularity','Compactness','Elongatedness','Lobe.Count','Shape.Ratio','Symmetry.2','Symmetry.3','Symmetry.4')
TextureFeats<-c('BDI.R3','BDI.R7','Contrast','Std.Dev','Modulation','Spot.Count','Spot.Distance.Min')

FeatTypes <- (rep('None',nrow(cDat)))
FeatTypes[is.element(cDat$Vars,SizeFeats)]= 'Size'
FeatTypes[is.element(cDat$Vars,ShapeFeats)]= 'Shape'
FeatTypes[is.element(cDat$Vars,TextureFeats)]= 'Texture'
cDat$Type <- FeatTypes
cDat$ID <- rep(seq(1,29),3)

# g2 <- ggplot(cDat,aes(x=reorder(Vars,-Correlation),y=Correlation,fill=PC))+
#   geom_bar(stat="identity")+
#   facet_grid(.~PC)+
#   theme(axis.text.x = element_text(angle = 90, hjust = 1))
# print(g2)

g4 <- ggplot(subset(cDat,PC=="PC1"),aes(x=reorder(ID,-Correlation),y=Correlation,fill=Type))+
  geom_bar(stat="identity")+
  scale_y_continuous(limits=c(0,0.5))+
  theme_bw()+
  theme(text = element_text(size=5),axis.title.x=element_blank(),legend.position="none")
print(g4)
ggsave('PCA1_Corrs.pdf',width=2.5,height=1,units='in')

g5 <- ggplot(subset(cDat,PC=="PC2"),aes(x=reorder(ID,-Correlation),y=Correlation,fill=Type))+
  geom_bar(stat="identity")+
  scale_y_continuous(limits=c(0,0.5))+
  theme_bw()+
  theme(text = element_text(size=5),axis.title.x=element_blank(),legend.position="none")
print(g5)
ggsave('PCA2_Corrs.pdf',width=2.5,height=1,units='in')

g6 <- ggplot(subset(cDat,PC=="PC3"),aes(x=reorder(ID,-Correlation),y=Correlation,fill=Type))+
  geom_bar(stat="identity")+
  scale_y_continuous(limits=c(0,0.5))+
  theme_bw()+
  theme(text = element_text(size=5),axis.title.x=element_blank(),legend.position="none")
print(g6)
ggsave('PCA3_Corrs.pdf',width=2.5,height=1,units='in')

# g <- ggplot(cDat,aes(x=reorder(Vars,-Correlation),y=Correlation,fill=Type))+
#   geom_bar(stat="identity")+
#   facet_grid(.~PC)
# print(g)

### COMBINE ALLLLLLLL ###
ndat <- data.frame(Feature = subset(cDat,PC=="PC1")$Vars)
ndat$Type <- subset(cDat,PC=="PC1")$Type
ndat$PC1 <- subset(cDat,PC=="PC1")$Correlation
ndat$PC2 <- subset(cDat,PC=="PC2")$Correlation
ndat$PC3 <- subset(cDat,PC=="PC3")$Correlation
ndat$ID <- rownames(ndat)

g <- ggplot(ndat,aes(x=PC1,y=PC2,color=Type,label=Feature))+
  geom_text(hjust=0, nudge_x=0.005)+
  geom_point()+
  coord_fixed(ratio=1)+
  theme_bw()+
  theme(text = element_text(size=5),legend.position="none")
print(g)
ggsave('Loadings_PC1vPC2.pdf',width=90,height=60,units="mm")
print(g)

g <- ggplot(ndat,aes(x=PC1,y=PC3,color=Type,label=Feature))+
  geom_text(hjust=0, nudge_x=0.005)+
  geom_point()+
  coord_fixed(ratio=1)+
  theme_bw()+
  theme(text = element_text(size=5),legend.position="none")
print(g)
ggsave('Loadings_PC1vPC3.pdf',width=90,height=60,units="mm")
print(g)

g <- ggplot(ndat,aes(x=PC2,y=PC3,color=Type,label=Feature))+
  geom_text(hjust=0, nudge_x=0.005)+
  geom_point()+
  coord_fixed(ratio=1)+
  theme_bw()+
  theme(text = element_text(size=5),legend.position="none")
print(g)
ggsave('Loadings_PC2vPC3.pdf',width=90,height=60,units="mm")
print(g)


###
# library(plotly)
# t <- list(
#   family = "sans serif",
#   size = 14,
#   color = toRGB("grey50"))
# 
# p <- plot_ly(ndat,x = ~PC1, y=~PC2, z=~PC3, text=~ID, color=~Type) %>%
#   add_markers() %>%
#   add_text(textfont=t, textposition = "top right") %>%
#   layout(scene = list(xaxis= list(title = 'PC1'),
#                       yaxis= list(title = 'PC2'),
#                       zaxis= list(title = 'PC3')))
# print(p)