function [arr] = LibSVM2Arr(Dat,uniqueInds)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nEx = length(Dat.Labs); 
nFeats = length(uniqueInds);
% Preallocate
x = zeros(nEx,nFeats);

for i=1:nEx
    x(i,:) = Sparse2Full2(Dat.Inds{i},Dat.Vals{i},uniqueInds)';
end

% Append labels to the front of the array
y = Dat.Labs;
arr = [y x];
end

