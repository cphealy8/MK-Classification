clc; clear; close all;
%% Load the Data
% Example data
% fname = 'testDat.mat';
% fdir = fullfile('..','Data','Example',fname);
% Experimental Data
% fname = 'MK_Cultured_BF_Live_Processed';
fname = 'MK_Cultured_BF+Hoescht_Live_Processed';
fdir = fullfile('..','Data','MK','Processed',fname);
load(fdir);
%Reconstruct full data
FullDat.Inds = [TrainDat.Inds; TestDat.Inds];
FullDat.Vals = [TrainDat.Vals; TestDat.Vals];
FullDat.Labs = [TrainDat.Labs; TestDat.Labs];

clear TestDat TrainDat CrossTest CrossTrain

%% Split the data
[TrainDat,TestDat,CrossTrain,CrossTest] = DataSplit2(FullDat,0.8,5);

%% HyperParameter Tuning
Tmax = 20; % Max no. of epochs
R = 10.^[0:-1:-9]; % Learning Rates
oFrac = [NaN 0.1 0.2 0.3 0.4 0.5]; % Ovserampling fraction

T = 1:Tmax; % Epochs
Seed = 1:length(CrossTrain); % Random Seed for shuffling the data set
                             % between epochs

cnt = 0;
pcnt = 0;
cntmax = length(R)*length(CrossTrain)*length(T)*length(oFrac);

wbar = waitbar(cnt/cntmax,'Optimizing Hyperparameters');
for io =1:length(oFrac)
for Ri=1:length(R)
    for iset =1:length(CrossTrain)
        curTrain = oversample(CrossTrain{iset},1,oFrac(io));
        % Train to obtain weights
        [wVal] = MyPercep(curTrain,R(Ri),Tmax,Seed(iset));
        % Test against left out set to obtain accuracy.
        for Ti = 1:length(T)
            
            wt = wVal(:,Ti);        % Weights for a given no. of epochs
            py = PerceptronRead(CrossTest{iset},wt,nFeats); % Predicted labels
            y = CrossTest{iset}.Labs; % Actual label
            
            % Compute the accuracy of each prediction.
            [accu(Ri,Ti,io,iset)] = ML_Accuracy(y,py); 
            [p(Ri,Ti,io,iset),r(Ri,Ti,io,iset),F1(Ri,Ti,io,iset)] = MLEval(y,py);
            
            cnt=cnt+1; % Update counter
            waitbar(cnt/cntmax,wbar,'Optimizing Hyperparameters');
            
                if iset==1
                    pcnt = pcnt+1;
                    pT(pcnt) = Ti;
                    pR(pcnt) = R(Ri);
                    
                    pO(pcnt) = oFrac(io);
                end
        end
    end
end
end

%%
% Average across the folds to get the average validation accuracy
F1Ave = mean(F1,4);
pAve = mean(p,4);
rAve = mean(r,4);


[maxF1,maxInd] = max(F1Ave(:));
rL = rAve(:);
pL = rAve(:);
maxr = rL(maxInd);
maxp = pL(maxInd);

MaxR = pR(maxInd);
MaxT = pT(maxInd);
MaxOfrac = pO(maxInd); 

%% Training
% Train using the optimal hyperparameters and the full training set.
TrainDat = oversample(TrainDat,1,MaxOfrac);

wTrain = MyPercep(TrainDat,MaxR,MaxT,Seed(end)+1);
wt = wTrain(:,MaxT); % The classifier after training. 

%% Test against Test set using optimal weight vector
y = TestDat.Labs; % Actual Label
tic
py = PerceptronRead(TestDat,wt,nFeats); % Predicted labels
readtime = toc*1000;
[TestAccu,MBase,Ratio] = ML_Accuracy(y,py);
[tp,tr,tF1] = MLEval(y,py);

% Print to Console
fprintf('-----Basic Perceptron Results-----\n')
fprintf('Optimal Hyperparameters: T = %1.0f R=%1.2e Ratio=%1.2e\n',MaxT,MaxR,MaxOfrac)
fprintf('Validation: P=%1.2e, R=%1.2e, and F=%1.2e\n',maxp,maxr,maxF1)
fprintf('Testing: P=%1.2e, R=%1.2e, and F=%1.2e\n',tp,tr,tF1)
fprintf('Readtime: %3.1f msec\n',readtime);
%% See how matlabs perceptron does.
% x = TrainArr(:,2:end)';
% t = TrainArr(:,1)';
% t(t==-1)=0;
% 
% net = perceptron;
% net = train(net,x,t);
% net.trainParam.epochs = MaxT
% view(net)
% y = net(x);
% 
% X = TestArr(:,2:end)';
% yt = TestArr(:,1)';
% 
% yp = net(X);
% 
% [accu,majB,ratio]=ML_Accuracy(yt,yp)