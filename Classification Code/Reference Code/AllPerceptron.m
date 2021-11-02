clc;clear;close all;
nkn=0; % Initialize
BasicPerceptron;

SaveVars;

DecayPerceptron;      
SaveVars;

MarginPerceptron;     
SaveVars;

AveragePerceptron;    
SaveVars;

AggressivePerceptron; 
SaveVars;

%% Compute Majority Threshold
datfname = fullfile('..','Data','HW2_data.mat');
load(datfname);
% Find most common label in training set
Labs = TrainDat.Labs;
pos = sum(Labs==1);
neg = sum(Labs==-1);
if pos>neg
    majLab = 1;
else
    majLab = -1;
end

% Majority Baseline - Dev Set
MajBDev = sum(DevTestDat.Labs==majLab)/length(DevTestDat.Labs);

% Majority Baseline - Test Set
MajBTest = sum(TestDat.Labs==majLab)/length(TestDat.Labs);
%% Display
close all;
ptype1 = {'Basic','Decay','Margin','Average','Aggressive','Baseline'};
dims = [3 4];
fnt = 10;

% Dev accuracy vs. T vs. Type
figure('Units','Inches','Position',[1 1 1+dims(2) 1+dims(1)])
hold on
for mj=1:nkn
    plot(dat.T{mj},dat.DevAccu{mj},'LineWidth',2)
end
plot([dat.T{1}(1) dat.T{1}(end)],[MajBDev MajBDev],'--k','LineWidth',2)
hold off
xlabel('No. of Epochs (T)','FontSize',fnt)
ylabel('Development Accuracy','FontSize',fnt)
grid on
set(gca,'FontSize',fnt)
LH = legend(ptype1,'Location','SouthEast');
LH.FontSize = fnt;

% No. of Updates vs. T vs. Type
ptype = {'Basic','Decay','Margin','Average','Aggressive'};

figure('Units','Inches','Position',[1 1 1+dims(2) 1+dims(1)])
hold on
ltype = {'-','-','--','--','-'};
for mj=1:nkn
    plot(dat.T{mj},dat.nUp{mj},'LineWidth',2,'LineStyle',ltype{mj})
end

hold off
xlabel('No. of Epochs (T)','FontSize',fnt)
ylabel('No. of Updates','FontSize',fnt)
axis tight
grid on
set(gca,'FontSize',fnt)
LH = legend(ptype,'Location','SouthEast');
LH.FontSize = fnt;

% Test Accuracy and No. of Updates vs. Type
nUpBest = cell2mat(dat.nUpBest);
TestAccu = cell2mat(dat.TestAccu);
ptypes = categorical(ptype);
ptypes = reordercats(ptypes,ptype);

figure('Units','Inches','Position',[1 1 1+dims(2) 1+dims(1)])
yyaxis left
hold on
plot(ptypes,TestAccu,'LineWidth',2,'Marker','o')
plot(ptypes,repmat(MajBTest,[1 5]),'LineWidth',2,'LineStyle',':')
xlabel('Perceptron Algorithm','FontSize',fnt)
ylabel('Max Test Accuracy','FontSize',fnt)
yyaxis right
plot(ptypes,nUpBest,'LineWidth',2,'LineStyle','--','Marker','d')
ylabel('No. of Updates','FontSize',fnt)
set(gca,'FontSize',fnt)

% Plot T-Best vs. class
figure('Units','Inches','Position',[1 1 1+dims(2) 1+dims(1)])
plot(ptypes,dat.TBest,'LineWidth',2,'Marker','o')
xlabel('Perceptron Algorithm','FontSize',fnt)
ylabel('Optimal Epoch','FontSize',fnt)

set(gca,'FontSize',fnt)

% Plot ValBest vs. class
figure('Units','Inches','Position',[1 1 1+dims(2) 1+dims(1)])
plot(ptypes,dat.ValBest,'LineWidth',2,'Marker','o')
xlabel('Perceptron Algorithm','FontSize',fnt)
ylabel('Cross-Validation Accuracy','FontSize',fnt)

set(gca,'FontSize',fnt)