% MINMAXNOMR Min-max normalization. 
%   vect = minmaxnorm(X) normalizes data in X of size NxD (N 
%   instances and D features) with the minimun and maximum
%   values in X. The output data range is [-1,+1].
% 
%   [vect,dmn,dmx] = minmaxnorm(X) returns the minimum and 
%   maximum values for each dimension in dmn and dmx.
%   
%   vect = minmaxnorm(X,[dmn;dmx]) normalize data in X using 
%   the minimum and maximum values are given in dmn and dmx. 
%   
%   Example:
%   -------
%   load vowel.mat                      % Load dataset 
%   N = size(X,1);                      % Dataset size 
%   idx = crossvalind('HoldOut',N,0.2); % Train and test indices 
%   Xtr = X(idx,:); Ytr = Y(idx);       % Train partition 
%   Xtt = X(~idx,:); Ytt = Y(~idx);     % Test partition
%   [Xtr,dmn,dmx] = minmaxnorm(Xtr);    % Normalize the training set
%   Xtt = minmaxnorm(Xtt,[dmn;dmx]);    % Normalize the testing set 
%
%   See also MINMAXUNNORM
%
%
%   Reference:
%   ---------
%   K. L. Priddy, P. E. Keller, Artificial Neural Networks: An Introduction.
%   Bellingham, WA: SPIE-The Int. Soc. Optical Eng., 2005.

% ------------------------------------------------------------------------
%   MINMAXNOMR Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function [vect,dmn,dmx] = minmaxnorm(vect,stats)
if nargin == 1
    dmx = max(vect,[],1);
    dmn = min(vect,[],1);
elseif nargin == 2
    dmn = stats(1,:);
    dmx = stats(2,:);
end
N = size(vect,1);
ind = dmx~=dmn;
mx = repmat(dmx,N,1);
mn = repmat(dmn,N,1);
vect_aux = (2.*(vect(:,ind) - mn(:,ind))./(mx(:,ind)-mn(:,ind)))-1;
vect(:,ind) = vect_aux;
zeros_vectors = zeros(N,sum(~ind)); % Avoid NaN problem when variables have no range 
vect(:,~ind) = zeros_vectors;
