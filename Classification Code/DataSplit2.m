function [TrainDat,TestDat,CrossTrain,CrossTest] = DataSplit2(dat,TrainFrac,CrossSets)
%DATASPLIT Split data into training, testing, and cross-validation sets.
%
%   [TrainDat,TestDat,CrossTest,CrossTrain] = DATASPLIT(DataIn,0.8,5)
%   shuffles then splits the input data set into 4 sets. TrainFrac
%   specifies the fraction of the data set to be used for training
%   (typically 0.8) while CrossSets specifies the number of cross
%   validation sets to be generated (typically 5). The function outputs the
%   training data set (TrainDat), the testing data set (TestDat), a
%   cross-validation testing set (CrossTest), and a cross validation
%   training set (CrossTrain). 

% First Randomly Shuffle the examples.
dat = ShuffleLib(dat);

nTot = length(dat.Labs);
nTrain = round(nTot*TrainFrac);

while rem(nTrain,CrossSets)
    nTrain = nTrain -1;
end
TrainInds = 1:nTrain;

TestInds = (nTrain+1):nTot;
TrainDat = LibIndex(dat,TrainInds);
TestDat = LibIndex(dat,TestInds);

% Generate Cross-Validation sets from the Training data.
crossWid = nTrain/CrossSets; % Width of a cross set (test).
for i = 1:CrossSets
    testStart = 1+(i-1)*crossWid;
    testEnd = i*crossWid;
    XTestInds = testStart:testEnd;
    CrossTest{i} = LibIndex(TrainDat,XTestInds);
    
    XTrainInds = TrainInds;
    XTrainInds(XTestInds)= [];
    CrossTrain{i} = LibIndex(TrainDat,XTrainInds);
end

end

