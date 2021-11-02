datset <- mtcars[,c(1:7,10,11)] # This is the dataset to be analyzed, the vector inside just omits categorical variables.

mtcars.pca <- prcomp(datset,center = TRUE,scale. = TRUE) # This is the actual PCA

summary(mtcars.pca) # This displays the results of the PCA

# You will obtain 9 principal components (PC1-9). 
# Each explains a percentage of the toal variation in the dataset (proportion of variance).

# Plotting PCA
library(devtools)
install_github("vqv/ggbiplot")
library(ggbiplot)

mtcars.country <- c(rep("Japan", 3), rep("US",4), rep("Europe", 7),rep("US",3)
                    ,"Europe", rep("Japan", 3), rep("US",4), rep("Europe", 3)
                    , "US", rep("Europe", 3))
ggbiplot(mtcars.pca,ellipse=TRUE,  labels=rownames(mtcars), groups=mtcars.country)

# To get the relationship/correlation between the variables and the PCs look at.
rcorr <- data.frame(abs(mtcars.pca$rotation)) # Use absolute value to also include strong negative
rcorr <- rcorr[order(rcorr$PC1),]

spacecar <- c(1000,60,50,500,0,0.5,2.5,0,1,0,0)

# mtcarsplus <- rbind(mtcars, spacecar)
mtcars.countryplus <- c(mtcars.country, "Jupiter")
# 
# mtcarsplus.pca <- prcomp(mtcarsplus[,c(1:7,10,11)], center = TRUE,scale. = TRUE)
# 
# ggbiplot(mtcarsplus.pca, obs.scale = 1, var.scale = 1, ellipse = TRUE, circle = FALSE, var.axes=TRUE, labels=c(rownames(mtcars), "spacecar"), groups=mtcars.countryplus)+
#   scale_colour_manual(name="Origin", values= c("forest green", "red3", "violet", "dark blue"))+
#   ggtitle("PCA of mtcars dataset, with extra sample added")+
#   theme_minimal()+
#   theme(legend.position = "bottom")


s.sc <- scale(t(spacecar[c(1:7,10,11)]), center= mtcars.pca$center)
s.pred <- s.sc %*% mtcars.pca$rotation


mtcars.plusproj.pca <- mtcars.pca
mtcars.plusproj.pca$x <- rbind(mtcars.plusproj.pca$x, s.pred)


# ggbiplot(mtcars.plusproj.pca, obs.scale = 1, var.scale = 1, ellipse = TRUE, circle = FALSE, var.axes=TRUE, labels=c(rownames(mtcars), "spacecar"), groups=mtcars.countryplus)+
#   scale_colour_manual(name="Origin", values= c("forest green", "red3", "violet", "dark blue"))+
#   ggtitle("PCA of mtcars dataset, with extra sample projected")+
#   theme_minimal()+
#   theme(legend.position = "bottom")

pdat <- as.data.frame(mtcars.pca$x)
pdat$vehicle <-rownames(pdat)

g <- ggplot(pdat,aes(x=PC1,y=PC2,label=vehicle))+geom_text()+geom_point()
print(g)