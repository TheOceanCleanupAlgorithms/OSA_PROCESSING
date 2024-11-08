%% The Ocean Cleanup colormap
%close all
toc_white = [1, 1, 1];
toc_blue_light = [5,205,225]/255;
toc_blue_lighter = [2.5,102.5,112.5]/255;
toc_blue_dark = [0,44,68]/255;
toc_blue_mid = [0,62,95]/255;
toc_light_gray = [242, 245, 246]/255;
toc_gray = [91, 127, 146]/255;
%map = [1 1 1 ; toc_blue_dark];
%map = [toc_white ; toc_blue_dark];
%map2 =  [0.9 0.9 0.9; toc_blue_lighter ; toc_blue_light; toc_blue_mid; toc_blue_dark];
map0 =  [toc_light_gray; toc_gray; toc_blue_light; toc_blue_dark];% toc_blue_dark];
map0 =  [toc_blue_mid; toc_gray; toc_blue_light; toc_white;];% toc_blue_dark];
map2 = [];
for i = 1:length(map0)-1
    for j=1:10
        map2 = [map2;[(j-1)/10*map0(i+1,1)+(10-j)/10*map0(i,1),(j-1)/10*map0(i+1,2)+(10-j)/10*map0(i,2),(j-1)/10*map0(i+1,3)+(10-j)/10*map0(i,3)]];
    end
end
%map2 = map0;

% Reading Land mass
ncid = netcdf.open('HYCOM_landmass.nc','NOWRITE');
lon = netcdf.getVar(ncid,0);
%lon(lon>=180) = lon(lon>=180) - 360;
lat = netcdf.getVar(ncid,1);
land = netcdf.getVar(ncid,2);
netcdf.close(ncid)

% Loading HYCOM landmass
imagesc(lon-360,lat,1000*land');hold on;
%colormap(map)
grid on;
%axis([-160 -120 18 38])
axis([-160 -125 20 45])
axis xy;
l=ylabel('LATITUDE');
L=xlabel('LONGITUDE');
t.FontSize=16;
t.FontName='Proxima Nova A';
l.FontSize=16;
L.FontSize=16;
l.FontName='Proxima Nova A';

% Heatmap
dx = 0.08;
gpgp_boundaries = [20 45 -160 -125];
gpgp_boundaries_p = [20-dx/2 45+dx/2 -160-dx/2 -125+dx/2];
binEdgesX = linspace(gpgp_boundaries(3),gpgp_boundaries(4),(gpgp_boundaries(4)-gpgp_boundaries(3))/dx+1);
binEdgesY = linspace(gpgp_boundaries(1),gpgp_boundaries(2),(gpgp_boundaries(2)-gpgp_boundaries(1))/dx+1);
binEdgesX_p = linspace(gpgp_boundaries_p(3),gpgp_boundaries_p(4),(gpgp_boundaries_p(4)-gpgp_boundaries_p(3))/dx+1);
binEdgesY_p = linspace(gpgp_boundaries_p(1),gpgp_boundaries_p(2),(gpgp_boundaries_p(2)-gpgp_boundaries_p(1))/dx+1);
[YGrid, XGrid] = meshgrid(binEdgesY(1:end),binEdgesX(1:end));
[YGrid2, XGrid2] = meshgrid(20:0.5:45,-160:0.5:125);
load('heatmap_gaussian.mat');
counts = 30*counts;
%counts = count_tot;
counts = smoothedCounts;
counts(counts <= 1/(1000/2.26/80/30))=nan;
%pcolor(XGrid,YGrid,1000/2.26/80*counts); hold on;
pcolor(XGrid,YGrid,1000/2.26/80*counts/30); hold on;
shading flat
colormap(map2)
clim([1 100])
colorbar
%axis([-170 -110 10 50])
load('contours.mat');
plot(contourData(1).polygon(:,1),contourData(1).polygon(:,2),'w--','LineWidth',3); hold on;
grid on;
ax = gca;
ax.GridColor = [1, 1, 1];

%%
figure
hold on;
load("GPGP_trajectories.mat");
load("Extractions.mat");
datesnum_traject = featurevesselspos002geometryloadsproductsandboxM3iGojoined20212.datesnum_traject;
lon_traject = featurevesselspos002geometryloadsproductsandboxM3iGojoined20212.span_center_lon;
lat_traject = featurevesselspos002geometryloadsproductsandboxM3iGojoined20212.span_center_lat;
dates_start = extractionperformancecsvsortedprepared20212024.T_start_num(1:67);
dates_end = extractionperformancecsvsortedprepared20212024.T_end_num(1:67);
extracted_density = extractionperformancecsvsortedprepared20212024.Extracted_density(1:67);
sys_conf = extractionperformancecsvsortedprepared20212024.System_conf(1:67);

for i = 1:length(datesnum_traject)
    count_traject(i) = i;
    extracted_density_traject(i) = nan;
    system_config_traject(i) = {'nap'};
end

for i = 1:length(dates_start)
    mask = datesnum_traject >= dates_start(i) & datesnum_traject <= dates_end(i);
    extracted_density_traject(mask) = extracted_density(i);
    system_config_traject(mask) = sys_conf(i);
    lon_mask = lon_traject(mask);
    lat_mask = lat_traject(mask);
    lon_vect{i} = lon_mask;
    lat_vect{i} = lat_mask;
    lon_start(i) = lon_mask(1);
    lon_end(i) = lon_mask(end);
    lon_mean(i) = mean(lon_mask);
    lat_start(i) = lat_mask(1);
    lat_end(i) = lat_mask(end);
    lat_mean(i) = mean(lat_mask);
    if strcmp(char(sys_conf(i)),'S02-S02A')
        symb_vect(i) = 'o';
    elseif strcmp(char(sys_conf(i)),'S02B')
        symb_vect(i) = 's';
    elseif strcmp(char(sys_conf(i)),'S02C')
        symb_vect(i) = 'd';
    else
        symb_vect(i) = 'p';
    end 
end
for i = 1:length(lon_mean)
    plot(lon_vect{i},lat_vect{i},'k-')
end

for i = 1:length(lon_mean)
    scatter(lon_start(i),lat_start(i),100,extracted_density(i),"Filled",symb_vect(i))
    %scatter(lon_end(i),lat_end(i),40,extracted_density(i),"Filled",symb_vect(i),"MarkerEdgeColor",'k')
end
axis([-155 -130 24 37])
grid on;
colormap(map2)

plot(contourData(1).polygon(:,1),contourData(1).polygon(:,2),'k--','LineWidth',3); hold on;

l=ylabel('LATITUDE');
L=xlabel('LONGITUDE');
t.FontSize=16;
t.FontName='Proxima Nova A';
l.FontSize=16;
L.FontSize=16;
l.FontName='Proxima Nova A';
colorbar

saveas(gcf,"trajectories.svg",'svg')




