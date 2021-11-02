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
R = 10.^[1:-0.5:-9]; % Learning Rates

T = 1:Tmax; % Epochs
Seed = 1:length(CrossTrain); % Random Seed for shuffling the data set
                             % between epochs
cnt = 0;
cntmax = length(R)*length(CrossTrain)*length(T);

wbar = waitbar(cnt/cntmax,'Optimizing Hyperparameters');
for Ri=1:length(R)
    for xi =1:length(CrossTrain)
        % Train to obtain weights
        [~,~,aVal] = MyPercep(CrossTrain{xi},R(Ri),Tmax,Seed(xi));
        % Test against left out set to obtain accuracy.
        for Ti = 1:length(T)
            
            wt = aVal(:,Ti);        % Weights for a given no. of epochs
            py = PerceptronRead(CrossTest{xi},wt,nFeats); % Predicted labels
            y = CrossTest{xi}.Labs; % Actual label
            
            % Compute the accuracy of each prediction.
            [accu(Ri,Ti,xi)] = ML_Accuracy(y,py); 
            [p(Ri,Ti,xi),r(Ri,Ti,xi),F1(Ri,Ti,xi)] = MLEval(y,py);

            cnt=cnt+1; % Update counter
            waitbar(cnt/cntmax,wbar,'Optimizing Hyperparameters');
        end
    end
end
% Average across the folds to get the average validation accuracy
F1Ave = mean(F1,3);
pAve = mean(p,3);
rAve = mean(r,3);

% Find the maximum validation accuracy
[MaxValAccuR,MaxRInds] = max(F1Ave,[],1);
[MaxValAccu,MaxTInd] = max(MaxValAccuR);
MaxRInd = MaxRInds(MaxTInd);
MaxR = R(MaxRInd);
MaxT = T(MaxTInd);

[maxF1,maxInd] = max(F1Ave(:));
rL = rAve(:);
pL = rAve(:);
maxr = rL(maxInd);
maxp = pL(maxInd);


% Display

s=surf(T,log10(R),F1Ave); hc=colorbar; shading interp; s.EdgeColor = 'k';
hold on
plot3(MaxT,log10(MaxR),MaxValAccu,'or','MarkerSize',10,'LineWidth',2);
hold off
axis tight
view(0,90)
xlabel('No. of Epochs');
ylabel('Log Learning Rate');
ylabel(hc,'Validation Accuracy');

%% Training
% Train using the optimal hyperparameters and the full training set.
waitbar(0,wbar,'Training');
[~,~,aTrain] = MyPercep(TrainDat,MaxR,MaxT,Seed(end)+1);
wt = aTrain(:,MaxT); % The classifier after training. 

%% Test against Test set using optimal weight vector
waitbar(0,wbar,'Testing');
y = TestDat.Labs; % Actual Label
py = PerceptronRead(TestDat,wt,nFeats); % Predicted labels
[TestAccu,MBase,Ratio] = ML_Accuracy(y,py);
[tp,tr,tF1] = MLEval(y,py);
delete(wbar);

% Print to Console
fprintf('-----Average Perceptron Results-----\n')
fprintf('Optimal Hyperparameters: T = %1.0f R=%1.2e\n',MaxT,MaxR)
fprintf('Validation: P=%1.2e, R=%1.2e, and F=%1.2e\n',maxp,maxr,maxF1)
fprintf('Testing: P=%1.2e, R=%1.2e, and F=%1.2e\n',tp,tr,tF1)
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