% IS_ICF Iterative case filtering instance selection. 
%   [XS,YS] = is_icf(X,Y) performs ICF instance selection over 
%   the dataset X with size NxD (N instances and D features) 
%   using the 3-nearest neighbor rule.
%
%   [XS,YS] = is_icf(X,Y,k) performs ICF instance selection 
%   using the k-nearest neighbor rule.
%   
%   Example:
%   -------
%   load vowel.mat                   % Load dataset 
%   [X,dmn,dmx] = minmaxnorm(X);     % Normalize the dataset
%   [XS,YS] = is_icf(X,Y);           % ICF instance selection 
%   XS = minmaxunnorm(XS,[dmn;dmx]); % Un-normalize the selected subset 
%
%   See also IS_CNN IS_ENN IS_DROP3
%
% 
%   Reference:
%   ---------
%   Brighton, H., Mellish, C. Advances in Instance Selection for 
%   Instance-Based Learning Algorithms. Data Mining and Knowledge 
%   Discovery 6, 153–172 (2002). doi: 10.1023/A:1014043630878

% ------------------------------------------------------------------------
%   IS_ICF Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function [XS,YS,remove] = is_icf(X,Y,k) 

if nargin == 2 
    k = 3;
end

% Initialization of flagged instance vectors 
N = size(X,1); 
marked = true(N,1);
coverage = zeros(N,1); 
coverage_ind = cell(N,1); 

% Initializate knn matrix and array of nearest enemies
ns = createns(X,'nsmethod','kdtree'); 
knn = knnsearch(ns,X,'k',N);
idx_enemies = Y ~= Y(knn);
enemy_ind = cell(N,1);
for i = 1:N    
    enemy_ind{i} = find(idx_enemies(i,:));
end

% Apply Wilson's editing 
[~,~,remove_enn] = is_enn(X,Y,k);

% Mark instances to remove due to filtering
marked(remove_enn) = false;

% Iterate until no cases flagged for removal
cont = 0; 
while 1

    % Compute reachable and coverage set 
    reachable = zeros(N,1);
    for i = 1:N
        if marked(i)
            % Coverage
            % A contains the indices in X of all instances of 
            ...the local set of x(i) 
            A = knn(i,1:enemy_ind{i}(1)-1);
            % B contains the indices in X of all instances that have 
            ...been marked for removal
            B = find(~marked)';
            % Remove from A the indices that have been marked for
            ...removal (reduce the coverage set)
            unmarked = intersect(A,B,'stable'); 
            A(ismember(A,unmarked)) = [];
            % A is the coverage set of x(i)
            coverage_ind{i} = A; 
            coverage(i) = numel(A);  
            % Reachable
            % Count the number of local sets to which it belongs x(i)
            reachable(coverage_ind{i}) = reachable(coverage_ind{i}) + 1;
        end
    end

    progress = false; 

    % Mark instances for removal     
    for i=1:N
        if marked(i) && reachable(i) > coverage(i) 
            marked(i) = false;
            progress = true; 
        end
    end

    cont = cont + 1; 
    %disp(strcat('ICF - Iteration:',{' '},num2str(cont)));

    % If there is no more instance for removal breaks the loop
    if ~progress
        break; 
    end

end

XS = X; 
YS = Y; 
XS(~marked,:) = []; 
YS(~marked) = [];
remove = ~marked; 
