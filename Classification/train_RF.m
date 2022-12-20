% TRAIN_RF Train random forest classification model. 
%   Model = train_RF(X,Y) trains a random forest classification model 
%   from train data in X of size NxD (N instances and D features) and 
%   the targets in Y of size Nx1. Model is a structure with the random 
%   forest model. The default number of bootstrap samples is set to 1000.
%
%   Model = train_RF(X,Y,B) trains a random forest classification model 
%   with B bootstrap samples.
%
%   NOTE: This function requires the "fitctree" function of the 
%   Statistics and Machine Learning Toolbox (MATLAB).
%   
%   Example:
%   -------
%   load vowel.mat                         % Load dataset 
%   X = minmaxnorm(X);                     % Minmax normalization in range [-1,1]   
%   N = size(X,1);                         % Dataset size 
%   idx = crossvalind('HoldOut',N,0.2);    % Train and test indices 
%   Xtr = X(idx,:); Ytr = Y(idx);          % Train partition 
%   Xtt = X(~idx,:); Ytt = Y(~idx);        % Test partition  
%   Model = train_RF(Xtr,Ytr);             % RF Model 
%   Out = classify_RF(Xtt,Model);          % Classify test data 
%   Acc = sum(Ytt==Out.Labels)/numel(Ytt); % Evaluate accuracy 
%  
%   See also CLASSIFY_RF
%
%
%   Reference: 
%   ---------
%   Leo Breiman, "Random Forests", Machine Learning, vol. 45, no. 1, 
%   pp.  5-32, 2001.

% ------------------------------------------------------------------------
%   TRAIN_RF Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function Model = train_RF(X,Y,B)
if nargin < 3
    B = 1000;
end
[Data,Params] = split_bootstraps(X,Y,B);
B  = Params.B;
% Training with bootstrap samples
Forest = cell(1,B);
parfor b = 1:B
    Forest{b} = train_trees(b,Data);
end
Model.Forest = Forest;
Model.Params = Params;
% %***********************************************************************
function Models = train_trees(b,Data)
X  = Data.Train.X;
Y  = Data.Train.Y;
Ti = Data.Boost(:,b);
nfea = Data.nFeats;
Xtr = X(Ti,:);
Ytr = Y(Ti);
Models = train_tree(Xtr,Ytr,nfea);
%***********************************************************************
function Model = train_tree(X,Y,nfea)
Model = fitctree(X,Y,'MinLeaf',1,'Prune','off','Prior','uniform','NVarToSample',nfea);
%***********************************************************************
function [Data,Params] = split_bootstraps(Xtr,Ytr,B)
% Parameters
C = max(Ytr);       % Number of classes
[N,D] = size(Xtr);  % Number of patterns and features
% Parameters structure
Params.C = C;       % Number of classes
Params.D = D;       % Number of features
Params.N = N;       % Number of patterns
Params.B = B;       % Number of bootstraps
% Bootstrap indices
indBtr = randi(N,N,B);
% Number of random features
Feats = round(sqrt(D)); 
% Feats = floor(1+log2(D)); % Original from Breiman's paper
% Data structures
Data.Train.X = Xtr;
Data.Train.Y = Ytr;
Data.Boost  = indBtr;
Data.nFeats = Feats;