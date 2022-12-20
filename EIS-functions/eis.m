% EIS Evolutionary instance selection. 
%   [bXS,bYS,bPS,bx,bf,curves] = eis(X,Y,w,dataset_name,exp) returns a
%   selected subset (bXS, bYS), its corresponding PDFs cell-array (bPS), 
%   the best binary individual (bx), its fitness (bf), and the convergence 
%   curves (curves). X is a dataset of size NxD (N instances and D 
%   dimensions), Y is a class label vector of size Nx1, w is a real scalar 
%   value for weight the fitness function, dataset_name is a string with 
%   the name of the dataset, and exp is an integer of the number of the 
%   current experiment. EIS is a binary coded differential evolution used 
%   for instance selection with classic simple binary encoding (SBE).
% 
%   Example:
%   -------
%   load vowel.mat                   % Load dataset
%   dataset_name = 'vowel';          % Dataset name
%   exp = 1;                         % Number of experiment or fold
%   w = 0.5;                         % Fitness function weight
%   [bXS,bYS,bPS,bx,bf,curves] = ... 
%       eis(X,Y,w,dataset_name,exp); % EIS     
% 
%   See also EVAL_INDIVIDUAL
%
%
%   Reference:
%   ---------
%   Dilip Datta and José Rui Figueira (2013) A real–integer–discrete-coded
%   differential evolution, Applied Soft Computing, Volume 13, Issue 9, 
%   3884-3893, ISSN 1568-4946, DOI: 10.1016/j.asoc.2013.05.001. 

% ------------------------------------------------------------------------
%   EIS Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function [bXS,bYS,bPS,bx,bf,curves] = eis(X,Y,w,dataset_name,exp)

% Differential evolution parameters
params.NP   = 100;  % Population size
params.gens = 2000; % Number of generations
params.cr   = 0.9;  % Crossover rate
params.pm   = 0.2;  % Mutation probability
params.w    = w;    % Fitness function weight

% Save original dataset 
X0 = X;

% Normalize between [-1,1]
X = minmaxnorm(X);      

% DE-selection method 
% 1: typical  
% 2: elite-preserving mechanism
de_selection = 2;                  
                   
% IS problem parameters 
params.N    = numel(Y);               % Number of patterns
params.D    = size(X,2);              % Dimensionality
params.C    = unique(Y);              % Classes
params.NC   = numel(params.C);        % Number of classes
params.xh   = linspace(-1.5,1.5,100); % PDF grid
% Number of patterns per class
params.Ni = accumarray(Y,ones(numel(Y),1),[params.NC 1],@sum,0); 

% Indices of individuals except target vectors
base = meshgrid(1:params.NP,1:params.NP);
base(logical(eye(params.NP))) = 0;
base = sort(base,2);
base(:,1) = [];
params.idx = base;  

% Estimate bandwidth matrix with Silverman rule of thumb
params.h = h_estimate(X,Y,params);

% Obtain parent PDFs
P = get_pdf(X,Y,params);

% Initialize population
Xbin = logical(randi([0 1],params.NP,params.N)); % TRUE if instance is selected
Xfit  = zeros(params.NP,1);                      % Fitness
Xpdf  = cell(params.NP,1);                       % Memory for PDFs of 
                                                   ...selected individuals
% Evaluate init population 
parfor i = 1:params.NP
   [Xfit(i),Xpdf{i}] = eval_individual(X,Y,Xbin(i,:),params,P);
end
poolobj = gcp('nocreate');

% Curves 
bfit = nan(1,params.gens+1);   % For fitness
nfit = zeros(1,params.gens+1); % For ratio of selected instances
hfit = zeros(1,params.gens+1); % For Hellinger distance
[bfit,hfit,nfit] = save_evolution(bfit,hfit,nfit,Xfit,Xbin,params,0);

% Main real–integer–discrete-coded DE
% Generations 
for t = 1:params.gens

    tStart = tic; 

    % Mutation (Boolean expressions calculated from Table 1)
    idx = Shuffle(params.idx,2);
    xa = Xbin(idx(:,1),:);
    xb = Xbin(idx(:,2),:);
    xc = Xbin(idx(:,3),:);
    x  = (xa&(~xb)) | (xa&xc) | ((~xa)&xb&(~xc));
    y  = rand(params.NP,params.N) >= params.pm;
    Vbin = ((~x)&(~y)) | (x&y);
    
    % Crossover
    Ubin = Xbin;
    idx = rand(params.NP,params.N) <= params.cr; % (Equation 2)
    Ubin(idx) = Vbin(idx);
    
    % Evaluate trial
    Ufit  = zeros(params.NP,1);
    Updf  = cell(params.NP,1);
    parfor i = 1:params.NP
        [Ufit(i),Updf{i}] = eval_individual(X,Y,Ubin(i,:),params,P);
    end
    
    % Selection
    % Typical selection trial replaces parent if best (Equation 3)
    if de_selection==1 
        idx = Ufit < Xfit;
        Xfit(idx) = Ufit(idx);
        Xbin(idx,:) = Ubin(idx,:);
        Xpdf(idx) = Updf(idx);
        
    % Elite-preserving mechanism (Section 4.4)
    elseif de_selection==2 
        XUfit = cat(1,Xfit,Ufit);
        XUbin = cat(1,Xbin,Ubin);
        XUpdf = cat(1,Xpdf,Updf);
        [XUfit,idx] = sort(XUfit,'ascend');
        XUbin = XUbin(idx,:);
        XUpdf = XUpdf(idx);
        Xfit = XUfit(1:params.NP);
        Xbin = XUbin(1:params.NP,:);
        Xpdf = XUpdf(1:params.NP);
    end
    
    tEnd = toc(tStart);
    
    % Display current generation information
    [bfit,hfit,nfit] = save_evolution(bfit,hfit,nfit,Xfit,Xbin,params,t);
    fprintf('EIS | Gen: %d - fit: %0.4f - data: %s - exp: %d - TIme %f\n',...
            t,min(Xfit),dataset_name,exp,tEnd);
end

% Save solution, selected instances, PDF matrix and convergence curves
[bf,imn] = min(Xfit);
bx  = Xbin(imn,:);
bXS = X0(bx,:);
bYS = Y(bx,:);
bPS = get_pdf(bXS,bYS,params);
curves.bfit = bfit;
curves.hfit = hfit;
curves.nfit = nfit;

delete(poolobj);

%***********************************************************************
function [bfit,hfit,nfit] = save_evolution(bfit,hfit,nfit,Xfit,Xbin,params,t)
[fit,i] = min(Xfit);
idx = Xbin(i,:);
bfit(t+1) = fit;
nfit(t+1) = sum(idx)/params.N;
hfit(t+1) = (fit - (1-params.w)*nfit(t+1))/params.w;
