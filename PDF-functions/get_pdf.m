% GET_PDF Probability density function matrix. 
%   P = get_pdf(X,Y,params) Obtains a CxD size cell-array (with C classes 
%   and D dimensions) in which each cell contains a vector corresponding 
%   to a univariate PDF estimation by each class and dimension in X. X 
%   is a normalized dataset in the range [-1,1] of size NxD (N instances 
%   and D features). Y is the class label vector of Nx1 size. params is 
%   a structure that contains the additional information required to 
%   compute each PDF: D, C, bandwidth matrix and a linearly spaced vector 
%   in the range [-1.5,1.5].
%   
%   Example:
%   -------
%   load vowel.mat                      % Load dataset 
%   X = minmaxnorm(X);                  % Normalize dataset
%   params.NC = max(Y);                 % Number of classes 
%   params.D = size(X,2);               % Number of dimensions 
%   params.h = h_estimate(X,Y,params);  % Estimation bandwidth matrix 
%   params.xh = linspace(-1.5,1.5,100); % Linearly spaced vector 
%   P = get_pdf(X,Y,params);            % PDF cell-array 
%
%   See also H_ESTIMATE HELLINGER_DISTANCE KDE SILVERMAN 

% ------------------------------------------------------------------------
%   GET_PDF Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function P = get_pdf(X,Y,params)
P  = cell(params.NC,params.D);
for c = 1:params.NC
    ci = Y==c;
    Xi = X(ci,:);
    for d = 1:params.D 
        P{c,d} = kde(Xi(:,d),params.xh,params.h(c,d));
    end
end
