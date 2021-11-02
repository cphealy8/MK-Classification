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
Tmax = 5; % Max no. of epochs
R = 10.^([0:-1:-4]); % Learning Rates
Mu = R;

T = 1:Tmax; % Epochs
Seed = 1:length(CrossTrain); % Random Seed for shuffling the data set
                             % between epochs

cnt = 0;
cntmax = length(R)*length(CrossTrain)*length(T)*length(Mu);
RS = [];
Mus = [];
Ts = [];
wbar = waitbar(cnt/cntmax,'Optimizing Hyperparameters');

type = 'decay';
for Mui = 1:length(Mu)
    for Ri=1:length(R)
        for xi =1:length(CrossTrain)
            % Train to obtain weights
            [wVal] = MyPercep(CrossTrain{xi},R(Ri),Tmax,Seed(xi),type,Mu(Mui));
            % Test against left out set to obtain accuracy.
            for Ti = 1:length(T)
                wt = wVal(:,Ti);        % Weights for a given no. of epochs
                py = PerceptronRead(CrossTest{xi},wt,nFeats); % Predicted labels
                y = CrossTest{xi}.Labs; % Actual label

                % Compute the accuracy of each prediction.
                [accu(Ri,Ti,Mui,xi)] = ML_Accuracy(y,py); 

                cnt=cnt+1; % Update counter
                waitbar(cnt/cntmax,wbar,'Optimizing Hyperparameters');
                
                hparams{Ri,Ti,Mui} = [R(Ri) T(Ti) Mu(Mui)];
            end
        end
    end
end
delete(wbar);

% Average across the folds to get the average validation accuracy
ValAccu = mean(accu,4);
% ValAccuS = ValAccu(:);
% 
% % Construct full parameter vectors
% MuS = sort(repmat(Mu,[1 length(T)*length(R)]),'Descend');
% RS = repmat(sort(repmat(R,[1 length(T)]),'Ascend'),[1 length(Mu)]);
% TS = repmat(T,[1 length(R)*length(Mu)]);
% 
% % Find the maximum validation accuracy
% [MaxValAccu,MaxInd]= max(ValAccuS);
% MaxT = TS(MaxInd);
% MaxR = RS(MaxInd);
% MaxMu = MuS(MaxInd);


[MaxValAccu, max_idx]=max(ValAccu(:));
[RMaxInd,TMaxInd,MuMaxInd]=ind2sub(size(ValAccu),max_idx);
MaxT = T(TMaxInd);
MaxR = R(RMaxInd);
MaxMu= Mu(MuMaxInd);

%% Display

% scatter3(RS,MuS,TS,40,ValAccuS,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeColor','k')    % draw the scatter plot
% hold on
% scatter3(MaxR,MaxMu,MaxT,35,'r','filled')
% hold off
% ax = gca;
% ax.XScale='log';
% ax.YScale = 'log';
% 
% view(-4,30)
% xlabel('Learning Rate')
% ylabel('Epoch')
% zlabel('Margin')
% 
% cb = colorbar;   % create and label the colorbar
% cb.Label.String = 'Validation Accuracy';

%% Training
% Train using the optimal hyperparameters and the full training set.
wTrain = MyPercep(TrainDat,MaxR,MaxT,Seed(end)+1,MaxMu);
wt = wTrain(:,MaxT); % The classifier after training. 

%% Test against Test set using optimal weight vector
y = TestDat.Labs; % Actual Label
py = PerceptronRead(TestDat,wt,nFeats); % Predicted labels
[TestAccu,MBase,Ratio] = ML_Accuracy(y,py);

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