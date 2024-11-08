%%

%%
date_treated_size = date_treated_glo{1};
figure
for i_combo = 1:n_combo
    mass_delta{i_combo} = gradient(total_mass_glo{i_combo});
    mass_delta_bau{i_combo} = gradient(total_mass_bau_glo{i_combo});
    removed_density{i_combo} = (-mass_delta{i_combo}+mass_delta_bau{i_combo})/(nsteps_rescale*3600/1000*24*cleanup_ratio_list(i_combo)*1.800*0.75*nsys_list(i_combo));
    average_density_glo_pro{i_combo} = 100000000*average_mass_glo{i_combo}./iarea./total_mass_bau_glo{i_combo};
end
for i_combo = 1:n_combo
    if ss_list(i_combo)==1
        c1 = 'b';
    elseif ss_list(i_combo)==4
        c1 = 'g';
    else
        c1 = 'r';
    end
    if mod(i_combo,3) == 1
        sy = 'o';
        sy = '--';
    elseif mod(i_combo,3) == 2
        sy = 's';
        sy = '-';
    else
        sy = 'd';
        sy = ':';
    end
    %scatter(total_mass_bau{i_combo}(1:53),total_mass_glo{i_combo}(1:53),10,c1,'Filled',sy); hold on;
    plot(date_treated_size(1:end),movmean(removed_density{i_combo}(1:end)./total_mass_glo{i_combo},52),c1); hold on;
end
%%
%close all
%%
load('../../data/res_calibration.mat')
raw_meas = (GPGPdata202120242S2.Measured_extracted/1000)./(GPGPdata202120242S2.Mass*1000/1600000);
raw_mod  = (GPGPdata202120242S2.Modelled_extracted/1000)./(GPGPdata202120242S2.Mass*1000/1600000);
wind_meas  = (GPGPdata202120242S3.Measured_extracted/1000./GPGPdata202120242S3.Ret_eff)./(GPGPdata202120242S3.Mass*1000/1600000);
wind_mod = (GPGPdata202120242S3.Modelled_extracted/1000./GPGPdata202120242S3.Ret_eff)./(GPGPdata202120242S3.Mass*1000/1600000);
log_meas  = (GPGPdata202120242S4.Measured_extracted/1000./GPGPdata202120242S4.Ret_eff)./(GPGPdata202120242S4.Mass*1000/1600000);
log_mod  = (GPGPdata202120242S4.Modelled_extracted/1000./GPGPdata202120242S4.Ret_eff)./(GPGPdata202120242S4.Mass*1000/1600000);

figure
names = [];
values = [];
encountered_density_glo2 = encountered_density_glo;

for i_combo = 1:n_combo
    for j = 1:nsys_list(i_combo)
        encountered_density_glo2{i_combo}(:,j) = 100000000*encountered_density_glo2{i_combo}(:,j)./(total_mass_bau_glo{i_combo}')./average_density_glo_pro{i_combo}';
    end
end
for i_combo = 1:n_combo
    if cleanup_ratio_list(i_combo) == 0.32 && pc_gpgp_stats(i_combo) == 1
        for split = 1
            data_mat = encountered_density_glo2{i_combo}(((split-1)/5*end + 1: (split)/5*end),:);
            data = data_mat(:);
            %data = (removed_density{i_combo}((split-1)/5*end + 1: (split)/5*end)*100000000./total_mass_glo{i_combo}((split-1)/5*end + 1: (split)/5*end))'./(75000000/1600000);
            values = [values ; data];
            name_cell = char(name_treated(i_combo));
            pref = name_cell(1:2);
            pref = [pref  ' '  num2str(2009+(split-1)*2)  '-'  num2str(2009+(split-1)*2+1)];
            names = [names; (repmat({pref}, 1, length(data)))'];
        end
    end
end
values = [values ; raw_meas; raw_mod; wind_meas; wind_mod; log_meas; log_mod];
names = [names; repmat({'raw extracted'},1,length(raw_meas))'; repmat({'raw model'},1,length(raw_meas))'; repmat({'wind corr encountered'},1,length(raw_meas))'; repmat({'wind corr model'},1,length(raw_meas))'; repmat({'log corr encountered'},1,length(raw_meas))'; repmat({'log corr model'},1,length(raw_meas))'];
boxplot(values', names','Symbol', '');

% Add title and axis labels if needed
%title('Boxplot of Data for name1, name2, and name3');
%xlabel('Categories');
ylabel('Values');
grid on;
ylim([0 4])
%ylim([0 300])

%% Plot system trajectories
load('../../data/res_calibration.mat')

data_bar_i1 = open("../../data/barriers/index1_10/barriers_14Y2009.mat");
data_bar_hs = open("../../data/barriers/hs_10/barriers_14Y2009.mat");
data_bar_op = open("../../data/barriers/opti_10/barriers_14Y2009.mat");
stats = open("../../data/stats/Res_new/1pc/statsMBY2009.mat");
stats = open("../statsY2018.mat");

%%
figure
pcolor(stats.LON_AVG-360,stats.LAT_AVG,1000/80*stats.stats{end});hold on;
shading flat;
caxis([0 10]);
%axis([-150 -145 32 35])
colormap bone;
plot(data_bar_i1.p.LON(end/2:end,2)-360,data_bar_i1.p.LAT(end/2:end,2),'LineWidth',3); hold on;
plot(data_bar_hs.p.LON(end/2:end,2)-360,data_bar_hs.p.LAT(end/2:end,2),'LineWidth',3); hold on;
plot(data_bar_op.p.LON(end/2:end,2)-360,data_bar_op.p.LAT(end/2:end,2),'LineWidth',3); hold on;
gradLON_i1 = gradient(data_bar_i1.p.LON(1:365*2,2));
gradLAT_i1 = gradient(data_bar_i1.p.LAT(1:365*2,2));
gradLON_hs = gradient(data_bar_hs.p.LON(1:365*2,2));
% %%
%%
gradLAT_hs = gradient(data_bar_hs.p.LAT(1:365*2,2));
gradLON_op = gradient(data_bar_op.p.LON(1:365*8,2));
gradLAT_op = gradient(data_bar_op.p.LAT(1:365*8,2));
dist_i1 = sum(sqrt((gradLON_i1).^2+(gradLAT_i1).^2));
dist_hs = sum(sqrt((gradLON_hs).^2+(gradLAT_hs).^2));
dist_op = sum(sqrt((gradLON_op).^2+(gradLAT_op).^2));
colormap(map2)
axis([-146 -141 32 38])

l=ylabel('LATITUDE');
L=xlabel('LONGITUDE');
t.FontSize=16;
t.FontName='Proxima Nova A';
l.FontSize=16;
L.FontSize=16;
l.FontName='Proxima Nova A';
title('Encountered density track')
grid on;
saveas(gcf,'compar_traject.svg','svg')