% IS_DROP3 Decremental reduction optimization procedure instance selection. 
%   [XS,YS] = is_drop3(X,Y) performs DROP3 instance selection over 
%   the dataset X with size NxD (N instances and D features) 
%   using the 3-nearest neighbor rule.
%
%   [XS,YS] = is_drop3(X,Y,k) performs DROP3 instance selection 
%   using the k-nearest neighbor rule.
%   
%   Example:
%   -------
%   load vowel.mat                   % Load dataset 
%   [X,dmn,dmx] = minmaxnorm(X);     % Normalize the dataset
%   [XS,YS] = is_drop3(X,Y);         % DROP3 instance selection 
%   XS = minmaxunnorm(XS,[dmn;dmx]); % Un-normalize the selected subset 
%
%   See also IS_CNN IS_ENN IS_ICF
%
% 
%   Reference:
%   ---------
%   Wilson, D.R., Martinez, T.R. Reduction Techniques for Instance-Based
%   Learning Algorithms. Machine Learning 38, 257–286 (2000). 
%   doi: 10.1023/A:1007626913721

% ------------------------------------------------------------------------
%   IS_DROP3 Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function [XS,YS,remove] = is_drop3(X,Y,k)

if nargin == 2 
    k = 3; 
end

N = size(X,1); 
marked = true(N,1); 

% Noise filtering with Wilson's Editing (ENN, 1972)
[~,~,remove] = is_enn(X,Y,k);
marked(remove) = false; 

% Sort instances in S by the distance to their nearest enemy 
ns = createns(X,'nsmethod','kdtree');
[knn,distknn] = knnsearch(ns,X,'k',N);
ind_enemy = zeros(N,1);
dist_enemy = zeros(N,1);
for i = 1:N
    idx_enemies = Y(i) ~= Y(knn(i,:));
    enemy_nn = find(idx_enemies); 
    ind_enemy(i) = knn(i,enemy_nn(1));
    dist_enemy(i) = distknn(i,enemy_nn(1));
end
[~,ind_enemy2] = sort(dist_enemy);
X = X(ind_enemy2,:); 
Y = Y(ind_enemy2);
marked = marked(ind_enemy2); 

% For each instance x in S do
% Find x.N1,...,k+1, the k+1 nearest neighbours of x in S
ns = createns(X,'nsmethod','kdtree');
knn = knnsearch(ns,X,'k',N);
KNN = cell(N,1);
LA = cell(N,1);
for i = 1:N 
        knn1 = knn(i,:);
        KNN{i} = knn1(2:end);
        % Add x to each of its neighbours list of associates
        for j = 1:k+1
            LA{KNN{i}(j)} = [LA{KNN{i}(j)} i]; 
        end
end
% Sort the associates list of x according the distance to x 
for i = 1:N
        x = X(i,:);
        xa = X(LA{i},:);
        dist_xa_x = dist(x,xa');
        [~,ind] = sort(dist_xa_x);
        LA{i} = LA{i}(ind);
end

% for each instance x in S do 
for i = 1:N

    % If this instance has not yet been removed   
    if marked(i)

        % Associates list of x 
        xa = LA{i};

        if numel(xa) ~= 0 

            % True label of associates
            Yt = Y(xa);
            Yp = zeros(numel(xa),1);

            % Let with = # of associates of x correctly classified by x as a neighbour
            for j = 1:numel(xa)
                Yp(j) = mode(Y(KNN{xa(j)}(1:k))); 
            end
            with = sum(Yt == Yp); 

            % Let without = # of associates of x correctly classified without x
            for j = 1:numel(xa)
                ind = KNN{xa(j)}(1:k+1);
                ind(ind==i) = [];
                Yp(j) = mode(Y(ind));          
            end 
            without = sum(Yp == Yt);

            % if without is grater than or equal to with then
            if (without >= with)
                % Remove x from S
                marked(i) = false; 
            end

        else

            % Remove x if it does not have associates
            marked(i) = false;

        end

        % If x has been removed
        if ~marked(i) 

            % foreach associate a of x do
            for j = 1:numel(LA{i})

                % Remove x from a list of nearest neighbour
                a = LA{i}(j);
                KNN{a}(KNN{a}==i) = [];

                % Find a new nearest neighbour for a
                knn_new = KNN{a}(k);

                % Add a to its new neighbour list of associates
                LA{knn_new} = [LA{knn_new} a];

                % Sort the associates list of knn_new according
                ...the distance to knn_new 
                x = X(knn_new,:);
                xa = X(LA{knn_new},:);
                dist_xa_x = dist(x,xa');
                [~,ind] = sort(dist_xa_x);
                LA{knn_new} = LA{knn_new}(ind);

            end 

        end

    end

end

XS = X;
YS = Y;
XS(~marked,:) = []; 
YS(~marked) = [];
remove = ~marked; 
