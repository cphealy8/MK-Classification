load("../Data/LSK/LSK_Labels.RData")
load("../Data/LSK/LSK_Data.RData")

FeatureData <- BM_LSK_BF
FeatureLabels <- LSK_Labels

nEx <- nrow(FeatureData)

# Assign categorical variables to each sample.
LinNeg <- factor(rep(FALSE,nEx),levels=c(TRUE,FALSE))
LinNeg[na.omit(FeatureLabels$LinNeg)] <- TRUE

Region <- factor(rep('R0',nEx),levels=c('R0','R1','R2','R3','R4'))
Region[na.omit(FeatureLabels$R1)] <- 'R1'
Region[na.omit(FeatureLabels$R2)] <- 'R2'
Region[na.omit(FeatureLabels$R3)] <- 'R3'
Region[na.omit(FeatureLabels$R4)] <- 'R4'