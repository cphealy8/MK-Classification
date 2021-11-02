function [x] = Sparse2Full(Inds,Vals,maxdims)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
% Reconstruct full x vector from sparse data.
x = zeros(maxdims,1); % Initialize
x(Inds) = Vals; % Reconstruct X 
x(end+1) = 1; % Add the bias term. 
end

