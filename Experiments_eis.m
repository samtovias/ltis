
% REPRODUCE EXPERIMENTS-EIS
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
        kthFold(path1,path2,folders,i,k)
    end
end

%***********************************************************************
function kthFold(path1,path2,folders,i,k)
    path_out = fullfile(path2,folders{i},'selected','ridDE');
	fprintf('%s\n',path_out);
    if ~exist(path_out,'dir')
        mkdir(path_out); 
    end 
    pathSave = fullfile(path_out,sprintf('%s_%d.mat',folders{i},k));
    rutaTr = fullfile(path1,folders{i},'train',sprintf('%s_%d.mat',folders{i},k));
    load(rutaTr,'X','Y');
    dataset_name = folders{i};
    exp = k; 
    w = 0.5; 
    tstart = tic;
    [bXS,bYS,bPS,bx,bf,curves] = eis(X,Y,w,dataset_name,exp);
    telapsed = toc(tstart);
    X = bXS;
    Y = bYS; 
    P = bPS; 
    x = bx;
    f = bf;
    iter = curves; 
    save(pathSave,'X','Y','P','x','f','iter','telapsed');
    fprintf('%s\n',pathSave);
end
