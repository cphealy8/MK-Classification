function [datOut] = oversample(datIn,tgtLab,ratio,varargin)
%OVERSAMPLE Add additional examples to an imbalanced training set. 
%   [datOut] = oversample(datIn,+1,0.5); Takes random samples of the
%   examples in the input data array "datIn" and appends them to the the
%   original array. Adds enough examples so that the new examples take up
%   50% of the augmented dataset. 

% Get the pool of target examples.
examps = datIn.Labs==tgtLab;
tgtLabs = datIn.Labs(examps);
tgtInds = datIn.Inds(examps);
tgtVals = datIn.Vals(examps);

if ~isnan(ratio)
    % Set the number of examples to add to the data set. Use a ratio. (New
    % Hyperparam)
    NOrig = length(datIn.Labs);
    nTgt = length(tgtVals);
    nOffTgt = NOrig-nTgt;

    NewTot = nOffTgt/(1-ratio);
    newSamps = round(NewTot-nOffTgt-nTgt);

    % Randomly sample the existing examples.
    irand = randi(nTgt,[1 newSamps]);
    newLabs = repmat(tgtLab,[newSamps 1]);
    newInds = tgtInds(irand);
    newVals = tgtVals(irand);

    % Optional, add noise to each "new" example. (New Hyperparam).
    % for n=1:length(newVals)
    %     newVals{n} = newVals{n}+rand(size(newVals{n}));
    % end

    % Append the new examples to the pre-existing data set. 
    datOut.Vals = [datIn.Vals; newVals];
    datOut.Inds = [datIn.Inds; newInds];
    datOut.Labs = [datIn.Labs; newLabs];


% Finally shuffle the whole thing.
datOut = ShuffleLib(datOut);
else
    datOut = ShuffleLib(datIn);
end

end

