function [MB,MajLab] = MajBase(y)
%MAJBASE Compute the Majority Baseline for a dataset
%   Detailed explanation goes here

[labs] = unique(y);
counts  = histc(y,labs);

[MajCount, MajInd] = max(counts);
MajLab = labs(MajInd);
MB = MajCount/length(y);

end

