% LTIS Instance selection based on linkage trees. 
%   [subset,solution,curves] = ltis(X,Y,w,dataset_name,num_exp) returns 
%   three structures: the selected subsets (subset), the cut-off points
%   of the best solution (solution), and the energy and temperature values 
%   of the complete execution (curves). X is a dataset of size NxD 
%   (N instances and D dimensions), Y is a class label vector of size Nx1,
%   w is a real scalar value for weight the fitness function, dataset_name
%   is a string with the name of the dataset, and exp is an integer of the
%   number of the current experiment. LTIS is a simulated annealing 
%   algorithm used for instance selection with a novel proposed real 
%   encoding based on linkage trees.   
% 
%   Example:
%   -------
%   load vowel.mat                   % Load dataset
%   dataset_name = 'vowel';          % Dataset name
%   exp = 1;                         % Number of experiment or fold
%   w = 0.5;                         % Fitness function weight
%   [subset,solution,curves] =...
%   ltis(X,Y,w,dataset_name,exp)     % LTIS     
% 
%   See also EVAL_SOLUTION PERTURB

% ------------------------------------------------------------------------
%   LTIS Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function [subset,solution,curves]= ltis(X,Y,w,dataset_name,num_exp)
    
% Simulated annealing parameters     
T = 5;                    % Start temperature
Tmin = 1e-9;              % Final temperature
cooling =  @(T)(0.99*T);  % Cooling schedule
Ns = 20;                  % Markov chain lenght

% Normalize in the range [-1,1]
[X,mn,mx] = minmaxnorm(X);           
params.D  = size(X,2);	             % Dimensionality
params.NC = max(Y);                  % Number of classes
params.xh = linspace(-1.5,1.5,100);  % PDF grid
params.w = w;                        % Weigth of objective function

% Number of patterns per class
params.Ni = accumarray(Y,ones(numel(Y),1),[params.NC 1],@sum,0);                    

% Estimate h matrix per class and dimension with Silverman rule
params.h = h_estimate(X,Y,params);

% Obtain original PDFs
P = get_pdf(X,Y,params);

% Create dendrogram  by class  
r = zeros(1,params.NC);
L = cell(1,params.NC);
for c = 1:params.NC
    Xc = X(Y==c,:);
    % Get linkage tree of the cth-Class
    Zc = linkage(Xc,'complete',{'minkowski',0.5});
    % Avoid zero cut-off
    id = Zc(:,3) == 0;
    Zc(id,3) = 0.1*min(Zc(~id,3)); 
    % Get limits search
    r(c) = size(Zc,1);          
    L{c} = Zc;
end
params.rmax = r;
params.rmin = ones(1,params.NC);

% Create the initial solution
x = zeros(1,params.NC);
for i = 1:params.NC
    x(i) = randi([params.rmin(i) params.rmax(i)],1,1);
end

% Evaluate the initial solution
[f,XS,YS,PS] = eval_solution(X,Y,P,L,x,params);

% Save the best solution 
bx = x;
bf = f;
bXS = XS;
bYS = YS;
bPS = PS;

curve_bf = bf;
curve_f = f; 
curve_reject = 0; 
curve_T = T; 

reject = 0;
max_reject = 500;    

% Simulated annealing loop 
count_sa = 0;
iter = 0; 
while T > Tmin
    count_sa = count_sa + 1;
    for i = 1:Ns
       x_ = perturb(x,params); 
       [f_,XS_,YS_,PS_] = eval_solution(X,Y,P,L,x_,params);
       df = f_ - f;
       % Accept the best solution
       if df < 0 
           x  = x_;
           f  = f_;
           XS = XS_;
           YS = YS_;
           PS = PS_;
           reject = 0;
       else
           % Accept with some probability
           if rand < exp(-df/T) 
               x  = x_;
               f  = f_;
               XS = XS_;
               YS = YS_;
               PS = PS_;
           else
               reject = reject+1;
           end
       end
       if f < bf
          bf = f;
          bx = x;
          bXS = XS;
          bYS = YS;
          bPS = PS;
       end
       curve_bf = cat(2,curve_bf,bf);
       curve_f = cat(2,curve_f,f);
       curve_reject = cat(2,curve_reject,reject); 
       fprintf('T = %0.5g, bestE = %0.4f, currE = %0.4f, rej = %d, data: %s, exp: %d, w = %0.2f\n',...
                T,bf,f,reject,dataset_name,num_exp,params.w);
       iter = iter + 1;     
    end
    if reject > max_reject
        break;
    end
    T = cooling(T);
    curve_T = cat(2,curve_T,T);
end
    
% Unnormalize
XS = minmaxunnorm(XS,[mn;mx]);
bXS = minmaxunnorm(bXS,[mn;mx]);

% Save subsets 
subset.XS = XS; 
subset.YS = YS; 
subset.PS = PS; 
subset.bXS = bXS; 
subset.bYS = bYS; 
subset.bPS = bPS; 
    
% Save solutions
solution.bx = bx; 
solution.x = x; 

% Save convergence curves
curves.curve_bf = curve_bf;
curves.curve_f = curve_f; 
curves.curve_reject = curve_reject;
curves.curve_T = curve_T;
curves.iter = iter; 
