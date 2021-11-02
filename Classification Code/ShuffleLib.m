function [dat] = ShuffleLib(dat)
%SHUFFLELIB Shuffle the examples given in LibArray Format. 
%   Detailed explanation goes here
nex = length(dat.Labs);
rng(4)
rshuff = randsample(nex,nex);
dat = LibIndex(dat,rshuff);
end

