% PERTURB Perturbation function in LTIS.
%   x = perturb(x,params) returns a new solution x by modifying with some 
%   probability certain values of x. params is a structure that contains 
%   information of the problem. 
%   
%   Example:
%   -------
%   load vowel.mat                           % Load dataset 
%   X = minmaxnorm(X);                       % Normalize dataset
%   N = size(X,1);                           % Number of instances
%   params.N = N; 
%   params.NC = max(Y);                      % Number of classes 
%   params.D = size(X,2);                    % Number of dimensions 
%   params.h = h_estimate(X,Y,params);       % Estimation bandwidth matrix 
%   params.xh = linspace(-1.5,1.5,100);      % Linearly spaced vector 
%   params.w = 0.5;                          % Weight of the objective function
%   params.Ni = accumarray(Y,...
%   ones(numel(Y),1),[params.NC 1],@sum,0);  % Number of patterns per class
%   P = get_pdf(X,Y,params);                 % PDF cell-array   
%   r = zeros(1,params.NC);                     
%   L = cell(1,params.NC);                      
%   for c = 1:params.NC                      % Linkage-tree by class
%     Xc = X(Y==c,:);
%     Zc = linkage(Xc,'complete',...            
%                 {'minkowski',0.5});
%     id = Zc(:,3) == 0;
%     Zc(id,3) = 0.1*min(Zc(~id,3)); 
%     r(c) = size(Zc,1);          
%     L{c} = Zc;
%   end
%   params.rmax = r;                         % Cut-off limits 
%   params.rmin = ones(1,params.NC);                  
%   x = zeros(1,params.NC);
%   for i = 1:params.NC                      % Generate a solution  
%     x(i) = randi([params.rmin(i) ...
%             params.rmax(i)],1,1);
%   end 
%   [f,XS,YS,PS] = eval_solution(X,Y,P,L,... % Evaluate solution
%                                x,params);
%   x = perturb(x,params)                    % Perturb the current solution
% 
%   See also LTIS EVAL_SOLUTION

function x = perturb(x,params)
p = randi([1 params.NC],1,1);
j = randperm(params.NC,p);
for i = 1:p
    if rand < 0.5
        z = x(j(i)) - 1;
    else
        z = x(j(i)) + 1;
    end
    x(j(i)) = min(max(z,params.rmin(j(i))),params.rmax(j(i)));
end

