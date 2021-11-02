function [py,accu,p,r,F1] = SVMRead(Dat,wIn,UniqueInds)
%SVMREAD Output the predicted labels for a dataset (Dat) given the
%perceptron weights (w) and the maximum number of dimensions in the feature
%set. 

%   Detailed explanation goes here
sX = Dat.Vals; % Sparse X
Inds = Dat.Inds;
y = Dat.Labs; % True Label
% Size of the n-dimensional weight array. 
wSize = size(wIn);

maxDims = wSize(1)-1;
if length(wSize)==4
    % Maximum number of features (minus 1 because of the bias term)
     
    TLen = wSize(2);  % Length of Epoch Vector
    RoLen = wSize(3); % Length of Initial Learning Rate Vector
    CLen = wSize(4);  % Length of Regularization Vector
    
    for t = 1:TLen % Loop through Epochs
        for RoInd = 1:RoLen % Loop through initial learning rates
            for CInd = 1:CLen % Loop through regularization factor.
                % Set the weight
                w = wIn(:,t,RoInd,CInd);

                for k=1:length(sX) % Loop through examples. 
                    % Reconstruct the example vector.
                    X = Sparse2Full2(Inds{k},sX{k},UniqueInds,'BiasOn');

                    % Compute the predicted label.
                    py(k,t,RoInd,CInd) = mySign(w'*X)';
                    

                end

                % Compute the accuracy
                [accu(t,RoInd,CInd)] = ML_Accuracy(y,py(:,t,RoInd,CInd));
                
                % Compute the evaluation
                [p(t,RoInd,CInd),r(t,RoInd,CInd),F1(t,RoInd,CInd)] = MLEval(y,py(:,t,RoInd,CInd));
            end
        end
    end

    
    
else
    
    for k=1:length(sX) % Loop through examples. 
    % Reconstruct the example vector.
    X = Sparse2Full2(Inds{k},sX{k},UniqueInds,'BiasOn');

    % Compute the predicted label.
    py(k) = mySign(wIn'*X);
    end
            
    % Compute the accuracy
    py = py';
    accu = ML_Accuracy(y,py);
    
    % Compute the evaluation
    [p,r,F1] = MLEval(y,py);
end




