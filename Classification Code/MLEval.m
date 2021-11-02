function [p,r,F1] = MLEval(y,py)
%MLEVAL Compute the precision, recall, and f-value of machine learning
%outputs.
%
%   [p,r,F1] = MLEVAL(y,py) compute the precision (p), recall (r), and
%   F-value (F1) given the true label (y) and predicted label (py) from a
%   set of machine learning examples. 
%
%   Author: Connor Healy
%   Version: 1.0
%   Last Updated: 11/27/2018

%% Classify labels and predicted labels. 
yTrue   = (y==1);   % True Actual Labels
yFalse  = (y==-1);  % False Actual Labels
ypTrue  = (py==1);  % True Predicted Labels
ypFalse = (py==-1); % False Predicted Labels

% Count False/True Positives/Negatives
% True Positives
TP = sum(yTrue.*ypTrue);

% False Positives
FP = sum(yFalse.*ypTrue);

% False Negatives
FN = sum(yTrue.*ypFalse);

%% Compute the Evaluation parameters
% Precision
p = TP./(TP+FP);
if TP+FP ==0
    p = 0;
end

% Recall
r = TP./(TP+FN);
if TP+FN == 0
    r = 0;
end


% F-value
F1 = 2*p.*r./(p+r);

if (p+r)==0
    F1 = 0;
end

end

