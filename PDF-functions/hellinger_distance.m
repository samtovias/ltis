% HELLINGER_DISTANCE Hellinger distance. 
%   hd = hellinger_distance(xh,pdf1,pdf2) returns a measure of 
%   similarity between two estimations of probability density 
%   functions: pdf1 and pdf2. xh is a linearly spaced vector 
%   that represents the sample space. hd is a real scalar 
%   value in the range [0,1], where 0 indicates that both 
%   PDFs are the same and 1 shows that pdf1 and pdf2 do 
%   not overlap in any point of xh. 
% 
%   Example:
%   -------
%   load vowel.mat                        % Load dataset 
%   X = minmaxnorm(X);                    % Normalize dataset
%   xh = linspace(-1.5,1.5,100);          % Linearly spaced vector
%   h = silverman(X(:,1));                % Compute bandwidth for variable 1  
%   pdf1 = kde(X(:,1),xh,h);              % PDF estimation of variable 1   
%   h = silverman(X(:,2));                % Compute bandwidth for variable 2 
%   pdf2 = kde(X(:,2),xh,h);              % PDF estimation of variable 2
%   hd = hellinger_distance(xh,pdf1,pdf2) % Hellinger distance 
%
%   See also GET_PDF H_ESTIMATE KDE SILVERMAN
%
%
%   Reference:
%   ---------
%   Adele Cutler & Olga I. Cordero-Braña (1996) Minimum Hellinger 
%   Distance Estimation for Finite Mixture Models, Journal of the 
%   American Statistical Association, 91:436, 1716-1723, 
%   DOI: 10.1080/01621459.1996.10476743

% ------------------------------------------------------------------------
%   HELLINGER_DISTANCE Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function hd = hellinger_distance(xh,pdf1,pdf2)
hd = sqrt(0.5*trapz(xh, (sqrt(pdf1)-sqrt(pdf2)).^2));
