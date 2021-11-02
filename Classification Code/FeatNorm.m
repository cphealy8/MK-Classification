function [NormDatArr] = FeatNorm(DatArr)
%FEATNORM Normalize feature data for machine learning. 
%   [NormDatArr] = FEATNORM(DatArr). Normalizes the input feature array
%   (DatArr) and outputs the resulting normalized feature array. 
 
% Each feature may span a wide range of values. We want to normalize each
% feature so that they have the same range, namely 0 to 1. To do this we
% subtract the minimum and divide by the range of each feature. This is
% only one way to normalize. 

FeatMin = min(DatArr);  % Minimum value of each feature
FeatRng = range(DatArr); % Range of values that the features can take.

NormDatArr = (DatArr-FeatMin)./FeatRng; % Normalized data set. 
end

