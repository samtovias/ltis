% RESULTS_FIGURE_3
%   Plot figure 3 of the paper Linkage tree for Instance Selection


clearvars; close all; clc;

ruta = '../Datasets-Selected/synthetic';
folders = {'banana' 'concentric3' 'gauss3' 'half' 'ripley' 'spiral2'};
method = {'linkage_trees', 'ridDE', 'CNN', 'ENN', 'ICF', 'DROP3'};
names = {'Banana' 'Concentric' 'Gaussians' 'Horseshoes' 'Ripley' 'Spirals'};
txt1 = {'$X_P$' 'LTIS-SA', 'DE-$F_{50}$', 'CNN', 'ENN', 'ICF', 'DROP3'};
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
HD = 1-HD;
mrk = {'o' 'd' '^' 's' 'd'};
sze = [1 1 1];
cc = [0 0.4470 0.7410
      0.8500 0.3250 0.0980
      0.9290 0.6940 0.1250
      0.4940 0.1840 0.5560
      0.4660 0.6740 0.1880];
  
blue_mate = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
yellow = [0.9290 0.6940 0.1250];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
skyblue = [0.3010 0.7450 0.9330];
wine = [0.6350 0.0780 0.1840];

cbase1 = [0,0.14,100/255];
cc(1,:) = cbase1; %[0 0.20 0.470]; %blue_mate;
cc(2,:) = wine;
cc(3,:) = yellow;
cc(4,:) = yellow;
    
  
N = numel(folders);
id = reshape(1:42,7,6)';  
%figure('color',[1 1 1],'Position',[1641 101 470 550]);
fig = figure('color',[1 1 1],'Position',[16 101 550 470]); % Horz 
%ha = tight_subplot(6,7,[.0005 .0005],[.01 .035],[.035 .01]);
%ha = tight_subplot(6,7,[.001 .001],[.01 .03],[.03 .01]);
ha = tight_subplot(6,7,[.002 .002],[.002 .03],[.03 .001]);
for i = 1:N
    ids = id(i,:);  
    Tr = load(fullfile(ruta,folders{i},'train',sprintf('%s_%d.mat',folders{i},kf)));
    [X,mn,mx] = minmaxnorm(Tr.X);
    Y = Tr.Y; 
    C = max(Tr.Y);
    for j = 1:7 
        if j > 1  
        XS = load(fullfile(ruta,folders{i},'selected',method{j-1},sprintf('%s_%d.mat',folders{i},kf)));
        X = XS.X;
        Y = XS.Y;
        X = minmaxnorm(X,[mn;mx]);
        end
        axes(ha(ids(j)));
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
        
        if i == 1
           title(sprintf('%s',txt1{j}),'FontWeight','Normal','FontName','Times New Roman','FontSize',8.5,'Interpreter','latex');
        end
        if (j == 1)
           ylabel(names{i},'FontName','Times New Roman','FontSize',8.5,'Interpreter','latex');
        end
        if j > 1
           text(0,1.1,sprintf('$(%0.2f,%0.2f,%0.2f,%0.2f)$',ACC(i,j-1),RED(i,j-1),HD(i,j-1),E(i,j-1)),'Interpreter','latex','FontSize',5.75,'HorizontalAlignment','center');
        end
        
    end 
end

% Save figure 
set(fig,'Units','Inches'); 
set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[fig.Position(3) fig.Position(4)]);
namepdf = 'syndata_figure';
print('-painters',namepdf,'-dpdf','-r0','-loose');
print('-painters',namepdf,'-dsvg','-r0','-loose');
