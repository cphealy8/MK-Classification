clear; close all;
fname = 'MK_Cultured_BF+Hoescht_Live_Processed';
fdir = fullfile('..','Data','MK','Processed',fname);
load(fdir);


%Reconstruct full data
FullDat.Inds = [TrainDat.Inds; TestDat.Inds];
FullDat.Vals = [TrainDat.Vals; TestDat.Vals];
FullDat.Labs = [TrainDat.Labs; TestDat.Labs];

% Parameters
Ro = 10.^(0:-0.5:-3);
 C = 10.^(2:-0.5:-2);
Tmax = 20; % Epoch
uniqueInds = 1:nFeats;
clear TestDat TrainDat CrossTest CrossTrain

% Split the data
[TrainDat,TestDat,CrossTrain,CrossTest] = DataSplit2(FullDat,0.8,5);


%%
cnt = 0;
pcnt = 0;
cntmax = length(Ro)*length(C)*5*Tmax;
wbar = waitbar(0,'Cross Validation');

for ir = 1:length(Ro)
    for iC = 1:length(C)
        for iset =1:length(CrossTrain)
            [w,T] = ...
                SVMTrain(CrossTrain{iset},Tmax,C(iC),Ro(ir),uniqueInds);
            for iT = 1:Tmax
                curW = w(:,iT);
                [py,~,p(ir,iC,iT,iset),...
                     r(ir,iC,iT,iset),...
                     F1(ir,iC,iT,iset)] = ...
                     SVMRead(CrossTest{iset},curW,uniqueInds);
                cnt = cnt+1;
                
                if iset==1
                    pcnt = pcnt+1;
                    pT(pcnt) = iT;
                    pRo(pcnt) = Ro(ir);
                    pC(pcnt) = C(iC);
                end
                waitbar(cnt/cntmax)
                clear curW
            end
            clear w
        end
    end
end

close(wbar)

F1Ave = mean(F1,4);
pAve = mean(p,4);
rAve = mean(r,4);

minF1 = min(F1Ave(:));
[maxF1,maxInd] = max(F1Ave(:));
rAll = rAve(:);
maxr = rAll(maxInd);
pAll = pAve(:);
maxp = pAll(maxInd);

maxT = pT(maxInd);
maxRo = pRo(maxInd);
maxC = pC(maxInd);

%% Display results
scatter3(pRo,pC,pT,75,F1Ave(:),'filled','MarkerFaceAlpha',0.5,'MarkerEdgeColor','k')    % draw the scatter plot
ax = gca;
ax.XScale='log';
ax.YScale = 'log';
caxis([minF1 maxF1]);

xlabel('Initial Learning Rate')
ylabel('Regularization Parameter')
zlabel('Epoch')
view([-82 23])

cb = colorbar;   % create and label the colorbar
cb.Label.String = 'Cross Validation Accuracy';

%% Train using Optimal Hyperparameters and Full Training Set
% Undersample with optimal ratio
wF = SVMTrain(TrainDat,maxT,maxRo,maxC,uniqueInds);
wTrain = wF(:,end);

%% Test the optimal classifier.
pyF = SVMRead(TestDat,wTrain,uniqueInds);
trueY = TestDat.Labs;

[accuF,mbase,ratio] = ML_Accuracy(trueY,pyF);
[pFin,rFin,F1Fin] = MLEval(trueY,pyF);

% Print to Console
fprintf('-----SVM Results-----\n')
fprintf('Optimal Hyperparameters: T = %1.0f, C=%1.2e, Ro=%1.2e\n',maxT,maxC,maxRo)
fprintf('Validation: P=%1.2e, R=%1.2e, and F=%1.2e\n',maxp,maxr,maxF1)
fprintf('Testing: P=%1.2e, R=%1.2e, and F=%1.2e\n',pFin,rFin,F1Fin)
