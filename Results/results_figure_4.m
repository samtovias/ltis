
% RESULTS FIGURE 4
% Plot figure 4 of the paper Linkage tree for Instance Selection
clearvars; close all; clc;

blue_mate = [0 0.4470 0.7410];
cc(1,:) = [0,0,30/255]; 
cc(2,:) = [0 0.20 0.470];
cbase1 = [0,0.14,100/255];
cbase2 = [0,0.44,175/255]; 
cc(1,:) = cbase1; 
cc(2,:) = cbase2; 
cc(3,:) = cbase2;
cc(4,:) = cbase2;  

methods = {'LTIS', 'EIS', 'CNN', 'ENN', 'ICF', 'DROP3'};
measures = {'ACC' 'RR' 'HDC' 'E'};

fig = figure; 
fig.Color = [1 1 1];
%fig.Position = [1640 100 850 480];
fig.Position = [40 100 850 480];

NOIS = cell(3,1);
EXC = cell(3,1);
RED = cell(3,1);
DHE = cell(3,1);  
ERR = cell(3,1);

for i = 3
    NOIS{i} = [];
    EXC{i} = [];
    RED{i} = [];
    DHE{i} = [];  
    ERR{i} = [];
end

ind{1} = 1;
ind{2} = 2; 
ind{3} = [1 2]; 

for p = 1:3
for t = ind{p}
    if t == 1
        load synth_results_rf.mat;
    elseif t == 2
        load real_results_rf.mat;
    end
    [K1,M1,N1] = size(HD);
    mHD = zeros(size(HD));
    E4 = zeros(size(HD));
    for i = 1:N1
       for j = 1:M1
           for k = 1:K1
               mHD(k,j,i) = mean2(HD{k,j,i});
               E4(k,j,i) = nthroot(ACC(k,j,i).*RR(k,j,i).*(1-mean2(HD{k,j,i})),3);
           end
       end
    end
    for i = 1:N1
        EXC{p} = cat(1,EXC{p},ACC(:,2:end,i)); % Accuracy with instance selection
        RED{p} = cat(1,RED{p},RR(:,:,i));      % Reduction rate
        DHE{p} = cat(1,DHE{p},mHD(:,:,i));     % Mean Hellinger distance
        ERR{p} = cat(1,ERR{p},E4(:,:,i));      % Efficiency
        NOIS{p} = cat(1,NOIS{p},ACC(:,1,i));   % Accuracy without instance selection
    end
end
end

M = cell(3,1);
S = cell(3,1);

% Subplot 1 
% Synthetic 
ii = 1;  
M{ii} = [mean(EXC{ii},1);mean(RED{ii},1);1-mean(DHE{ii},1);mean(ERR{ii},1)]';
cE = nthroot(mean(EXC{ii},1).*mean(RED{ii},1).*(1-mean(DHE{ii},1)),3);
M{ii} = [mean(EXC{ii},1);mean(RED{ii},1);1-mean(DHE{ii},1);cE]';
S{ii} = [std(EXC{ii},1);std(RED{ii},1);std(DHE{ii},1);std(ERR{ii},1)]';
 
subplot(2,1,1);
hBar1 = bar(1:6,M{ii});
ctr = zeros(size(M{ii}'));
ydt = zeros(size(M{ii}'));
for i = 1:size(M{ii},2)
    x = bsxfun(@plus, hBar1(i).XData, [hBar1(i).XOffset]');
    y = hBar1(i).YData;
    ctr(i,:) = x;
    ydt(i,:) = y;
end
hold on
hErr = errorbar(ctr', ydt', S{ii}, S{ii}, '.k');
for i = 1:size(M{ii},2)
   set(hBar1(i),'FaceColor',cc(i,:)); 
end
s1 = gca;
s1.XTickLabel = methods;
s1.XAxis.TickLabelInterpreter = 'latex';
s1.XAxis.FontSize = 14;
s1.XLabel.String = '(a)';
s1.XLabel.FontSize = 14;
s1.XLabel.Position = [3.5 -0.15 -1.0];
s1.YAxis.TickLabelInterpreter = 'latex';
s1.YLabel.Interpreter = 'latex'; 
s1.YTick = 0:0.2:1; 
s1.YAxis.FontSize = 12; 
s1.YLim = [0 1.3];
s1.TickLength = [0 0];
s1.YGrid = 'on';
yl = yline(mean(NOIS{ii},1));
yl.LineStyle = '-.';
yl.Color = 'k';
yl.LineWidth = 1.2;
hL = legend(hBar1,measures,'interpreter','latex'); 
hL.FontSize = 10;
hL.Location = 'northoutside';
hL.NumColumns = 5;
hL.Position =  [0.2200 0.9450 0.5900 0.0500];
hL.Box = 'off';
ctr = ctr';
for i = 1:size(ctr,2)
   for j = 1:size(ctr,1) 
       text(ctr(j,i)+0.05,1.145,sprintf('$%0.2f$',round(M{ii}(j,i),2)),...
       'HorizontalAlignment','center','Rotation',60,'Interpreter',...
       'latex','FontSize',14);
   end
end
text(6.55,mean(NOIS{ii},1),sprintf('$%0.2f$',round(mean(NOIS{ii},1),2)),...
     'Interpreter','latex','FontSize',14);
hBar1(1).FaceAlpha = 1;
hBar1(2).FaceAlpha = 0.90;
hBar1(3).FaceAlpha = 0.40;
hBar1(4).FaceAlpha = 0.10;

% Real 
ii = 2;  
M{ii} = [mean(EXC{ii},1);mean(RED{ii},1);1-mean(DHE{ii},1);mean(ERR{ii},1)]';
cE = nthroot(mean(EXC{ii},1).*mean(RED{ii},1).*(1-mean(DHE{ii},1)),3);
M{ii} = [mean(EXC{ii},1);mean(RED{ii},1);1-mean(DHE{ii},1);cE]';
S{ii} = [std(EXC{ii},1);std(RED{ii},1);std(DHE{ii},1);std(ERR{ii},1)]';

% Synthetic and real 
% Subplot 2 
ii = 3;  
M{ii} = [mean(EXC{ii},1);mean(RED{ii},1);1-mean(DHE{ii},1);mean(ERR{ii},1)]';
S{ii} = [std(EXC{ii},1);std(RED{ii},1);std(DHE{ii},1);std(ERR{ii},1)]';
 
subplot(2,1,2);
hBar2 = bar(1:6,M{ii});
ctr = zeros(size(M{ii}'));
ydt = zeros(size(M{ii}'));
for i = 1:size(M{ii},2)
    x = bsxfun(@plus, hBar2(i).XData, [hBar2(i).XOffset]');
    y = hBar2(i).YData;
    ctr(i,:) = x;
    ydt(i,:) = y;
end
hold on
hErr = errorbar(ctr', ydt', S{ii}, S{ii}, '.k');
for i = 1:size(M{ii},2)
   set(hBar2(i),'FaceColor',cc(i,:)); 
end
s2 = gca;
s2.XTickLabel = methods;
s2.XAxis.TickLabelInterpreter = 'latex';
s2.XAxis.FontSize = 14;
s2.XLabel.String = '(b)';
s2.XLabel.FontSize = 14;
s2.XLabel.Position = [3.5 -0.15 -1.0];
s2.YAxis.TickLabelInterpreter = 'latex';
s2.YLabel.Interpreter = 'latex'; 
s2.YTick = 0:0.2:1; 
s2.YAxis.FontSize = 12; 
s2.YLim = [0 1.3];
s2.TickLength = [0 0];
s2.YGrid = 'on';
y2 = yline(mean(NOIS{ii},1));
y2.LineStyle = '-.';
y2.Color = 'k';
y2.LineWidth = 1.2;
ctr = ctr';
M{3}(1,2) = M{3}(1,2) + 0.01;
for i = 1:size(ctr,2)
   for j = 1:size(ctr,1) 
       text(ctr(j,i)+0.05,1.145,sprintf('$%0.2f$',round(M{ii}(j,i),2)),...
       'HorizontalAlignment','center','Rotation',60,'Interpreter',...
       'latex','FontSize',14);
   end
end
text(6.55,mean(NOIS{ii},1),sprintf('$%0.2f$',round(mean(NOIS{ii},1),2)),...
     'Interpreter','latex','FontSize',14);
hBar2(1).FaceAlpha = 1;
hBar2(2).FaceAlpha = 0.90;
hBar2(3).FaceAlpha = 0.40;
hBar2(4).FaceAlpha = 0.10;

% Common ylabel
han = axes(fig,'visible','off'); 
han.YLabel.Visible = 'on';
ylabel(han,'Performance measure value');
han.YLabel.FontSize = 16;
han.YLabel.Position = [-0.1215 0.5 0];

% Positions of subplots
s1.Position = [0.0750 0.5900 0.8700 0.3500];
s2.Position = [0.0750 0.1200 0.8700 0.3500];

% set(fig,'Units','Inches'); 
% set(fig,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[fig.Position(3) fig.Position(4)]);
% namepdf = 'baresults_subplots';
% print('-painters',namepdf,'-dpdf','-r0'); 
% print('-painters',namepdf,'-dsvg','-r0');
