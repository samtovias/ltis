% H_ESTIMATE Bandwidth matrix for PDF estimation.
%   h = h_estimate(X,Y,params) Obtains a real matrix of size CxD (with 
%   C classes and D dimensions) in which each element is an estimation 
%   of the bandwith for the corresponding PDF. X is a normalized dataset 
%   in the range [-1,1] of size NxD (N instances and D features). Y is 
%   the class label vector of Nx1 size. params is a structure with the 
%   information of C and D.
% 
%   Example:
%   -------
%   load vowel.mat                      % Load dataset 
%   X = minmaxnorm(X);                  % Normalize dataset
%   params.NC = max(Y);                 % Number of classes 
%   params.D = size(X,2);               % Number of dimensions 
%   params.h = h_estimate(X,Y,params);  % Estimation bandwidth matrix 
% 
%   See also GET_PDF HELLINGER_DISTANCE KDE SILVERMAN 

% ------------------------------------------------------------------------
%   H_ESTIMATE Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function h = h_estimate(X,Y,params)
h = zeros(params.NC,params.D);
Xk = X; Yk = Y;
for c = 1:params.NC
    Xi = Xk(Yk == c,:);
    for d = 1:params.D 
        h(c,d) = silverman(Xi(:,d));
        if h(c,d) == 0 || isnan(h(c,d)) || isinf(h(c,d)) 
            h(c,d) = 0.1; 
        end
    end
end
