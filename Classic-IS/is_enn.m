% IS_ENN Edited nearest neighbor instance selection. 
%   [XS,YS] = is_enn(X,Y) performs instance selection with an 
%   edition method over the dataset X with size NxD (N instances 
%   and D features) using the 3-nearest neighbor rule.
%
%   [XS,YS] = is_enn(X,Y,k) performs instance selection with an 
%   edition method using the k-nearest neighbor rule.
%   
%   Example:
%   -------
%   load vowel.mat                   % Load dataset 
%   [X,dmn,dmx] = minmaxnorm(X);     % Normalize the dataset
%   [XS,YS] = is_enn(X,Y);           % ENN instance selection 
%   XS = minmaxunnorm(XS,[dmn;dmx]); % Un-normalize the selected subset 
%
%   See also IS_CNN IS_DROP3 IS_ICF
%
% 
%   Reference:
%   ---------
%   D. L. Wilson, "Asymptotic Properties of Nearest Neighbor Rules 
%   Using Edited Data," in IEEE Transactions on Systems, Man, and 
%   Cybernetics, vol. SMC-2, no. 3, pp. 408-421, July 1972, 
%   doi: 10.1109/TSMC.1972.4309137.

% ------------------------------------------------------------------------
%   IS_ENN Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function [XS,YS,remove] = is_enn(X,Y,k)
    
if nargin == 2
    k = 3;
end

ns = createns(X,'nsmethod','kdtree');
knn = knnsearch(ns,X,'k',k+1);
knn = knn(:,2:end);
Yp = mode(Y(knn),2); 
remove = Y~=Yp; 
XS = X(~remove,:); 
YS = Y(~remove); 
