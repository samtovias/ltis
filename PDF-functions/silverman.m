% SILVERMAN Silverman rule of thumb for bandwidth estimation. 
%   h = silverman(xi) returns a bandwidth estimation from the 
%   univariate samples in the xi predictor variable.  
% 
%   Example:
%   -------
%   load vowel.mat     % Load dataset 
%   X = minmaxnorm(X); % Normalize dataset
%   i = 1;             % Index for select variable 
%   xi = X(:,i);       % i-th predictor variable 
%   h = silverman(xi); % Compute bandwidth 
% 
%   See also GET_PDF H_ESTIMATE HELLINGER_DISTANCE KDE
%
%
%   Reference:
%   ---------
%   B. W. Silverman, (1986). Density Estimation for Statistics and 
%   Data Analysis. London: Chapman & Hall/CRC. p. 45. 

% ------------------------------------------------------------------------
%   SILVERMAN Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function h = silverman(xi)
s = std(xi);
n = numel(xi);
h = ((4*s^5)/(3*n))^(1/5);
