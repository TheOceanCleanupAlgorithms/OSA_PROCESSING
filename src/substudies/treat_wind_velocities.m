count = 0;
season_glo = [];
eff_glo = [];
for year = 2000:2009
    % 
    season = zeros(1460,1);
    count = count + 1;
    ncid1 = netcdf.open(['../data/wind/uwnd.sig995.' num2str(year) '.nc']);
    ncid2 = netcdf.open(['../data/wind/vwnd.sig995.' num2str(year) '.nc']);
    lon = 220;
    lat = 30;
    LON = netcdf.getVar(ncid1,1);
    LAT = netcdf.getVar(ncid1,0);
    index_lon = (lon - LON(1))/(LON(2) - LON(1)) + 1;
    index_lat = (lat - LAT(1))/(LAT(2) - LAT(1)) + 1;
    time = netcdf.getVar(ncid2,2);
    U = netcdf.getVar(ncid1,3);
    V = netcdf.getVar(ncid2,3);
    u = U(index_lon,index_lat,:);
    v = V(index_lon,index_lat,:);
    umod = sqrt(u.*u + v.*v);
    eff = 1.0034 - 0.0194.*umod/1.853*3.6;
    eff = eff(:);
    eff = eff(1:1460);
    index = (1:1460)';
    season(1:91*4) = 1;
    season(91*4+1:91*8) = 2;
    season(91*8+1:91*12) = 3;
    season(91*12+1:end) = 4;
    eff_glo = [eff_glo ; eff];
    season_glo = [season_glo ; season];

    % for i = 1: size()
    %
    %
    netcdf.close(ncid1)
    netcdf.close(ncid2)
end
boxplot(eff_glo,season_glo)
xlabel('Season number')
ylabel('Efficiency')
grid on;