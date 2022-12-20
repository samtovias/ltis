% MINMAXUNNOMR Min-max unnormalization. 
%   vect = minmaxunnorm(X,stats) un-normalizes data in X of size NxD (N 
%   instances and D features) previously scaling with MINMAXNOMR using 
%   the minimum and maximum values in stats vector. 
%   
%   Example:
%   -------
%   load vowel.mat                 % Load dataset 
%   [X,dmn,dmx] = minmaxnorm(X);   % Normalize the dataset
%   X = minmaxunnorm(X,[dmn;dmx]); % Unnormalize the dataset 
%
%   See also MINMAXNORM
%
%
%   Reference:
%   ---------
%   K. L. Priddy, P. E. Keller, Artificial Neural Networks: An Introduction.
%   Bellingham, WA: SPIE-The Int. Soc. Optical Eng., 2005.

% ------------------------------------------------------------------------
%   MINMAXUNNOMR Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function vect = minmaxunnorm(vect,stats)
dmn = stats(1,:);
dmx = stats(2,:);
N = size(vect,1);
mx = repmat(dmx,N,1);
mn = repmat(dmn,N,1);
vect = 0.5*(vect+1).*(mx-mn) + mn;
