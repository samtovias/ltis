% RESULTS_FIGURE_3
%   Plot figure 3 of the paper ID 3970

clearvars; close all; clc;

ruta = '../Datasets-Selected/synthetic';
folders = {'banana' 'concentric3' 'gauss3' 'half' 'ripley' 'spiral2'};
method = {'linkage_trees', 'ridDE', 'CNN', 'ENN', 'ICF', 'DROP3'};
names = {'Banana' 'Concentric' 'Gaussians' 'Horseshoes' 'Ripley' 'Spirals'};
txt1 = {'Original' 'LTIS', 'EIS', 'CNN', 'ENN', 'ICF', 'DROP3'};
kf = 9; 

load('synth_results_rf.mat');
[K,M,N] = size(HD);
mHD = zeros(size(HD));
E   = zeros(size(HD));
for i = 1:N
   for j = 1:M
       for k = 1:K
           mHD(k,j,i) = mean2(HD{k,j,i});
           E(k,j,i) = nthroot(ACC(k,j,i).*RR(k,j,i).*(1-mean2(HD{k,j,i})),3);
       end
   end
end

ACC = reshape(mean(ACC(:,2:end,:),1),6,6)';
RED = reshape(mean(RR,1),6,6)';
HD = reshape(mean(mHD,1),6,6)';
E  = reshape(mean(E,1),6,6)';

mrk = {'o' 'd' '^' 's' 'd'};
sze = [1 1 1];
cc = [0 0.4470 0.7410
      0.8500 0.3250 0.0980
      0.9290 0.6940 0.1250
      0.4940 0.1840 0.5560
      0.4660 0.6740 0.1880];

N = numel(folders);
folders = {'banana' 'concentric3' 'half'};  
N = 3; 
id = reshape(1:N*7,N,7)';  
%fig = figure('color',[1 1 1],'Position',[1641 101 470 550]);
fig = figure('color',[1 1 1],'Position',[1925 115 290 680]);
ha = tight_subplot(7,N,[.005 .005],[.01 .035],[.05 .01]);
for i = 1:N
    ids = id(:,i);
    Tr = load(fullfile(ruta,folders{i},'train',sprintf('%s_%d.mat',folders{i},kf)));
    for j = 1:7
       if j == 1
           load(fullfile(ruta,folders{i},'train',sprintf('%s_%d.mat',folders{i},kf)));
       else
           load(fullfile(ruta,folders{i},'selected',method{j-1},sprintf('%s_%d.mat',folders{i},kf)));
       end
       axes(ha(ids(j)));
       [~,mn,mx] = minmaxnorm(Tr.X);
       X = minmaxnorm(X,[mn;mx]);
       C = max(Y);
       for k = 1:C
           pp = plot(X(Y==k,1),X(Y==k,2),'o','MarkerFaceColor',cc(k,:),'MarkerEdgeColor','none');
           pp.Marker = mrk{k};
           pp.MarkerSize = sze(k);
           hold on;
       end
       set(gca,'XTick',[],'YTick',[]);
       axis square;
       axis xy;
       axis([-1.1 1.1 -1.1 1.3]);
       if j == 1
           title(sprintf('%s',names{i}),'FontWeight','Normal','FontName','Times New Roman','FontSize',8);
       end
       if (i == 1)
          ylabel(txt1{j},'FontName','Times New Roman','FontSize',8); 
       end
       if j > 1
           text(0,1.1,sprintf('$(%0.2f,%0.2f,%0.2f,%0.2f)$',ACC(i,j-1),RED(i,j-1),HD(i,j-1),E(i,j-1)),'Interpreter','latex','FontSize',5,'HorizontalAlignment','center');
       end
    end
end

% % Save figure 
% set(fig,'Units','Inches'); 
% set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[fig.Position(3) fig.Position(4)]);
% namepdf = 'syndata4';
% print('-painters',namepdf,'-dpdf','-r0','-bestfit');
