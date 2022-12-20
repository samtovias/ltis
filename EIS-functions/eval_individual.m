% EVAL_INDIVIDUAL Evaluation of individual in EIS. 
%   [f,PS] = eval_individual(X,Y,idx,params,P) returns the fitness (f) and 
%   the PDF cell-array of the selected subset (PS). X is a dataset of size 
%   NxD (N instances and D dimensions), Y is a class label vector of size 
%   Nx1, idx is a binary string individual of size 1xN, params is a 
%   structure that contains information of the problem and P is the 
%   PDF cell-array of the original dataset. 
%   
%   Example:
%   -------
%   load vowel.mat                              % Load dataset 
%   X = minmaxnorm(X);                          % Normalize dataset
%   N = size(X,1);                              % Number of instances
%   params.N = N; 
%   params.NC = max(Y);                         % Number of classes 
%   params.D = size(X,2);                       % Number of dimensions 
%   params.h = h_estimate(X,Y,params);          % Estimation bandwidth matrix 
%   params.xh = linspace(-1.5,1.5,100);         % Linearly spaced vector 
%   params.w = 0.5;                             % Weight of the objective function 
%   P = get_pdf(X,Y,params);                    % PDF cell-array 
%   idx = logical(randi([0,1],1,N));            % Generate a binary individual 
%   [f,PS] = eval_individual(X,Y,idx,params,P); % Evaluate individual
% 
%   See also EIS

% ------------------------------------------------------------------------
%   EIS Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function [f,PS] = eval_individual(X,Y,idx,params,P)
% Select instances
XS  = X(idx,:);
YS  = Y(idx,:);
% Get selected subset PDFs
PS = get_pdf(XS,YS,params);
% hd: Hellinger distance matrix per class and dimension
hd = zeros(params.NC,params.D);
for c = 1:params.NC
    for d = 1:params.D 
        hd(c,d) = hellinger_distance(params.xh,P{c,d},PS{c,d});
    end
end
% Calculate fitness
% f1: Mean2 of the HD matrix
% f2: Reduction ratio
f1 = mean2(hd);
f2 = sum(idx)/params.N;
f = params.w*f1 + (1-params.w)*f2;
