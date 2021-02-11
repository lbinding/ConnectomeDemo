%% Graph Theory Metrics 


%% Import data 
%import data
cntme_pre=importdata('hcpmmp_pre.csv');
cntme_post=importdata('hcpmmp_post.csv');

%Log10 transformation 
cntme_pre_log = log10(cntme_pre);
cntme_post_log = log10(cntme_post);

%Any -inf replace with zeros 
cntme_pre_log(~isfinite(cntme_pre_log)) = 0;
cntme_post_log(~isfinite(cntme_post_log)) = 0;

destrieux_labels = importdata('/Users/lawrencebinding/Desktop/demonstration/destrieux.txt');
destrieux_labels = destrieux_labels.textdata(3:164,2);
destrieux_labels = erase(destrieux_labels,"ctx_");

%% Centrallity
%Between centrallity 
betw_central_pre = betweenness_wei(cntme_pre_log);
betw_central_post = betweenness_wei(cntme_post_log);
betw_central = betw_central_post - betw_central_pre;

plot(betw_central, 'o','LineStyle', 'none')
xticks(1:162)
xticklabels(destrieux_labels);
xtickangle(90)

%% Efficiency 
%global_eff_pre_G = efficiency_wei(cntme_pre_log);
global_eff_post_G = efficiency_wei(cntme_post_log);


%% Clustering
%Normalise and get values between 0-1 
cntme_pre_log_norm = weight_conversion(cntme_pre_log, 'normalize');
cntme_post_log_norm = weight_conversion(cntme_post_log, 'normalize');
%Perform cluster
clstring_coef_pre = clustering_coef_wu(cntme_pre_log_norm);
clstring_coef_post = clustering_coef_wu(cntme_post_log_norm);







