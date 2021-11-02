function [DatArr] = OptimizeFeat(DatArr)
%OPTIMIZEFEAT Remove non-descript features from a feature set.
%   Detailed explanation goes here

% Features that do not vary between examples are useless and can be removed
% . These features will have a standard deviation of zero between examples. 
SD = std(DatArr); % Standard deviation of features

% Remove Non-descript features.
DatArr(:,SD==0)=[]; % Cropped Data Array. 
end