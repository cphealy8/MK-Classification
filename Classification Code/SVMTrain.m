function [wOut,T] = SVMTrain(Dat,Tmax,C,Ro,UniqueInds)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x = Dat.Vals;
y = Dat.Labs;
Inds = Dat.Inds;

nFeats = length(UniqueInds); % No. of Features
nEx = length(y); % No. of examples. 

% 1 - Initialize w
w = 0.02*rand(nFeats+1,1)-0.1;
wOut = zeros(length(w),Tmax);
% Loop through epochs
T = 0;
while T<Tmax
    T=T+1; % Update Epoch
    
    % Shuffle Examples
    rng(8+T)
    RInds = randsample(nEx,nEx);
    
    % Update Learning Rate
    r = Ro/(1+T);
    % Loop through training examples.
    for i=1:nEx
%         r = Ro/(1+i);
        RInd = RInds(i);
        xi = Sparse2Full2(Inds{RInd},x{RInd},UniqueInds,'BiasOn');
        yi = y(RInd);
        
        if yi*w'*xi <=1
            w = (1-r)*w+r*C*yi*xi;
        else
            w = (1-r)*w;
        end
    end
    wOut(:,T) = w;
end
end