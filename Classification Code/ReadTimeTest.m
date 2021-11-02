clc; clear; close all;

fname = 'MK_Cultured_BF+Hoescht_Live_Processed';
fdir = fullfile('..','Data','MK','Processed',fname);
load(fdir);
uniqueInds = 1:nFeats;
nEx = length(TestDat.Labs);

% An example weight
nreps = 1000;

% Perceptron Read
for n = 1:nreps
    wt = rand(nFeats+1,1)*2-1;

    tic
    pyP = PerceptronRead(TestDat,wt,nFeats); % Predicted labels
    readtimeP(n) = toc/nEx; % Readtime per example
    
    tic
    pyS = SVMRead(TestDat,wt,uniqueInds);
    readtimeS(n) = toc/nEx; % Readtime per example
end

%% Statistics
medP = median(readtimeP)*1e6; % [=] msec
iqrP = iqr(readtimeP)*1e6; % [=] msec

medS = median(readtimeS)*1e6; % [=] msec
iqrS = iqr(readtimeS)*1e6; % [=] msec

%% counts
nPos = sum(TestDat.Labs==1);
nNeg = sum(TestDat.Labs==-1);

rec = 0.25;
prec = 0.15;
TP = nPos*rec;
FN = nPos-TP;
FP = TP*(1-prec)/prec;
TN = nNeg-FP;
