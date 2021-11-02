% clc; clear; close all;
% clear
%% Load the Data
datfname = fullfile('..','Data','HW2_data.mat');
load(datfname);

r = [1,0.1,0.01]; % Learning Rates
mu = [1,0.1,0.01]; % Margin

Typ = 'aggressive';
%% Cross Validation
Tmax = 10; % Max no. of epochs
T = 1:Tmax; % Epochs
Seed = 1:length(VTrainDat); % Random Seed
for k = 1:length(mu)
        for m =1:length(VTrainDat)
            % Train to obtain weights
            [wVal{k,m}] = MyPercep(VTrainDat{m},r(1),Tmax,Seed(m),Typ,mu(k));

            % Test against left out set to obtain accuracy.
            for t = 1:length(T)
                wt = wVal{m}(:,t);     % Weights
                py = PerceptronRead(VTestDat{m},wt,ndims); % Predicted labels
                y = VTestDat{m}.Labs; % Actual label
                accu(k,m) = sum(y==py)/length(y);
            end
        end
end

% Average across the folds to get the validation accuracy
ValAccu = mean(accu,2);



% Optimal hyperparameters
[~,maxind] = max(ValAccu);
rBest = r(1); % This really isn't needed
muBest = mu(maxind);

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

% Determine optimal Weight vector
wBest = wTrain(:,maxind);

%% Test against Test set using optimal weight vector
y = TestDat.Labs; % Actual Label
py = PerceptronRead(TestDat,wBest,ndims); % Predicted labels
TestAccu = sum(y==py)/length(y); % Test Accuracy

%% Display

% Display
figure('Units','Inches','Position',[1 1 1+2 1+2])
plot(mu,ValAccu,'-ob','LineWidth',2)
xlabel('Margin (\mu)')
ylabel('K-fold Accuracy')

figure('Units','Inches','Position',[1 1 1+2 1+2])
yyaxis left
plot(T,DevAccu,'-b','LineWidth',2)
xlabel('No. of Epochs (T)')
ylabel('Accuracy Against Development Set')


% Determine optimal epoch
[maxDevAccu,maxind] = max(DevAccu);
TBest = T(maxind);
nUpBest = nUp(maxind);
hold on
plot(TBest,maxDevAccu,'*k')
hold off

text(TBest,maxDevAccu,sprintf('  Test Accuracy\n  %0.3f',TestAccu))

% Plot the number of updates
yyaxis right
plot(T,nUp,':r','LineWidth',2)
ylabel('Number of Updates')