function [Accuracy,MajBaseline,Ratio] = ML_Accuracy(trueY,predY)
%ML_ACCURACY Report the accuracy of a predicted label.
%   [Accuracy,MajBaseline,Ratio] = ML_Accuracy(trueY,predY) returns the
%   percent accuracy (Accuracy), the Majority Baseline (MajBaseline), and
%   the Ratio of these two values given a vector of true labels (trueY) and
%   a vector of predicted labels for the same dataset (predY). The majority
%   baseline is the expected accuracy if the most common label in the
%   true set is assumed for all predicted labels. If the ratio of the
%   accuracy and the majority baseline is positive then the
%   algorithm is effectively learning and is better at predicting vs. the 
%   majority baseline by a given percentage. Otherwise the prediction is
%   worse than the majority baseline and learning is unneffective. 

% Percent accuracy of the predicted label. 
Accuracy = sum(trueY==predY)/length(trueY); 

% Majority Baseline
MajBaseline = MajBase(trueY);

% Ratio
Ratio = Accuracy/MajBaseline-1;
end