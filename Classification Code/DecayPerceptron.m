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
%% HyperParameter Tuning
Tmax = 20; % Max no. of epochs
R = 10.^[0:-0.5:-9]; % Learning Rates

T = 1:Tmax; % Epochs
Seed = 1:length(CrossTrain); % Random Seed for shuffling the data set
                             % between epochs

cnt = 0;
cntmax = length(R)*length(CrossTrain)*length(T);

wbar = waitbar(cnt/cntmax,'Optimizing Hyperparameters');

type = 'decay';
for Ri=1:length(R)
    for xi =1:length(CrossTrain)
        % Train to obtain weights
        [wVal] = MyPercep(CrossTrain{xi},R(Ri),Tmax,Seed(xi),'decay');
        % Test against left out set to obtain accuracy.
        for Ti = 1:length(T)
            
            wt = wVal(:,Ti);        % Weights for a given no. of epochs
            py = PerceptronRead(CrossTest{xi},wt,nFeats); % Predicted labels
            y = CrossTest{xi}.Labs; % Actual label
            
            % Compute the accuracy of each prediction.
            [accu(Ri,Ti,xi)] = ML_Accuracy(y,py); 
            
            cnt=cnt+1; % Update counter
            waitbar(cnt/cntmax,wbar,'Optimizing Hyperparameters');
        end
    end
end
% Average across the folds to get the average validation accuracy
ValAccu = mean(accu,3);

% Find the maximum validation accuracy
[MaxValAccuR,MaxRInds] = max(ValAccu,[],1);
[MaxValAccu,MaxTInd] = max(MaxValAccuR);
MaxRInd = MaxRInds(MaxTInd);
MaxR = R(MaxRInd);
MaxT = T(MaxTInd);

% Display

s=surf(T,log10(R),ValAccu); hc=colorbar; shading interp; s.EdgeColor = 'k';
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
wTrain = MyPercep(TrainDat,MaxR,MaxT,Seed(end)+1,type);
wt = wTrain(:,MaxT); % The classifier after training. 

%% Test against Test set using optimal weight vector
waitbar(0,wbar,'Testing');
y = TestDat.Labs; % Actual Label
py = PerceptronRead(TestDat,wt,nFeats); % Predicted labels
[TestAccu,MBase,Ratio] = ML_Accuracy(y,py);
delete(wbar);

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