% clc; clear; close all;
% clear
%% Load the Data
datfname = fullfile('..','Data','HW2_data.mat');
load(datfname);

r = [1,0.1,0.01]; % Learning Rates
mu = [1,0.1,0.01]; % Margin

Typ = 'decay';
%% Cross Validation
Tmax = 10; % Max no. of epochs
T = 1:Tmax; % Epochs
Seed = 1:length(VTrainDat); % Random Seed
for k = 1:length(mu)
    for n=1:length(r)
        for m =1:length(VTrainDat)
            % Train to obtain weights
            [wVal{n,k,m}] = MyPercep(VTrainDat{m},r(n),Tmax,Seed(m),Typ,mu(k));

            % Test against left out set to obtain accuracy.
            for t = 1:length(T)
                wt = wVal{n,m}(:,t);     % Weights
                py = PerceptronRead(VTestDat{m},wt,ndims); % Predicted labels
                y = VTestDat{m}.Labs; % Actual label
                accu(n,k,m) = sum(y==py)/length(y);
            end
        end
    end
end

% Average across the folds to get the validation accuracy
ValAccu = mean(accu,3);

% Optimal hyperparameters
[R,MU] = meshgrid(r,mu);
[~,maxind] = max(ValAccu(:));
rBest = R(maxind);
muBest = MU(maxind);

%% Training
Tmax = 20; % Max Epochs
T = 1:Tmax; % Total Epochs
newSeed = Seed(end)+1; % Just obtain a consistent but different random seed.

% Train using the optimal hyperparameters (determined in the previous step)
[wTrain,nUp] = MyPercep(TrainDat,rBest,Tmax,newSeed,Typ,muBest);

% Test versus the development (validation) set to determine optimal number
% of epochs

for t = 1:length(T)
    py = PerceptronRead(DevTestDat,wTrain(:,t),ndims); % Predicted labels
    y = DevTestDat.Labs; % Actual label
    DevAccu(t) = sum(y==py)/length(y); % Accuracy
end

% Determine optimal epoch
[maxDevAccu,maxind] = max(DevAccu);
TBest = T(maxind);
nUpBest = nUp(maxind);

% Determine optimal Weight vector
wBest = wTrain(:,maxind);

%% Test against Test set using optimal weight vector
y = TestDat.Labs; % Actual Label
py = PerceptronRead(TestDat,wBest,ndims); % Predicted labels
TestAccu = sum(y==py)/length(y); % Test Accuracy

%% Display
figure('Units','Inches','Position',[1 1 1+3 1+2])
imagesc(ValAccu);
colormap gray
cbr = colorbar;
ylabel(cbr,'Accuracy')
ax = gca;
ax.XMinorTick = 'on';
ax.XTick = 1:3;
ax.XTickLabels = mat2cell(r,1);
ax.YTick = 1:3;
ax.YMinorTick = 'on';
ax.YTickLabels = mat2cell(mu,1);
xlabel('Initial Learning Rate (r_0)')
ylabel('Margin (\mu)')

figure('Units','Inches','Position',[1 1 1+2 1+2])
yyaxis left
plot(T,DevAccu,'-b','LineWidth',2)
xlabel('No. of Epochs (T)')
ylabel('Accuracy Against Development Set')

hold on
plot(TBest,maxDevAccu,'*k')
hold off

text(TBest,maxDevAccu,sprintf('  Test Accuracy\n  %0.3f',TestAccu))

% Plot the number of updates
yyaxis right
plot(T,nUp,':r','LineWidth',2)
ylabel('Number of Updates')