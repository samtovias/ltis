% IS_CNN Condensed nearest neighbor instance selection. 
%   [XS,YS] = is_cnn(X,Y) performs condensed instance selection 
%   of data in X of size NxD (N instances and D features) using 
%   the nearest neighbor rule.
%   
%   Example:
%   -------
%   load vowel.mat                   % Load dataset 
%   [X,dmn,dmx] = minmaxnorm(X);     % Normalize the dataset
%   [XS,YS] = is_cnn(X,Y);           % CNN instance selection 
%   XS = minmaxunnorm(XS,[dmn;dmx]); % Un-normalize the selected subset 
%
%   See also IS_ENN IS_DROP3 IS_ICF
%
% 
%   Reference:
%   ---------
%   P. Hart, "The condensed nearest neighbor rule (Corresp.)," 
%   in IEEE Transactions on Information Theory, vol. 14, no. 3, 
%   pp. 515-516, May 1968, doi: 10.1109/TIT.1968.1054155.

% ------------------------------------------------------------------------
%   IS_CNN Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function [XS,YS] = is_cnn(X,Y)

N = size(X,1);

% First sample is placed in store 
sample = 1; 
STORE_X = X(sample,:); 
STORE_Y = Y(sample);

GRABBAG_X = [];
GRABBAG_Y = [];

% The second sample is classified by the NN-rule 
...using as a reference set the current content of STORE 
sample = 2; 
sample_X = X(sample,:); 
sample_Y = Y(sample);

% Since STORE has only one point the classification is trivial at 
...this stage 
distance = eucdist(STORE_X,sample_X);
[~,ind] = sort(distance,2);
nn = ind(:,1);
Ystore = STORE_Y(nn);

% If the second sample is classified correctly it is placed in
...GRABBAG
if Ystore == sample_Y
    GRABBAG_X = vertcat(GRABBAG_X,sample_X);
    GRABBAG_Y = vertcat(GRABBAG_Y,sample_Y);
else
    % Otherwise it is placed in STORE 
    STORE_X = vertcat(STORE_X,sample_X);
    STORE_Y = vertcat(STORE_Y,sample_Y);
end    

% Proceeding inductively, the ith sample is classified by the current 
...contents of STORE. 
for i = 3:N 

    sample = i; 
    sample_X = X(sample,:); 
    sample_Y = Y(sample);

    distance = eucdist(STORE_X,sample_X);
    [~,ind] = sort(distance);
    nn = ind(1);
    Ystore = STORE_Y(nn);

    if Ystore == sample_Y
        GRABBAG_X = vertcat(GRABBAG_X,sample_X); %#ok<*AGROW>
        GRABBAG_Y = vertcat(GRABBAG_Y,sample_Y);
    else 
        STORE_X = vertcat(STORE_X,sample_X);
        STORE_Y = vertcat(STORE_Y,sample_Y);
    end    

end    

% After one pass through the original sample set, the procedure
...continues the loop through GRABBAG until temrmination, which can 
...occur in one of two ways: 

% 1: The GRABBAG is exhausted, with all its members now transferred 
...to STORE ((in which case, the consistent subset found is the
...entire original set))

% 2: One complete pass is made through GRABBAG with no transfers to 
...STORE. (If this happens, all subsequent passes through GRABBAG
...will result in no transfers, since the underlaying decision surface 
...has not been changed

NGRABBAG = size(GRABBAG_X,1);
flag = 0;

while NGRABBAG > 0 && flag == 0 

    index = false(NGRABBAG,1);    
    cont = 0;
    for i = 1:NGRABBAG 

        sample = i; 
        sample_X = GRABBAG_X(sample,:); 
        sample_Y = GRABBAG_Y(sample);

        distance = eucdist(STORE_X,sample_X);
        [~,ind] = sort(distance);
        nn = ind(1);
        Ystore = STORE_Y(nn);

        if Ystore ~= sample_Y 
            cont = cont + 1;
            index(i) = true; 
            STORE_X = vertcat(STORE_X,sample_X);
            STORE_Y = vertcat(STORE_Y,sample_Y);
        end    

    end   

    % If NGRABBAG is zero then the GRABBAG is exhausted
    GRABBAG_X(index,:) = [];
    GRABBAG_Y(index) = [];    
    NGRABBAG = size(GRABBAG_X,1);

    % If cont is zero then one complete pass is made through GRABBAG
    ...with no transfers to STORE
    if cont == 0
        flag = 1;
    end

end

XS = STORE_X; 
YS = STORE_Y;

%***********************************************************************
function D = eucdist(A,B)
    nA = sum(A.*A,2);
    nB = sum(B.*B,2);
    D = abs(bsxfun(@plus,nA,nB') - 2*(A*B'));
