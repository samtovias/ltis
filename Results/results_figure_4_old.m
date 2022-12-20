% RESULTS_FIGURE_4
%   Plot figure 4 of the paper ID 3970

clearvars; close all; clc;

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
cc(1,:) = blue_mate;
cc(2,:) = wine;
cc(3,:) = orange;
cc(4,:) = yellow;

cc(1,:) = [0,30/255,0]; %[0,0,0];
cc(2,:) = [0 0.35 0];%120/255];
cc(3,:) = [0 0.50 0.1];
cc(4,:) = green;
  
NOIS = [];
EXC = [];
RED = [];
DHE = [];  
EHD = [];
ERR = [];
for t = 1:1
    if t == 1
        load synth_results_rf.mat;
    elseif t == 2
        load real_results_rf.mat;
    end
    [K,M,N] = size(HD);
    mHD = zeros(size(HD));
    E4 = zeros(size(HD));
    for i = 1:N
       for j = 1:M
           for k = 1:K
               mHD(k,j,i) = mean2(HD{k,j,i});
               E4(k,j,i) = nthroot(ACC(k,j,i).*RR(k,j,i).*(1-mean2(HD{k,j,i})),3);
           end
       end
    end
    for i = 1:N
        EXC = cat(1,EXC,ACC(:,2:end,i));    % Accuracy with instance selection
        RED = cat(1,RED,RR(:,:,i));         % Reduction rate
        DHE = cat(1,DHE,mHD(:,:,i));        % Mean Hellinger distance
        ERR = cat(1,ERR,E4(:,:,i));         % Efficiency
        NOIS = cat(1,NOIS,ACC(:,1,i));      % Accuracy without instance selection
    end
end

M1 = [mean(EXC,1);mean(RED,1);1-mean(DHE,1);mean(ERR,1)]';
S1 = [std(EXC,1);std(RED,1);std(DHE,1);std(ERR,1)]';

txt1 = {'LTIS-SA', 'DE-$F_{50}$', 'CNN', 'ENN', 'ICF', 'DROP3'};
txt2 = {'ACC' 'RR' 'HD' 'E'};

%fig = figure('color',[1 1 1],'Position',[1641 101 850 280]);
fig = figure('color',[1 1 1],'Position',[41 101 850 280]);
hBar = bar(1:6,M1);
ctr = zeros(size(M1'));
ydt = zeros(size(M1'));
for i = 1:size(M1,2)
    x = bsxfun(@plus, hBar(i).XData, [hBar(i).XOffset]');
    y = hBar(i).YData;
    ctr(i,:) = x;
    ydt(i,:) = y;
end
hold on
hErr = errorbar(ctr', ydt', S1, S1, '.k');
for i = 1:size(M1,2)
   set(hBar(i),'FaceColor',cc(i,:)); 
end
set(gca,'XTickLabel',txt1,'YTick',0:0.2:1,'FontSize',12,'YGrid','on');
%xlabel('IS method','FontSize',12);
ylabel('Medida de desempe\~{n}o','FontSize',14,'interpreter','latex');
ylim([0 1.3]);

fig.Children.XAxis.TickLabelInterpreter = 'latex';
fig.Children.YAxis.TickLabelInterpreter = 'latex';
fig.Children.YLabel.Interpreter = 'latex';
fig.Children.YLabel.Interpreter = 'latex';
fig.Children.Position = [0.065 0.10 0.875 0.82];% [0.05 0.11 0.9 0.815]; % 0.7750    0.8150
fig.Children.TickLength = [0 0];

yl = yline(mean(NOIS,1));
yl.LineStyle = '-.';
yl.Color = cc(3,:);
yl.LineWidth = 1;
hL = legend(hBar,txt2,'interpreter','latex'); 
hL.FontSize = 10;
hL.Location = 'northoutside';
hL.NumColumns = 5;
hL.Position = [0.2167    0.9239    0.5875    0.0700];
hL.Box = 'off';
ctr = ctr';
for i = 1:size(ctr,2)
   for j = 1:size(ctr,1) 
       text(ctr(j,i)+0.05,1.12,sprintf('$%0.3f$',M1(j,i)),'HorizontalAlignment','center','Rotation',60,'Interpreter','latex','FontSize',14);
   end
end
text(6.55,mean(NOIS,1),sprintf('$%0.3f$',mean(NOIS,1)),'Interpreter','latex','FontSize',14);

% hBar(1).FaceAlpha = 1;
% hBar(2).FaceAlpha = 0.8;
% hBar(3).FaceAlpha = 0.6;
% hBar(4).FaceAlpha = 0.4;
hBar(1).FaceAlpha = 1;
hBar(2).FaceAlpha = 1;
hBar(3).FaceAlpha = 0.6;
hBar(4).FaceAlpha = 0.2;

% set(fig,'Units','Inches'); 
% set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[fig.Position(3) fig.Position(4)]);
% namepdf = 'bar_performance_ltis_sa_vs_de_f50_synt';
% print('-painters',namepdf,'-dpdf','-r0'); 
% print('-painters',namepdf,'-dsvg','-r0');
