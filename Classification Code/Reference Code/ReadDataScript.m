clc; clear; close all;

%% Cross Validation
% Load the data
% Read in the training data
TrainFile = fullfile('..','Data','diabetes_train.csv');
TrainDat = libSVMread(TrainFile);

% Read in the Test data
TestFile = fullfile('..','Data','diabetes_test.csv');
TestDat = libSVMread(TestFile);

% Read in the validation data
ndims = 0; % Initialize the ndims variable.

% Development set Initialize
DevTestDat.Labs = [];
DevTestDat.Vals = [];
DevTestDat.Inds = [];

for n=1:5
    % Filenaming
    fname = strcat('training',sprintf('0%d',n-1),'.csv');
    datFname = fullfile('..','Data','CVSplits',fname);
    
    % Read the data
    VTestDat{n} = libSVMread(datFname);
    
    % Update the development test set
    DevTestDat.Inds = [DevTestDat.Inds ;VTestDat{n}.Inds];
    DevTestDat.Vals = [DevTestDat.Vals ;VTestDat{n}.Vals];
    DevTestDat.Labs = [DevTestDat.Labs ;VTestDat{n}.Labs];
    % Update ndims
    datmax = max(cell2mat(VTestDat{n}.Inds));
    if datmax > ndims
        ndims = datmax;
    end

end

% Generate the validation training sets
VTrainDat = ValidationGen(VTestDat);

save(fullfile('..','Data','HW2_data.mat'),'TrainDat','TestDat','VTestDat','VTrainDat','ndims','DevTestDat')