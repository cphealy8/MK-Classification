function [y] = mySign(x,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

y = zeros(size(x));

if nargin>1
    mu = varargin{1};
    y(x>=mu) = 1;
    y(x<mu) = -1;
else
    y(x>=0) = 1;
    y(x<0) = -1;
end


end

