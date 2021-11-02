library(ggplot2)
library(ggfortify)
library(rgl)
library(ggplot2)
library(scales)
library(plyr)
library(dplyr)
library(sp)
library(PCDimension)

RAW <- read.csv("LSK_Combined.csv")


# Omit categorical variables before performing PCA
RAW$X<-NULL
RAW$Region[RAW$Region=='R1+TPO']='R1'
RAW$Region[RAW$Region=='R2+TPO']='R2'
RAW$Region[RAW$Region=='R3+TPO']='R3'
RAW$Region[RAW$Region=='R4+TPO']='R4'

# Subset if desired
LinNegDat <- subset(RAW,Region!='Lin+')
RAW <- subset(LinNegDat,Treatment=='TPO')
TPODat <- subset(LinNegDat,Treatment=='TPO')
NoTPODat <- subset(LinNegDat,Treatment=='NoTPO')

#-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.#
forPCA<-TPODat[seq(from=1,to=29)]

varMat <- var(forPCA)
vars <- varMat[1,]
outInds <- vars<10
#forPCA[,outInds]<-NULL

TPOPCA <- prcomp(forPCA,center=TRUE,scale=TRUE)
TPOScores <-as.data.frame(TPOPCA$x)
TPOLoadings <- as.data.frame(TPOPCA$rotation)
TPOCorrs <- as.data.frame(abs(t(t(TPOPCA$rotation)*TPOPCA$sdev)))

ExpVarTPO <- apply(TPOScores,2,var)/sum(apply(TPOScores,2,var))
ExpVarTPO <- as.data.frame(ExpVarTPO)
ExpVarTPO$Treatment <- 'TPO'
ExpVarTPO$PC <- rownames(ExpVarTPO)
colnames(ExpVarTPO)[1] <- "Explained_Variance"

TPOLoadings$Treatment <- 'TPO'
TPOLoadings$Feature <- rownames(TPOLoadings)
TPOLoadings$Magnitude <- sqrt(TPOLoadings$PC1^2+TPOLoadings$PC2^2)
TPOLoadings[order(TPOLoadings$Magnitude,decreasing=TRUE),]

TPOScores$Treatment <- 'TPO'
TPOScores$Region <- TPODat$Region
#-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.#


#-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.#
forPCA<-NoTPODat[seq(from=1,to=29)]

varMat <- var(forPCA)
vars <- varMat[1,]
#forPCA[,outInds]<-NULL

#
NoTPOPCA <- prcomp(forPCA,center=TRUE,scale=TRUE)
NoTPOScores <-as.data.frame(NoTPOPCA$x)
NoTPOCorrs <- as.data.frame(abs(t(t(NoTPOPCA$rotation)*NoTPOPCA$sdev)))

ExpVarNoTPO <- apply(NoTPOScores,2,var)/sum(apply(NoTPOScores,2,var))
ExpVarNoTPO <- as.data.frame(ExpVarNoTPO)
ExpVarNoTPO$Treatment <- 'No TPO'
ExpVarNoTPO$PC <- rownames(ExpVarNoTPO)
colnames(ExpVarNoTPO)[1] <- "Explained_Variance"

NoTPOLoadings <- as.data.frame(NoTPOPCA$rotation)
NoTPOLoadings$Treatment <- 'No TPO'
NoTPOLoadings$Magnitude <- sqrt(NoTPOLoadings$PC1^2+NoTPOLoadings$PC2^2)
NoTPOLoadings[order(NoTPOLoadings$Magnitude,decreasing=TRUE),]


NoTPOLoadings$Feature <- rownames(NoTPOLoadings)
NoTPOScores$Treatment <- 'No TPO'
NoTPOScores$Region <- NoTPODat$Region

#-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.#


#TPO USING PROJECTION#
forPCA<-TPODat[seq(from=1,to=29)]

varMat <- var(forPCA)
vars <- varMat[1,]
#forPCA[,outInds]<-NULL

s.sc <- scale(forPCA,center = NoTPOPCA$center)
ProjTPOScores <- s.sc %*% NoTPOPCA$rotation
ProjTPOScores <- as.data.frame(ProjTPOScores)
ProjTPOScores$Treatment <- 'TPO Projected'
ProjTPOScores$Region <- TPODat$Region

#-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.#


# Combine Scores
AllScores <- rbind(NoTPOScores,TPOScores)

TopNLoadings <-5
AllLoadings <- rbind(NoTPOLoadings[seq(from=1,to=TopNLoadings),],TPOLoadings[seq(from=1,to=TopNLoadings),])


# Broken Stick model to choose PCs
ncomps <- nrow(ExpVarNoTPO)
BSVals <- brokenStick(1:ncomps,ncomps)
ExpVarNoTPO$BrokenStick <- BSVals
ExpVarTPO$BrokenStick <- BSVals

AllExpVars <- rbind(ExpVarNoTPO,ExpVarTPO)
colnames(AllExpVars)[1] <- "Explained_Variance"
AllExpVars[order(AllExpVars$Explained_Variance,decreasing=TRUE),]

######################################################################################################


## PCA Score plot ##
LoadingScale=50
g1 <- ggplot(AllScores,aes(x=PC1,y=PC2))+
  #annotate("rect",xmin=binxmin,xmax=binxmax,ymin=binymin,ymax=binymax,fill="purple",alpha=0.2)+
  geom_hex(bins=50)+
  geom_point(data=AllLoadings,aes(x=PC1*LoadingScale,y=PC2*LoadingScale),shape=18)+
  geom_text(data=AllLoadings,aes(x=PC1*LoadingScale,y=PC2*LoadingScale,label=Feature,vjust=1))+
  scale_fill_distiller(palette = "Spectral")+
  facet_grid(.~Treatment)+
  theme(text = element_text(size=8))+
  theme_bw()
g1
ggsave('NewPCAFull_BiPlot.pdf',width=5.5,height=2.2,units="in")
####################
## Plot Loadings
# Add Label
TPOCorrs$Type ="Size";
#TPOCorrs$Type[14]="Shape"
#TPOCorrs$Type[15:18] ="Texture"
TPOCorrs$Type[14:23]="Shape"
TPOCorrs$Type[24:29]="Texture"
#TPOCorrs$ID = c(letters)[1:18];

TPOCorrs$ID = c(letters[1:13],"s","t","n",letters[21:26],"aa","o","p","q","ab","ac","r")

NoTPOCorrs$Type ="Size";
#NoTPOCorrs$Type[14]="Shape"
#NoTPOCorrs$Type[15:18] ="Texture"
NoTPOCorrs$Type[14:23]="Shape"
NoTPOCorrs$Type[24:29]="Texture"
#NoTPOCorrs$ID = c(letters)[1:18];
NoTPOCorrs$ID = c(letters[1:13],"s","t","n",letters[21:26],"aa","o","p","q","ab","ac","r")

g1a <- ggplot(NoTPOCorrs,aes(x=reorder(ID,-PC1),y=PC1,fill=Type))+
  geom_bar(stat="identity")+
  theme_bw()+
  ylim(0,1)+
  theme(text = element_text(size=8),axis.text.x=element_text(angle=0,size=6))
g1a
ggsave('NewPCAFull_NoTPO_PC1Corrs.pdf',width=2.75,height=1.1,units="in")

g1b <- ggplot(NoTPOCorrs,aes(x=reorder(ID,-PC2),y=PC2,fill=Type))+
  geom_bar(stat="identity")+
  theme_bw()+
  ylim(0,1)+
  theme(text = element_text(size=8),axis.text.x=element_text(angle=0,size=6))
g1b
ggsave('NewPCAFull_NoTPO_PC2Corrs.pdf',width=2.75,height=1.1,units="in")

g1c <- ggplot(TPOCorrs,aes(x=reorder(ID,-PC1),y=PC1,fill=Type))+
  geom_bar(stat="identity")+
  theme_bw()+
  ylim(0,1)+
  theme(text = element_text(size=8),axis.text.x=element_text(angle=0,size=6))
g1c
ggsave('NewPCAFull_TPO_PC1Corrs.pdf',width=2.75,height=1.1,units="in")

g1d <- ggplot(TPOCorrs,aes(x=reorder(ID,-PC2),y=PC2,fill=Type))+
  geom_bar(stat="identity")+
  theme_bw()+
  ylim(0,1)+
  theme(text = element_text(size=8),axis.text.x=element_text(angle=0,size=6))
g1d
ggsave('NewPCAFull_TPO_PC2Corrs.pdf',width=2.75,height=1.1,units="in")


###################################################
### Scree plot
g2 <- ggplot(AllExpVars,aes(x=reorder(PC,-Explained_Variance),y=Explained_Variance,group=Treatment))+
  geom_bar(stat="identity")+
  geom_point(aes(x=PC,y=BrokenStick),size=3,color="red",shape=18)+
  geom_line(aes(x=PC,y=BrokenStick),size=0.5,color="red")+
  facet_grid(.~Treatment)+
  theme_bw()+
  theme(text = element_text(size=8),axis.text.x=element_text(angle=90))
g2
ggsave('NewPCAFull_ScreePlot.pdf',width=5.5,height=2,units="in")


## Area vs. Circularity

binxmin = 300
binxmax = 1100
binymin = 0
binymax = 32

inBin <- between(LinNegDat$Area,binxmin,binxmax)&between(LinNegDat$Circularity,binymin,binymax)
LinNegDat$inBin <- inBin


g4 <- ggplot(LinNegDat,aes(x=Area,y=Circularity))+
  annotate("rect",xmin=binxmin,xmax=binxmax,ymin=binymin,ymax=binymax,alpha=0.2,fill="purple")+
  geom_hex(bins=50)+
  scale_fill_distiller(palette="Spectral")+
  facet_grid(.~Treatment)+
  theme_bw()+
  theme(text = element_text(size=8))
g4
ggsave('AreaVCircularityFull.pdf',width=5.5,height=2.2,units="in")

gates <- read.csv(file="GateCoordinates.csv")
colnames(gates) <- c('X','Y')

r1x <- c(687,699,765,1157,2921,8291,3262,1433,687)
r1y <- c(409,106,45,24,36,64,1047,470,409)
r2x <- c(687,779,1908,4707,3262,1433,687)
r2y <- c(409,9145,25629,1804,1047,470,409)
r3x <- c(82257,4707,1908,14030,82257)
r3y <- c(83854,1804,25629,357538,83854)
r4x <- c(82257,152898,355276,22176,8291,3262,4707,82257)
r4y <- c(83854,33254,4046,159,64,1047,1804,83854)

## Comparison to flow data
g5 <- ggplot(LinNegDat,aes(x=Ckit,y=Sca1,color=inBin))+
  geom_hex(bins=50,size=0.25)+
  scale_fill_distiller(palette="Spectral")+
  scale_x_log10()+
  scale_y_log10()+
  facet_grid(.~Treatment)+
  scale_color_manual(values=c("white","purple"))+
  annotate("path",r1x,r1y)+
  annotate("path",r2x,r2y)+
  annotate("path",r3x,r3y)+
  annotate("path",r4x,r4y)+
  theme_bw()+
  theme(text = element_text(size=8))
g5

ggsave('FlowComparisonFull.pdf',width=5.5,height=2.2,units="in")

## Ckit Sca1 Colored PC plot
LinNegDat$PC1 = AllScores$PC1
LinNegDat$PC2 = AllScores$PC2
TDat <-LinNegDat
remrows <- sample.int(nrow(TDat),round(nrow(TDat)*0.5))
TDat<-TDat[-remrows, ]

## Comparison to flow data
g7 <- ggplot(TDat,aes(x=PC1,y=PC2))+
  geom_point(aes(color=Sca1),shape=19)+
  scale_color_gradient(low='#000000',high="#0000ff" )+
  facet_grid(.~Treatment)+
  theme(text = element_text(size=8))
g7
ggsave('NewPCAFull_Sca1BiPlot.pdf',width=5.5,height=2.2,units="in")

g7a <- ggplot(TDat,aes(x=PC1,y=PC2))+
  geom_point(aes(color=Ckit),shape=19)+
  scale_color_gradient(low='#000000',high="#00ff00" )+
  facet_grid(.~Treatment)+
  theme(text = element_text(size=8))
g7a
ggsave('NewPCAFull_cKitBiPlot.pdf',width=5.5,height=2.2,units="in")

## Overlaps
R4NoTPO <- (LinNegDat$Region=='R1')&(LinNegDat$Treatment=='NoTPO')
inR4NoTPO <-R4NoTPO&(LinNegDat$inBin==TRUE)
noTPORat <- sum(inR4NoTPO)/sum(R4NoTPO)

R4TPO <- (LinNegDat$Region=='R1')&(LinNegDat$Treatment=='TPO')
inR4TPO <-R4TPO&(LinNegDat$inBin==TRUE)
TPORat <- sum(inR4TPO)/sum(R4TPO)

totInBinNoTPO <- sum(LinNegDat$inBin==TRUE&LinNegDat$Treatment=='NoTPO')
totInBinTPO <- sum(LinNegDat$inBin==TRUE&LinNegDat$Treatment=='TPO')



