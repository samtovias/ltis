
% Supplementary Material for Paper CCE2021 Submission 74 
% Title: Instance Selection Based on Linkage Trees 
%
% IMPORTANT: First run "Run_first.m" file.
%
% This material contains the necessary functions for the 
% reproducibility of the work presented in the paper divided 
% in ten subfolders: 
%
%   Classic-IS 
%   ----------
%       is_cnn   - Condensed nearest neighbor.
%       is_enn   - Edited nearest neighbor.
%       is_drop3 - Decremental reduction optimization procedure. 
%       is_icf   - Iterative case filtering.
% 
%   Classification 
%   --------------
%       classify_RF - Classify data with random forest classifier. 
%       train_RF    - Train random forest classification model.
%
%   Datasets-Original
%   --------
%       Real      - Original real datasets 
%       Synthetic - Original synthetic datasets
% 
%   Datasets-Selected
%   --------
%       Real      - Real datasets, 10-fold cross-validation partitions and IS-results. 
%       Synthetic - Synthetic datasets, 10-fold cross-validation partitions and IS-results.
%    
%   EIS-functions
%   -------------
%       eis             - Evolutionary instance selection with differential evolution.
%       eval_individual - Evaluation of an individual. 
%    
%   LTIS-functions 
%   --------------
%       eval_solution - Evaluation of the solution in LTIS.               
%       ltis          - Instance selection based on linkage tree.
%       perturb       - Perturbation function in LTIS.
%   
%   Normalization 
%   -------------
%       minmaxnorm   - Min-max normalization.
%       minmaxunnorm - Min-max un-normalization
% 
%   PDF-functions 
%   -------------
%       get_pdf            - Probability density function matrix. 
%       h_estimate         - Bandwidth matrix for PDF estimation.
%       hellinger_distance - Hellinger distance computation.
%       kde                - Kernel density estimation. 
%       silverman          - Silverman rule of thumb for bandwidth estimation.
%
%   Results 
%   -------------
%       tight_subplot      - Creates subplot axes with adjustable gaps and margins. 
%       results_figure_3   - To reproduce figure 3 in the paper.
%       results_figure_4   - To reproduce figure 4 in the paper.
%    
%   C-functions/Source-C-Codes 
%   -----------
%       Shuffle.c - Random permutation of array elements
%                   NOTE: For C code function 'Shuffle.c' 
%                         could be necessary to re-compile 
%                         from the source code using the 
%                         mex function. 
