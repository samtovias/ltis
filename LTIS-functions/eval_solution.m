% EVAL_SOLUTION Evaluation of the solution in LTIS. 
%   [f,XS,YS,PS] = eval_solution(X,Y,P,L,x,params) returns fitness (f) of 
%   the current solution, the subset (XS,YS) and the PDF cell-array of 
%   the subset (PS). X is a dataset of size NxD (N instances and D dimensions), 
%   Y is a class label vector of size Nx1, P is the PDF cell-array of the 
%   original dataset, L is a cell array of size Cx1 (C classes) that contains the 
%   information of the hierarchical clustering of each class. x is the 
%   solution of the cut-off levels by each class and params is a structure 
%   that contains information of the problem.
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
% 
%   See also LTIS PERTURB

% ------------------------------------------------------------------------
%   EVAL_SOLUTION Version 1.0 (Matlab R2018b Unix)
%   January 2021
% ------------------------------------------------------------------------

function [f,XS,YS,PS] = eval_solution(X,Y,P,L,x,params)
% Select instances
XS = cell(1,params.NC);
YS = cell(1,params.NC);
for c = 1:params.NC
    [XS{c},YS{c}] = ithClass(X,Y,L,x,c,params);
end
XS = cat(1,XS{:});
YS = cat(1,YS{:});
% Get selected subset PDFs
PS = get_pdf(XS,YS,params);  
% hd: Hellinger distance matrix per class and dimension
hd = zeros(params.NC,params.D);
for c = 1:params.NC
    for d = 1:params.D 
        hd(c,d) = hellinger_distance(params.xh,P{c,d},PS{c,d});
    end
end
% Calculate fitness
% f1: Hellinger distance matrix
% f2: Normalized cut-off point 
f1 = hd; 
f2 = 1-((x-params.rmin)./(params.rmax-params.rmin))';
Ns = accumarray(YS,ones(numel(YS),1),[params.NC 1],@sum,0);
w = abs((Ns/sum(Ns))-(params.Ni/sum(params.Ni)));
f = mean(mean(bsxfun(@plus,params.w*f1,(1-params.w)*f2),2).^(1-w));

%**********************************************************************
function [XSc,YSc] = ithClass(X,Y,L,x,c,params)
Zc = L{c};
th = Zc(x(c),3);
Xc = X(Y==c,:);
T = cluster(Zc,'Cutoff',th,'Criterion','distance');
mx = max(T);
XSc = zeros(mx,params.D);
YSc = zeros(mx,1);
for m = 1:mx
    Xm = Xc(T==m,:);
    mn = mean(Xm,1);
    [~,id] = pdist2(Xm,mn,'minkowski',0.5,'Smallest',1);
    XSc(m,:) = Xm(id,:);
    YSc(m) = c;
end 
