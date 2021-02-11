%% Importing data 
%Import using a premade script (GITHUB)
GNT_decline = ImportFolder('/Volumes/MSC_IFOF/retro_connectome/LeftLeft_1_5/fluAN_decline/pre','*pre.csv');
GNT_statImprov = ImportFolder('/Volumes/MSC_IFOF/retro_connectome/LeftLeft_1_5/fluAN_static/pre','*pre.csv');

%Concatinate two inputs to a singular file...
% !!!!!IMPORTANT ORDER!!!!!!!
GNT_postop = cat(3,GNT_decline, GNT_statImprov);
%Save File 
save fluANpre_Connectomes.mat GNT_postop

%% Create design matrix  
% Create design matrix, assign it to (:,1) ones + (:,2) zeros
designMatrix(1:size(GNT_decline,3),1) =1;
designMatrix(:,2)=0;
%get max size of connectome contrasts  
sizeof = size(GNT_statImprov,3) + size(GNT_decline,3);
%create second half of design matrix (:,1)=zeros, (:,2)=ones 
designMatrix(size(GNT_decline,3):sizeof,1) =0;
designMatrix(size(GNT_decline,3):sizeof,2) =1;
%SaveFile
save fluANpre_designMatrix.mat designMatrix

%% NBS script tutorial 
%Takes around 2 days to run... 
iteration = 1; 
for range = 0.05:0.05:5
    %Convert the range into a string for NBS
    range_str = string(range);
    % Display what t-stat we're using 
    disp(range_str)
    % UI structure corresponding to the example data provided:
    UI.method.ui='Run NBS'; 
    UI.test.ui='t-test';
    UI.size.ui='Extent';
    UI.thresh.ui=range_str;
    UI.perms.ui='5000';
    UI.alpha.ui='0.05';
    UI.contrast.ui='[1,-1]'; 
    UI.design.ui='/Volumes/MSC_IFOF/retro_connectome/LeftLeft_1_5/fluANpre_designMatrix.mat';
    UI.exchange.ui=''; 
    UI.matrices.ui='/Volumes/MSC_IFOF/retro_connectome/LeftLeft_1_5/fluANpre_Connectomes.mat';
    UI.node_coor.ui='/Users/lawrencebinding/Documents/Glasser_2016/aalCOG.txt';                         
    UI.node_label.ui='/Users/lawrencebinding/Documents/Glasser_2016/Atlas_label.mat';
    % Run with the above UI
    NBSrun(UI,[])
    % Assign to a variable for inspection afterwards 
    global nbs
    stats_nbs{iteration,1} = nbs;
    iteration = iteration + 1; 
end


%% General post-NBS stats 
% Get some ideas about our model...

%Loop through the connectivity matrix, count number of sig connections
for n = 1:size(stats_nbs,1)
    tst_stats_tmp = stats_nbs{n}.NBS.con_mat{1};
    n_sig(n) = sum(tst_stats_tmp(:) == 1);
end
%Display in a figure 
figure
bar(n_sig)
title('# Significant networks at each threshold')

%% Visualisation 
%For this we use BrainNet :: Least complicated file 
%This is (one) of the required inputs, converting the ATLAS to a .node file
BrainNet_GenCoord('/Users/lawrencebinding/Documents/Glasser_2016/fsaverage_hcpmmp1_parcels.nii','/Users/lawrencebinding/Documents/Glasser_2016/fsavg_hcpmmp_nodes.node')
%Create a matrix of the 
significant = full(stats_nbs{5}.NBS.con_mat{1});
save significant.edge significant -ascii
BrainNet


%% FOR DEMO
significant = full(stats.NBS(5,1).con_mat{1, 1});
