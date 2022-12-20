
% REPRODUCE EXPERIMENTS-CLASSIC-IS
% For Real and Synthetic datasets
clearvars; clc; close all; 

% type = 1: Real 
% type = 2: Synthetic 
for type = 1:2

% Real 
if type == 1
    % Input datasets path for real  
    path0 = pwd; 
    path1 = fullfile(pwd,'Datasets-Selected','real');
    path2 = fullfile(pwd,'Datasets-Selected-2','real');
    folders = {'magic','page-blocks','penbased','phoneme','segment',...
               'texture','vowel','wall_following_robot_2D','yeast9c'};       
% Synthetic 
elseif type == 2
    % Input datasets path for synthetic  
    path0 = pwd; 
    path1 = fullfile(pwd,'Datasets-Selected','synthetic');
    path2 = fullfile(pwd,'Datasets-Selected-2','synthetic');
    folders = {'banana','concentric3','gauss3','half','ripley',...
               'spiral2'};       
end

% For each dataset performs K = 10 experiments 
N = numel(folders);
for i = 1:N
    capsule(path1,path2,folders,i)
end

end

%***********************************************************************
function capsule(path1,path2,folders,i)
K = 10; % For 10 folds  
    for k = 1:K
        kthFold_CNN(path1,path2,folders,i,k)   % CNN
        kthFold_ENN(path1,path2,folders,i,k)   % ENN
        kthFold_DROP3(path1,path2,folders,i,k) % DROP3
        kthFold_ICF(path1,path2,folders,i,k)   % ICF  
    end
end

%***********************************************************************
function kthFold_CNN(path1,path2,folders,i,k)
    % CNN 
    path_out = fullfile(path2,folders{i},'selected','CNN');
	fprintf('%s\n',path_out);
    if ~exist(path_out,'dir')
        mkdir(path_out); 
    end 
    pathSave = fullfile(path_out,sprintf('%s_%d.mat',folders{i},k));
    rutaTr = fullfile(path1,folders{i},'train',sprintf('%s_%d.mat',folders{i},k));
    load(rutaTr,'X','Y');
    [X,mn,mx] = minmaxnorm(X);           % Minmax normalization
    tstart = tic;
    [XS,YS] = is_cnn(X,Y);               % IS-CNN
    telapsed = toc(tstart); 
    params.NC = max(YS);
    params.D = size(XS,2);
    params.h = h_estimate(XS,YS,params); % Estimation bandwidth matrix 
    params.xh = linspace(-1.5,1.5,100);  % Linearly spaced vector
    P = get_pdf(XS,YS,params);           % PDF cell-array 
    x = [];
    f = [];
    iter = []; 
    XS = minmaxunnorm(XS,[mn;mx]);        % Minmax un-normalization
    X = XS;
    Y = YS;
    save(pathSave,'X','Y','P','x','f','iter','telapsed');
    fprintf('%s\n',pathSave);
end

%***********************************************************************
function kthFold_ENN(path1,path2,folders,i,k)
    % ENN 
    path_out = fullfile(path2,folders{i},'selected','ENN');
	fprintf('%s\n',path_out);
    if ~exist(path_out,'dir')
        mkdir(path_out); 
    end 
    pathSave = fullfile(path_out,sprintf('%s_%d.mat',folders{i},k));
    rutaTr = fullfile(path1,folders{i},'train',sprintf('%s_%d.mat',folders{i},k));
    load(rutaTr,'X','Y');
    [X,mn,mx] = minmaxnorm(X);           % Minmax normalization
    tstart = tic;
    [XS,YS] = is_enn(X,Y);               % IS-ENN
    telapsed = toc(tstart); 
    params.NC = max(YS);
    params.D = size(XS,2);
    params.h = h_estimate(XS,YS,params); % Estimation bandwidth matrix 
    params.xh = linspace(-1.5,1.5,100);  % Linearly spaced vector
    P = get_pdf(XS,YS,params);           % PDF cell-array 
    x = [];
    f = [];
    iter = []; 
    XS = minmaxunnorm(XS,[mn;mx]);        % Minmax un-normalization
    X = XS;
    Y = YS;
    save(pathSave,'X','Y','P','x','f','iter','telapsed');
    fprintf('%s\n',pathSave);
end

%***********************************************************************
function kthFold_DROP3(path1,path2,folders,i,k)
    % DROP3 
    path_out = fullfile(path2,folders{i},'selected','DROP3');
	fprintf('%s\n',path_out);
    if ~exist(path_out,'dir')
        mkdir(path_out); 
    end 
    pathSave = fullfile(path_out,sprintf('%s_%d.mat',folders{i},k));
    rutaTr = fullfile(path1,folders{i},'train',sprintf('%s_%d.mat',folders{i},k));
    load(rutaTr,'X','Y');
    [X,mn,mx] = minmaxnorm(X);           % Minmax normalization
    tstart = tic;
    [XS,YS] = is_drop3(X,Y);             % IS-DROP3
    telapsed = toc(tstart); 
    params.NC = max(YS);
    params.D = size(XS,2);
    params.h = h_estimate(XS,YS,params); % Estimation bandwidth matrix 
    params.xh = linspace(-1.5,1.5,100);  % Linearly spaced vector
    P = get_pdf(XS,YS,params);           % PDF cell-array 
    x = [];
    f = [];
    iter = []; 
    XS = minmaxunnorm(XS,[mn;mx]);        % Minmax un-normalization
    X = XS;
    Y = YS;
    save(pathSave,'X','Y','P','x','f','iter','telapsed');
    fprintf('%s\n',pathSave);
end

%***********************************************************************
function kthFold_ICF(path1,path2,folders,i,k)
    % ICF 
    path_out = fullfile(path2,folders{i},'selected','ICF');
	fprintf('%s\n',path_out);
    if ~exist(path_out,'dir')
        mkdir(path_out); 
    end 
    pathSave = fullfile(path_out,sprintf('%s_%d.mat',folders{i},k));
    rutaTr = fullfile(path1,folders{i},'train',sprintf('%s_%d.mat',folders{i},k));
    load(rutaTr,'X','Y');
    [X,mn,mx] = minmaxnorm(X);           % Minmax normalization
    tstart = tic;
    [XS,YS] = is_icf(X,Y);               % IS-ICF
    telapsed = toc(tstart); 
    params.NC = max(YS);
    params.D = size(XS,2);
    params.h = h_estimate(XS,YS,params); % Estimation bandwidth matrix 
    params.xh = linspace(-1.5,1.5,100);  % Linearly spaced vector
    P = get_pdf(XS,YS,params);           % PDF cell-array 
    x = [];
    f = [];
    iter = []; 
    XS = minmaxunnorm(XS,[mn;mx]);        % Minmax un-normalization
    X = XS;
    Y = YS;
    save(pathSave,'X','Y','P','x','f','iter','telapsed');
    fprintf('%s\n',pathSave);
end
