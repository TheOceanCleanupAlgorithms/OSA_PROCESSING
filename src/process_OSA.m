% Wrapper to compute the OSA for a batch of cases defined in the following

%% OSA parameters
method = 1; % 0 is to compute the BAU with the particles, 1 is directly with the stats 
cod_cdf = 0;% comparison between the CDF 
cod_bar = 1;% are we looking at the individual barriers density
cod_fig = 0;% do we plot the figures - 1 or not - 0
cod_recompute = 1;% shortcut to use directly cleanup ratio_computation 
cod_cleanup = 0; 
cod_ver = 7;
start_year = 2009;
end_year = 2018;

% Definition of the cases
pc_gpgp_file_opts = [1,3]; % GPGP growth
us_cleanup_opts = 0; % upstream cleanup
ss_list_opts = [1,4,5];% steering strategy
ntimes_list_opts = [2,2,8];%,2,8]; % number of points per day
nsys_list_opts = [10,15,20];
cleanup_ratio_list_opts = [0.32, 0.56];
% pc_gpgp_file_opts = [1];
% us_cleanup_opts = 0;
% ss_list_opts = [1,4,5];
% ntimes_list_opts = [2,2,8];
% nsys_list_opts = [10 15 20];
% cleanup_ratio_list_opts = [0.32];

% Looping on the cases
count_opts = 0;
for i=1:length(pc_gpgp_file_opts)
    for j=1:length(ss_list_opts)
        for k=1:length(nsys_list_opts)
            for l=1:length(cleanup_ratio_list_opts)
                count_opts = count_opts + 1;
                pc_gpgp_file(1,count_opts) = pc_gpgp_file_opts(i);
                pc_gpgp_stats(1,count_opts) = pc_gpgp_file_opts(i);
                ss_list(1,count_opts) = ss_list_opts(j);
                ntimes_list(1,count_opts) = ntimes_list_opts(j);
                nsys_list(1,count_opts) = nsys_list_opts(k);
                cleanup_ratio_list(1,count_opts) = cleanup_ratio_list_opts(l);
            end
        end
    end
end
n_combo = length(nsys_list);

% Definition of bounding boxes for the OSA
bbox1 = [190 250 10 50];
bbox2 = [200 235.04 20 45.04];
threshold = 0.75;
dx = 0.08;
nsteps_rescale = 7;
bisex_days = 366;

% Run OSA processing
if cod_recompute == 1
    rescaling_GPGP
else
    load("../results/cleanup_ratio_grid1.mat")
end

%% Mass balance parameters

% General parameters
start_year = 2027; % start year of the mass balance exercise
end_year = 2037;   % end year of the mass balance exercise
ds_cleanup_delay = 0; % downstream cleanup delay year
us_cleanup_delay = 5; % upstream cleanup delay year
nsteps = end_year - start_year + 1; 
steps = [0.01; 0.03];
ratio_bo_fr = (1-1/7.14);
cleaning_ratio_tab = ones(1,n_combo);
us_cleanup = zeros(1,n_combo);

%% Mass balance code
code_with_degrading_inflow;

% Cases characteristics
%pc_gpgp_file = [0,1,2,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,-1,-3,-1,-3,-1,-3];
%pc_gpgp_file = [3,3,3,-1,-3,-1,-3,-1,-3];
%pc_gpgp_file = [1,1,1,1,1,1,1,1,1];%3,3,3];
%pc_gpgp_stats = [0,1,2,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3,-1,-3,-1,-3,-1,-3];
%pc_gpgp_stats = [3,3,3,3,3,3,3,3,3];
%pc_gpgp_stats = [1,1,1,1,1,1,1,1,1];%,3,3,3];
%us_cleanup = [0,0,0,50,100,50,100,50,100];
%us_cleanup = [0,0,0,0,0,0,0,0,0];%,0,0,0];
%ss_list = [1,1,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,1,1,2,2,3,3];
%ss_list = [1,2,3,1,1,2,2,3,3];
%ss_list = [1,2,3,1,2,3,1,2,3];%,1,2,3];
%nsys_list = [10,10,10,10,15,15,20,20,10,10,15,15,20,20,10,10,15,15,20,20,10,10,10,10,10,10];
%nsys_list = [10,10,10,10,10,10,10,10,10];
%nsys_list = [10,10,10,15,15,15,20,20,20];%,10,10,10];
%ntimes_list = [8,8,8,8,8,8,8,8,2,2,2,2,2,2,2,2,2,2,2,2,8,8,2,2,2,2];
%ntimes_list = [8,2,2,8,8,2,2,2,2];
%ntimes_list = [8,2,2,8,2,2,8,2,2];%,8,2,2];cleanup_ratio_list = []


