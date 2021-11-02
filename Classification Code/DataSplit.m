function [TrainDatOut,TestDatOut,CrossTrain,CrossTest] = DataSplit(DataIn,TrainFrac,CrossSets,Type)
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

% Extract some useful values
[nExs,~] = size(DataIn); % No. of examples.

% First randomly shuffle the data examples. 
rng(8); % Set a random seed, the number doesn't matter you just want to
        % to make sure that the shuffling is consistent. 
ShuffDatArr = DataIn(randperm(size(DataIn,1)),:);

TrEndInd = round(nExs*TrainFrac); % End index of training set.
% Adjust end index of training set until each cross validation set is the
% same size. 
while rem(TrEndInd,CrossSets)
    TrEndInd = TrEndInd -1;
end

TrainDat = ShuffDatArr(1:TrEndInd,:);    % Training Data Set
TestDat = ShuffDatArr(TrEndInd+1:end,:); % Testing Data Set
crossWid = length(TrainDat)/CrossSets; % Width of a cross set (test).

switch Type
    case 'Array'
        for i=1:CrossSets
            testStart = 1+(i-1)*crossWid;
            testEnd = i*crossWid;
            testInds = testStart:testEnd;
            CrossTestOut(:,:,i) = TrainDat(testInds,:);

            tempTrain = TrainDat;
            tempTrain(testInds,:)=[];
            CrossTrainOut(:,:,i) = tempTrain;
        end
        TrainDatOut = TrainDat;
        TestDatOut = TestDat;
        
    case 'LibSVM'
        for i=1:CrossSets
            testStart = 1+(i-1)*crossWid;
            testEnd = i*crossWid;
            testInds = testStart:testEnd;
            CrossTestOut{i} = arr2LibSVM(TrainDat(testInds,:));

            tempTrain = TrainDat;
            tempTrain(testInds,:)=[];
            CrossTrainOut{i} = arr2LibSVM(tempTrain);
        end

        TrainDatOut = arr2LibSVM(TrainDat);
        TestDatOut = arr2LibSVM(TestDat);
end

end

