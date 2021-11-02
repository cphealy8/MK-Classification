function [outputArg1,outputArg2] = PercepTrain(TrainDat,Type,varargin)
%PERCEPTRAIN Train a classifier using the perceptron algorithm.  
%   Detailed explanation goes here

%% Parse inputs
p = inputParser;

% Define Required parameters
addRequired(p,'TrainDat',@isnumeric);

validTypes = {'Basic'}; % Valid perceptron algorithm types
checkTypes = @(x) any(validatestring(x,validTypes));
addRequired(p,'Type',checkTypes);

% Define any Optional parameters
% Learning rate
defaultRate = 1;
addParameter(p,'rate',defaultRate,@isnumeric)

% Parse the inputs
parse(p,TrainDat,Type,varargin{:})

%% Set parameters and data
Dat = p.Results.TrainDat; % Training Data
x = Dat(2:end,:); % Instances
y = Dat(1,:);     % Labels are stored as the first column of the data array.
LRate = p.Results.rate; % Learning Rate 
Type = p.Results.Type;  % Type of algorithm to be used. 
end

