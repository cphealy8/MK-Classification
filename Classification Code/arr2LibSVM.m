function [datLibSVM] = arr2LibSVM(datArr)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


% LibSVM should a structure with three fields. For a data set with n
% examples. 
% Inds, an n by 1 cell array. Each element of the array is a mx1 double
% array where m is the no. of nonzero features in the corresponding value
% array. Each element of the double array should be the index of a nonzero
% feature.
% Vals, and n by 1 cell array. Each element of the array is a mx1 double
% array where m is the no. of nonzero features in the value
% array. Each element of the double array should be the index value of a
% nonzero feature.
% Labs, an n by 1 double array of binary labels (1-true, -1 - false)

% Separate the features from the labels
x = datArr(:,2:end);
y = datArr(:,1);

[nexs,~] = size(x); 

for n =1:nexs
    Inds{n,1} = find(x(n,:)~=0)';
    Vals{n,1} = x(Inds{n})';
end

datLibSVM.Inds = Inds;
datLibSVM.Vals = Vals;
datLibSVM.Labs = y;
end
