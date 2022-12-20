% KDE Kernel density estimation. 
%   ph = kde(x,xh,h) returns a PDF estimation from the samples in x, a 
%   linearly spaced vector xh and a bandwidth h for the Gaussian kernel
%   used in the KDE algorithm. 
% 
%   Example:
%   -------
%   load vowel.mat               % Load dataset 
%   X = minmaxnorm(X);           % Normalize dataset
%   i = 1;                       % Index for select variable 
%   x = X(:,i);                  % i-th predictor variable 
%   h = silverman(x);            % Compute bandwidth 
%   xh = linspace(-1.5,1.5,100); % Linearly spaced vector 
%   ph = kde(x,xh,h);            % PDF estimation   
% 
%   See also GET_PDF H_ESTIMATE HELLINGER_DISTANCE SILVERMAN
%
%
%   Reference:
%   ---------
%   R. O. Duda, P. E. Hart, and D. G. Stork. Pattern Classification. 
%   Wiley, 2nd edition, 2000. 1, 2

% ------------------------------------------------------------------------
%   KDE Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function ph = kde(x,xh,h)
k  = kpdf(x,h);
ph = k(xh);
%*************************************************************************
function k = kpdf(data,h)
phi = @(x) exp(-.5*x.^2)/sqrt(2*pi);    % Normal Density
kernel = @(x) mean(phi((x-data)/h)/h);  % Kernel Density
k = @(x) arrayfun(kernel,x);            % Elementwise application
