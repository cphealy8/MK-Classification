function [wsave,nUpSave,asave] = MyPercep(dat,r,T,Seed,varargin)
%BASICPERCEPTRON Executes the basic perceptron algorithm
%   Dat is the training data (in libSVM format)
%   r is the learning rate.
%   T is the maximum number of epochs. 
%   Seed is the random seed
%   Additional arguments can be passed to varargin.
%
%   Outputs
%   wsave is a matrix with size equal to the no. of features by Tmax. (the
%   no. of epochs). This matrix is weights found by perceptron and needed
%   to predict labels using the code perceptronread.m 
%   nUpSave stores the number of updates needed for each classifier.
%   aSave is the averaged weight vector (used for averaged perceptron). 

% Maximum number of dimensions (+1 to account for bias term)
ndims = max(cell2mat(dat.Inds));
nsamps = length(dat.Inds); % Total number of samples

% Initialize w
wSeed = Seed;
rng(wSeed)
rWid = 0.02;
rMin = -0.01;
w = rWid*rand(ndims+1,1)+rMin;
a = zeros(ndims+1,1); % Initialize the average weighting vector

ro = r; %Initial r
t = 0; % Initialize time
nUp = 0; % Initialize the number of updates. 

cnt = 0;

for k = 1:T % Run through the number of epochs.
% Set the sample order
sSeed = Seed+k-1;
rng(sSeed)
SampOrd = randsample(nsamps,nsamps);

for i=1:nsamps
    cnt = cnt+1;
% Reconstruct the sparse vector 
x = Sparse2Full(dat.Inds{i},dat.Vals{i},ndims);
y = dat.Labs(i); % Label

% Update weights if it makes a mistake.
if nargin>5 % Margin Rules
    if y*w'*x < varargin{2}
        if strcmp(varargin{1},'aggressive') % Handle the aggressive case.
            mu = varargin{2};
            eta = (mu - y*w'*x)/(x'*x+1);
            w = w + eta*y.*x;
            nUp = nUp+1;
        else
            w = w + r*y.*x;
            nUp = nUp+1;
        end
    end 
else % Basic Rules
    if y*w'*x <= 0
        w = w + r*y.*x;
        nUp = nUp+1;
    end
end

% Update r, if requested
if nargin>4
    if strcmp(varargin{1},'decay')
        t = t+1;
        r = ro/(1+t);

    end
end
% Compute averaged perceptron
% a = a+w;
ws(:,cnt) = w;


end

nUpSave(k) = nUp;
wsave(:,k) = w;
asave(:,k) = mean(ws,2);
end
