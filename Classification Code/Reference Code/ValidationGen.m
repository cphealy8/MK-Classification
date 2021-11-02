function [datOut] = ValidationGen(datIn)
%VALIDATIONGEN Generate k-fold Validation sets for LibSVM formatted data.
%   
nsets = length(datIn);

for kout = 1:nsets
ind = 1:nsets;
ind(kout)=[];

datOut{kout}.Inds = [];
datOut{kout}.Vals = [];
datOut{kout}.Labs = [];

% Concatenate 
for i=ind
    datOut{kout}.Inds = [datOut{kout}.Inds; datIn{i}.Inds];
    datOut{kout}.Vals = [datOut{kout}.Vals; datIn{i}.Vals]; 
    datOut{kout}.Labs = [datOut{kout}.Labs; datIn{i}.Labs];
end
end
end

