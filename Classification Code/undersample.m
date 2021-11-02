function [datOut] = undersample(datIn,tgtLab,ratio)
%OVERSAMPLE Add additional examples to an imbalanced training set. 
%   [datOut] = oversample(datIn,+1,0.5); Takes random samples of the
%   examples in the input data array "datIn" and appends them to the the
%   original array. Adds enough examples so that the new examples take up
%   50% of the augmented dataset. 

if ~isnan(ratio)
% Get the pool of off target examples.
NegExamps = datIn.Labs~=tgtLab;
PosExamps = ~NegExamps;
OffTgt = LibIndex(datIn,NegExamps);
Tgt = LibIndex(datIn,PosExamps);

offtgtLabs = datIn.Labs(NegExamps);
offtgtInds = datIn.Inds(NegExamps);
offtgtVals = datIn.Vals(NegExamps);

% Set the number of examples to add to the data set. Use a ratio. (New
% Hyperparam)
NOrig = length(datIn.Labs);
nOffTgt = length(offtgtLabs);
nTgt = NOrig-nOffTgt;

NewTot = nTgt/ratio;
SampsOut = nOffTgt-(NewTot-nTgt);

% Randomly sample the existing examples.
irand = randsample(nOffTgt,SampsOut);

% Delete the negative examples at random.
offtgtLabs(irand) = [];
offtgtInds(irand) = [];
offtgtVals(irand) = [];

% Append the reduced negative set to the positive examples.
datOut.Vals = [Tgt.Vals; offtgtVals];
datOut.Inds = [Tgt.Inds; offtgtInds];
datOut.Labs = [Tgt.Labs; offtgtLabs];

% Finally shuffle the whole thing.
datOut = ShuffleLib(datOut);
else
    datOut = ShuffleLib(datIn);
end
end

