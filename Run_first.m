% FIRST RUN THIS FILE TO LOAD ALL FUNCTIONS IN DIRECTORY 
clearvars; close all; clc;
addpath(fullfile(pwd,'C-functions'),...
        fullfile(pwd,'C-functions','Source-C-codes'));
addpath(fullfile(pwd,'Classic-IS'));
addpath(fullfile(pwd,'Classification'));
addpath(genpath(fullfile(pwd,'Datasets-Original')));
addpath(genpath(fullfile(pwd,'Datasets-Selected')));
addpath(fullfile(pwd,'EIS-functions'));
addpath(fullfile(pwd,'LTIS-functions'));
addpath(fullfile(pwd,'Normalization'));
addpath(fullfile(pwd,'PDF-functions'));
addpath(fullfile(pwd,'Results'));
