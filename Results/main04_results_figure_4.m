
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

cc(1,:) = [0,0,30/255]; %[0,0,0];
cc(2,:) = [0 0.20 0.470];%120/255];
cc(3,:) = blue_mate;
cc(4,:) = blue_mate;
  
NOIS = [];
EXC = [];
RED = [];
DHE = [];  
EHD = [];
ERR = [];
for t = 2:2
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

clearvars -except ACC HD RR EXC RED DHE ERR mHD E4 NOIS

% RESULTS 
LTIS = zeros(9,4); 
EIS = zeros(9,4); 

% LTIS 
i = 1;
LTIS(:,1) = reshape(round(mean(ACC(:,i+1,:)),2),9,1);   % ACC
LTIS(:,2) = reshape(round(mean(RR(:,i,:)),2),9,1);      % RR
LTIS(:,3) = reshape(round(1-mean(mHD(:,i,:)),2),9,1);   % HDC
%LTIS(:,4) = reshape(round(mean(E4(:,i,:)),2),9,1);     % E
LTIS(:,4) = nthroot(LTIS(:,1).*LTIS(:,2).*LTIS(:,3),3); 
LTIS(:,1) = min(LTIS(:,1),0.99);
LTIS(:,2) = min(LTIS(:,2),0.99);
LTIS(:,3) = min(LTIS(:,3),0.99);
LTIS(:,4) = min(LTIS(:,4),0.99);
% To exchange R5 and R6 (Image segmentation and texture) 
aux = LTIS(5,:); 
LTIS(5,:) = LTIS(6,:); 
LTIS(6,:) = aux;
mLTIS = round(mean(LTIS),2);

% EIS 
i = 2;  
EIS(:,1) = reshape(round(mean(ACC(:,i+1,:)),2),9,1); % ACC
EIS(:,2) = reshape(round(mean(RR(:,i,:)),2),9,1);    % RR
EIS(:,3) = reshape(round(1-mean(mHD(:,i,:)),2),9,1); % HDC
%EIS(:,4) = reshape(round(mean(E4(:,i,:)),2),9,1);   % E
EIS(:,4) = nthroot(EIS(:,1).*EIS(:,2).*EIS(:,3),3);  %
EIS(:,1) = min(EIS(:,1),0.99);
EIS(:,2) = min(EIS(:,2),0.99);
EIS(:,3) = min(EIS(:,3),0.99);
EIS(:,4) = min(EIS(:,4),0.99);
% To exchange R5 and R6 (Image segmentation and texture) 
aux = EIS(5,:); 
EIS(5,:) = EIS(6,:); 
EIS(6,:) = aux;
mEIS = round(mean(EIS),2);

% Original 
XP = reshape(round(mean(ACC(:,1,:)),2),9,1);   % ACC
XP = min(XP,0.99);
% To exchange R5 and R6 (Image segmentation and texture)
aux = XP(5); 
XP(5) = XP(6); 
XP(6) = aux;
mXP = round(mean(XP),2);


% Write file
fileID = fopen('TABLEII.txt','w');
for i = 1:9
fprintf(fileID,'%.2f %.2f %.2f %.2f\n',LTIS(i,1),LTIS(i,2),LTIS(i,3),LTIS(i,4));
end
fprintf(fileID,'%.2f %.2f %.2f %.2f\n',mLTIS(1),mLTIS(2),mLTIS(3),mLTIS(4));
fprintf(fileID,'\n\n\n');
for i = 1:9
fprintf(fileID,'%.2f %.2f %.2f %.2f\n',EIS(i,1),EIS(i,2),EIS(i,3),EIS(i,4));
end
fprintf(fileID,'%.2f %.2f %.2f %.2f\n',mEIS(1),mEIS(2),mEIS(3),mEIS(4));
fclose(fileID);
