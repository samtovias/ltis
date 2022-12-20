% CLASSIFY_RF Classify data with random forest classifier. 
%   Out = classifyRF(X,Model) classifies out-of-bag test data in X 
%   of size NxD (N instances and D features)with a random forest 
%   classification model. Model is a structure with the RF 
%   parameters. 
%
%   NOTE: This function requires the "predict" function of the 
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
%   See also TRAIN_RF
% 
% 
%   Reference: 
%   ---------
%   Leo Breiman, "Random Forests", Machine Learning, vol. 45, no. 1, 
%   pp.  5-32, 2001.

% ------------------------------------------------------------------------
%   CLASSIFY_RF Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function Ypp = classify_RF(X,Model)
B = Model.Params.B;
C = Model.Params.C;
N = size(X,1);
% classify out-of-bag
Ypb = zeros(N,B);
for i = 1:B
    Ypb(:,i) = predict(Model.Forest{i},X);
end
% Majority vote
V = zeros(N,C);
for i = 1:N
    Ypi = Ypb(i,:);
    votes = accumarray(Ypi',ones(numel(Ypi),1),[C 1],@sum,0);
    V(i,:) = votes;
end
[~,Ypp] = max(V,[],2);