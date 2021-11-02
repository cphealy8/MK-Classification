clc; clear; close all;
%% Load the raw data set.
fname = 'MK_Cultured_BF_Live.mat'; % Filename
fdir = fullfile('..','Data','MK','Raw',fname); % Directory
load(fdir);
% The file that is loaded is stored to the table named RawDat.

% Extract a few useful variables. 
Feats = RawDat.Properties.VariableNames; % Extract the feature names
DatArr = table2array(RawDat); % Array version of the data.

%% Eliminate non-descriptive features
% Features that do not vary between examples are useless. Remove them.
[DatArr] = OptimizeFeat(DatArr);

% The object ID is also a non-descript feature. Store it to apply the
% labels later but remove it from the feature set. 
obInd = DatArr(:,1); % Store
Feats(1)=[];         % Remove
DatArr(:,1) = [];    % Remove

% Determine the dimensions of the data set. 
[nExs,nFeats] = size(RawDat); 

%% Normalize the data set
% The magnitude of feature values can vary widely between features.
% Normalize each feature set so that features can be compared. 
NormDatArr = FeatNorm(DatArr);

%% Append the labels
% Each example has a label applied to it. In this case megakaryocyte (1) or
% not megakaryocyte (-1). Append these labels as the first column to the
% data set. 
lfile = 'MK_Cultured_Labels_R7.xlsx'; % Label File name
ldir = fullfile('..','Data','MK','Raw',lfile); % Label directory
% Read the label file. Index indicates which example has a positive label.
% All other labels are assumed to be negative. 
trueobs = xlsread(ldir); % Object Indices where the label is true.
% Convert index of the object to the index in the data array. 
trueInd = ismember(obInd,trueobs); 
% Assign the labels
labs = -1*ones(nExs,1); % Default label is false.
labs(trueInd)=1;

DatFull = [labs NormDatArr]; % Append the labels
nFeats = length(Feats);
Feats = ['Label', Feats];
%% Split the dataset
% Note this function converts the data set into a standard LibSVM format.
TrainFrac = 0.8; % Fraction of the data to be used in training/cross-validation.
CrossSets = 5; % Number of cross validation sets. 
[TrainDat,TestDat,CrossTrain,CrossTest] = DataSplit(DatFull,TrainFrac,CrossSets,'LibSVM');
[TrainArr,TestArr] = DataSplit(DatFull, TrainFrac,CrossSets,'Array');
%% Save the data
sname = 'MK_Cultured_BF_Live_Processed.mat';
sdir = fullfile('..','Data','MK','Processed',sname);
save(sdir,'TrainDat','TestDat','CrossTest','CrossTrain','Feats','nFeats','TrainArr','TestArr');

%% Compute majority baseline
MB = MajBase(TrainDat.Labs);
