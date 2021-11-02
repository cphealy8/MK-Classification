load("../Data/MK/Processed/MK_Cultured_Data.RData")
source("evplot.R")
library(rgl)
datset <- `MK_Cultured_BF+Hoescht_Live`

# Remove problematic variables.
# These are either sytem variables (e.g. flow speed), zero variables (variables whose values don't change)
# or variables not associated with the morphology of the cell (e.g. background intensity)
datset$Spot.Distance.Min_M01 <- NULL
datset$Saturation.Count_M01_Brightfield <- NULL
datset$Saturation.Percent_M01_Brightfield <- NULL
datset$Time <- NULL
datset$Flow.Speed <- NULL
datset$Bkgd.Mean_Brightfield <- NULL
datset$Bkgd.StdDev_Brightfield <- NULL
datset$Objects.per.mL <- NULL
datset$Objects.per.sec <- NULL
datset$Spot.Distance.Min_M07 <- NULL
datset$Saturation.Count_M07_Brightfield <- NULL
datset$Saturation.Percent_M07_Brightfield <- NULL
datset$Saturation.Count_M07_Hoechst.33342 <- NULL
datset$Saturation.Percent_M07_Hoechst.33342 <- NULL
datset$Max.Contour.Position_M07_Hoechst.33342 <- NULL



data.pca <- prcomp(datset,center = TRUE,scale. = TRUE) # This is the actual PCA

summary(data.pca) # This displays the results of the PCA

# You will obtain 9 principal components (PC1-9). 
# Each explains a percentage of the toal variation in the dataset (proportion of variance).

# Plotting PCA
library(ggbiplot)

ggbiplot(data.pca,obs.scale=1,var.scale=1,var.axes=FALSE,alpha=0.05)

# To get the relationship/correlation between the variables and the PCs look at.
rcorr <- data.frame(abs(data.pca$rotation))
rcorr <- rcorr[order(rcorr$PC2),]

loadings <- data.pca$rotation
scores <- data.pca$x

correlations <- t(loadings)*data.pca$sdev
plot(data.pca,type="l",main="")

ev <- data.pca$sdev^2
evplot(ev)

plot3d(scores[,1:3],size=2.5)