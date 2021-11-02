function [pY] = PerceptronRead(Dat,w,maxDims)
%PERCEPTRONREAD Output the predicted labels for a dataset (Dat) given the
%perceptron weights (w) and the maximum number of dimensions in the feature
%set. 

%   Detailed explanation goes here
sX = Dat.Vals; % Sparse X
Inds = Dat.Inds;
for k=1:length(sX)
    X = Sparse2Full(Inds{k},sX{k},maxDims);
    pY(k) = mySign(w'*X);
end
pY = pY';
end

