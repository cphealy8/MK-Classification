function [xOut] = Sparse2Full2(Inds,Vals,UniqueInds,varargin)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% Reconstruct full x vector from sparse data.
maxdims = max(UniqueInds);
x = zeros(maxdims,1); % Initialize
x(Inds) = Vals; % Reconstruct X 

xOut = x(UniqueInds);

if nargin>3 && strcmp(varargin{1},'BiasOn')
    xOut(end+1) = 0;
end

end

