clear; close all;
fname = 'MK_Cultured_BF+Hoescht_Live_Processed';
fdir = fullfile('..','Data','MK','Processed',fname);
load(fdir);

%Reconstruct full data
FullDat.Inds = [TrainDat.Inds; TestDat.Inds];
FullDat.Vals = [TrainDat.Vals; TestDat.Vals];
FullDat.Labs = [TrainDat.Labs; TestDat.Labs];

% Parameters
Ro = 10.^([-2:-0.5:-5]);
 C = 10.^([2:-0.5:-2]);
Tmax = 10; % Epoch
oFracs = [0.18 0.2 0.22 0.24];
uniqueInds = 1:nFeats;
clear TestDat TrainDat CrossTest CrossTrain

%% Split the data
[TrainDat,TestDat,CrossTrain,CrossTest] = DataSplit2(FullDat,0.8,5);


%%
cnt = 0;
pcnt = 0;
cntmax = length(Ro)*length(C)*5*Tmax*length(oFracs);
wbar = waitbar(0,'Cross Validation');
%% Oversample  
for io = 1:length(oFracs)
for ir = 1:length(Ro)
    for iC = 1:length(C)
        for iset =1:length(CrossTrain)
            curTrain = oversample(CrossTrain{iset},1,oFracs(io));
            [w{ir,iC,io,iset},T] = ...
                SVMTrain(curTrain,Tmax,C(iC),Ro(ir),uniqueInds);
            for iT = 1:Tmax
                curW = w{ir,iC,io,iset}(:,iT);
                [py,~,p(ir,iC,iT,io,iset),...
                     r(ir,iC,iT,io,iset),...
                     F1(ir,iC,iT,io,iset)] = ...
                     SVMRead(CrossTest{iset},curW,uniqueInds);
                cnt = cnt+1;
                
                if iset==1
                    pcnt = pcnt+1;
                    pT(pcnt) = iT;
                    pRo(pcnt) = Ro(ir);
                    pC(pcnt) = C(iC);
                    pO(pcnt) = oFracs(io);
                end
                waitbar(cnt/cntmax)
            end
        end
    end
end
end

close(wbar)

F1Ave = mean(F1,5);
pAve = mean(p,5);
rAve = mean(r,5);

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
maxOfrac = pO(maxInd);

%% Display results
for n = 1:length(oFracs)
    curF1  = F1Ave(:,:,:,n);
    cropP = 1:numel(curF1);
    cRo = pRo(cropP);
    cC = pC(cropP);
    cT = pT(cropP);
    subplot(ceil(length(oFracs)/3),3,n);
    scatter3(cRo,cC,cT,75,curF1(:),'filled','MarkerFaceAlpha',0.5,'MarkerEdgeColor','k')    % draw the scatter plot
    ax = gca;
    view([-82 23])
    ax.XScale='log';
    ax.YScale = 'log';
    caxis([minF1 maxF1]);

    xlabel('Initial Learning Rate')
    ylabel('Regularization Parameter')
    title(sprintf('Oversampling Ratio: %1.3f',oFracs(n)))
    zlabel('Epoch')
end
subplot(ceil(length(oFracs)/3),3,n+1)
cb = colorbar;   % create and label the colorbar
cb.Label.String = 'Cross Validation Accuracy';

%% Train using Optimal Hyperparameters and Full Training Set
% Undersample with optimal ratio
TrainDat = oversample(TrainDat,1,maxOfrac);
wF = SVMTrain(TrainDat,maxT,maxRo,maxC,uniqueInds);
wTrain = wF(:,end);

%% Test the optimal classifier.
pyF = SVMRead(TestDat,wTrain,uniqueInds);
trueY = TestDat.Labs;

[accuF,mbase,ratio] = ML_Accuracy(trueY,pyF);
[pFin,rFin,F1Fin] = MLEval(trueY,pyF);

% Print to Console
fprintf('-----SVM Results-----\n')
fprintf('Optimal Hyperparameters: T = %1.0f, C=%1.2e, Ro=%1.2e, Rat=%1.2e\n',maxT,maxC,maxRo,maxOfrac)
fprintf('Validation: P=%1.2e, R=%1.2e, and F=%1.2e\n',maxp,maxr,maxF1)
fprintf('Testing: P=%1.2e, R=%1.2e, and F=%1.2e\n',pFin,rFin,F1Fin)
