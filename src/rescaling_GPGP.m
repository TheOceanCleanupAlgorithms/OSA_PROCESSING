% Code to rescale the mass balance

% Creation of LON / LAT grids
[LAT_AVG1,LON_AVG1] = meshgrid(bbox1(3):dx:bbox1(4),bbox1(1):0.08:bbox1(2));
[LAT_AVG2,LON_AVG2] = meshgrid(bbox2(3):dx:bbox2(4),bbox2(1):0.08:bbox2(2));

cod_cleanup = 1;
nsteps_rescale = 7;
% Loop through the cases (Large grid vs Small grid)
for i_combo = 1:n_combo
    for icase = 1 % do we look at grid 1 and / or grid 2

        % Initialize grids and case names, bounding boxes etc...
        if icase == 1 % case Large grid
            LAT_AVG=LAT_AVG1;
            LON_AVG=LON_AVG1;
            %name_case = 'Large grid';
            bbox = bbox1;
        elseif icase == 2 % case small grid
            LAT_AVG=LAT_AVG2;
            LON_AVG=LON_AVG2;
            %name_case = 'Small grid';
            bbox = bbox2;
        end

        % Computing the mass evolution in the different areas
        if ss_list(i_combo) == 5
            str_ss = 'opti';
        elseif ss_list(i_combo) == 4
            str_ss = 'hs';
        else
            str_ss = ['index' num2str(ss_list(i_combo))];
        end

        % Generating the file names and directories
        name_case = [str_ss ' ' num2str(nsys_list(i_combo)) ' sys ' num2str(pc_gpgp_stats(i_combo)) '% gwth ' num2str(100*cleanup_ratio_list(i_combo)) '% cu '];
        disp([ 'Number: ' num2str(i_combo) ' ' name_case])
        dir_infix = ['/' num2str(pc_gpgp_stats(i_combo)) 'pc/'];

        % Initialize BAU stats file
        count = 0;
        for y = start_year:end_year
            for i = 1:nsteps_rescale:365
                count = count + 1;
                if method == 0 % method based on the particles
                    stats_bau{count} = zeros(size(LON_AVG,1),size(LON_AVG,2));
                else % method base on the gridded particle counts
                    if i_combo == 1 || i_combo == 31
                        stats_bau{count} = zeros(size(LON_AVG,1),size(LON_AVG,2));
                        if i == 1
                            load(['../data/stats/Res_new/' dir_infix 'statsMBY' num2str(y)  '.mat'],'statsMB');
                        end
                        mask = statsMB{i} > 0;
                        stats_bau_int = statsMB{i};
                        rand1 = rand(size(statsMB{i}));
                        stats_bau_int(mask) = stats_bau_int(mask) - 1 + 2.*rand1(mask); % adding a random value to have more continuous thresholds
                        if icase == 2
                            for irow = (bbox2(1)-bbox1(1))/dx+1:(bbox2(2)-bbox1(1))/dx+1
                                irow_new = irow;
                                stats_bau{count}(irow-(bbox2(1)-bbox1(1))/dx,:) = stats_bau_int(irow_new,(bbox2(3)-bbox1(3))/dx+1:(bbox2(4)-bbox1(3))/dx+1);
                            end
                        else
                            stats_bau{count}=stats_bau_int;
                        end
                        date_treated_size(count) = datetime(y,01,i);
                        corresponding_num(count) = datenum(y,01,i) - datenum(start_year,01,1) + 1;
                    else
                        date_treated_size(count) = datetime(y,01,i);
                        corresponding_num(count) = datenum(y,01,i) - datenum(start_year,01,1) + 1;
                        %disp(date_treated_size(count))
                    end
                end
            end
        end

        % Filling the BAU stats file for the
        if method == 0
            count = 0;
            for y  = start_year:end_year
                disp(['Year treated: ' num2str(y)]);
                for i = 1:nsteps_rescale:365
                    count = count + 1;
                    if i == 1
                        load(['../data/stats' dir_infix 'statsY' num2str(y)  '.mat'],'LonOrgFirst','LatOrgFirst');
                    end
                    lon = LonOrgFirst(i,:);
                    lon = lon(:);
                    lat = LatOrgFirst(i,:);
                    lat = lat(:);
                    mask = lon >= bbox(1) & lon <= bbox(2) & lat >= bbox(3) & lat <= bbox(4);
                    ixLon = floor((lon(mask) - LON_AVG(1,1))/(LON_AVG(2,1)-LON_AVG(1,1)))+1;
                    iyLat = floor((lat(mask) - LAT_AVG(1,1))/(LAT_AVG(1,2)-LAT_AVG(1,1)))+1;
                    for ipart = 1:size(ixLon,1)
                        stats_bau{count}(ixLon(ipart),iyLat(ipart))=stats_bau{count}(ixLon(ipart),iyLat(ipart))+1+(rand-0.5)*2;
                    end
                    date_treated_size(count) = datetime(y,01,i);
                    disp(date_treated_size(count))
                end
            end
        end
        LON_vect = LON_AVG(:);
        LAT_vect = LAT_AVG(:);

        % Selecting the GPGP area
        if i_combo == 1 || i_combo == 31
            for i = 1:size(stats_bau,2)
                stats_bau_vect = stats_bau{i}(:);
                val0 = 0;
                val = mean(stats_bau_vect);
                val1 = max(stats_bau_vect);
                ratio = 1;
                count = 0;
                while count < 20 && abs(ratio - threshold)>0.01
                    count = count + 1;
                    ratio = sum(stats_bau_vect(stats_bau_vect>=val)) / sum(stats_bau_vect);
                    if ratio > threshold
                        val0 = val;
                        val = (val + val1)/2;
                    else
                        val1 = val;
                        val = (val+val0)/2;
                    end
                end
                mask_bau_tab{i} = stats_bau{i}>=val;
                mask_bau{i} = stats_bau_vect>=val;
                surf_bau{i} = (stats_bau_vect>=val).*(cos(LAT_vect*pi/180).*(0.08*1.853*60)^2);
                size_bau(i) = sum(surf_bau{i});
            end
        end
        if cod_fig == 1
            figure(1)
            plot(date_treated_size, movmean(size_bau,28/nsteps_rescale)); hold on;
            drawnow;
            legend('Large grid','Small grid')
            ylim([0,2.5e6]);
            ylabel('GPGP size in km2');
            xlabel('Date');
        end

        % Opening the final stats file
        %load(['../data/stats/Res_new/' str_ss '_' num2str(nsys_list(i_combo)) 'sys_' num2str(pc_gpgp_file(i_combo)) 'pc/statsY' num2str(end_year)  '.mat'],'stats');
        if cod_cleanup == 1
            load(['/Volumes/BSR_SSD_2TB/THE OCEAN CLEANUP/OSA/stats/' str_ss '_' num2str(nsys_list(i_combo)) 'sys_' num2str(100*cleanup_ratio_list(i_combo)) '_' num2str(pc_gpgp_file(i_combo)) 'pc/statsY' num2str(end_year)  '.mat'],'stats');
        end
        dir_in = ['/' str_ss '_' num2str(nsys_list(i_combo)) '/'];
        if cod_bar == 1
            load(['../data/barriers' dir_in 'barriers_14Y' num2str(end_year)  '.mat'],'p');
            load(['../data/barriers' dir_in 'EncDens14-' num2str(end_year)  '.mat']);
            ipLon = floor((p.LON - LON_AVG1(1,1))/ dx) + 1;
            ipLat = floor((p.LAT - LAT_AVG1(1,1))/ dx) + 1;
            iarea = (0.08*0.08*1.853*60*1.853*60)*(cos(p.LAT*pi/180));
        end
        count=0;
        lon_vect = LON_AVG1(:);
        lat_vect = LAT_AVG1(:);
        num_tot_days = 0; % number of days of Jan 1st of the year since the first year

        % Looping through the years
        for y=start_year:end_year
            if y == 2008 || y == 2012 || y == 2016
                num_days = bisex_days;
            else
                num_days = 365;
            end
            for i=1:nsteps_rescale:365
                count = count+1;
                ibar = corresponding_num(count)*ntimes_list(i_combo) - 1;
                %disp(date_treated_size(count))
                if cod_cleanup == 1
                    stats_orig = stats{num_tot_days+i}(:);
                    stats_vect = stats_orig(lon_vect >= LON_AVG(1,1) & lon_vect <= LON_AVG(end,1) & lat_vect >= LAT_AVG(1,1) & lat_vect <= LAT_AVG(1,end));
                    rand2 = rand(size(stats_vect));
                    mask = stats_vect > 0;
                    stats_vect(mask) = stats_vect(mask) - 1 + 2.*rand2(mask);
                    %pcolor(LON_AVG1,LAT_AVG1,log10(stats{num_tot_days+i}))
                    %axis(bbox)
                    %shading flat
                    %colorbar
                    %   clim([-1 1])
                    %title(num2str(i))
                    %drawnow
                    %mask1 = lon_vect >= bbox(1) & lon_vect <= bbox(2) & lat_vect >= bbox(3) & lat_vect <= bbox(4);
                end
                stats_vect2 = stats_bau{count}(:);
                total_mass2(count) = sum(stats_vect2);
                mask1 = mask_bau{count};
                stats_m2 = stats_vect2(mask1);
                total_mass_m2(count) = sum(stats_m2);
                if cod_cleanup == 1
                    stats_m1 = stats_vect(mask1);
                    total_mass(count) = sum(stats_vect);
                    mean_mass(count) = sum(stats_m1)/sum(mask1);
                    total_mass_m1(count) = sum(stats_m1);
                end
                date_treated(count) = datetime(y,01,i);
                if cod_bar == 1
                    for j=1:nsys_list(i_combo)
                        encountered_density_bau(count,j) = stats_bau{count}(ipLon(ibar,j),ipLat(ibar,j))/iarea(ibar,j);
                        encountered_density_track(count,j) = EncounteredDensityTrack(ibar,j)/iarea(ibar,j);
                        encountered_density(count,j) = EncounteredWeightedDensityTrack(ibar,j,1,1)/iarea(ibar,j);
                    end
                    size(encountered_density_bau)
                end
            end
            num_tot_days = num_tot_days + num_days;
        end

        % Computing the amount cleaned over time
        if cod_cleanup == 1
            clean_ratio = (total_mass)./(total_mass2);
            clean_ratio2 = (total_mass_m1)./(total_mass_m2);
            %diff = (total_mass - total_mass_m1)./(total_mass(1));
            %clean_ratio3 = diff/diff(1);
            if cod_fig == 1

                figure(2)
                if ss_list(i_combo)==1
                    color_ss = 'b';
                elseif ss_list(i_combo)==2
                    color_ss = 'c';
                elseif ss_list(i_combo)==3
                    color_ss = 'g';
                elseif ss_list(i_combo)==4
                    color_ss = 'r';
                else
                    color_ss = 'm';
                end
                % if us_cleanup(i_combo) == 0
                %     tick_cu = '';
                % elseif us_cleanup(i_combo) == 50
                %     tick_cu = '--';
                % else
                %     tick_cu = ':';
                % end
                if nsys_list(i_combo) == 10
                    tick_cu = '';
                elseif nsys_list(i_combo) == 15
                    tick_cu = '--';
                else
                    tick_cu = ':';
                end

                symb_plot = [color_ss tick_cu];

                plot(date_treated,movmean(clean_ratio,28/nsteps_rescale),symb_plot,'DisplayName',name_case ); hold on;
                %plot(date_treated,movmean(clean_ratio2,28/nsteps_rescale),'DisplayName',['GPGP mass ratio: ' name_case] ); hold on;
                %plot(date_treated,movmean(clean_ratio,28/nsteps_rescale),'DisplayName',['Total mass ratio: ' name_case]); hold on;
                title('Mass evolution for all cases with 1% input')
                legend;
                grid on;
                ylim([0 1])
            end
        end
        %if cod_bar == 1
        %    figure(3)
        %    plot(date_treated,movmean(mean(encountered_density,2),28)/movmean(mean_mass(:),28));hold on;
        %plot(date_treated,movmean(mean(encountered_density1,2),28)/movmean(mean_mass(:),28));hold on;
        %end
        if cod_cleanup == 1
            clean_ratio_glo{i_combo} = movmean(clean_ratio,28/nsteps_rescale); %clean_ratio2;
            clean_ratio2_glo{i_combo} = movmean(clean_ratio2,28/nsteps_rescale);
            total_mass_glo{i_combo} = total_mass;
        end
        if cod_bar == 1
            % figure
            encountered_density_bau_glo{i_combo} = encountered_density_bau;
            % enc = encountered_density_bau(1:end,:);
            % enc = enc(:);
            % boxplot(enc)
            encountered_density_track_glo{i_combo} = encountered_density_track;
            % enc = encountered_density_track(1:end,:);
            % enc = enc(:);
            % boxplot(enc)
            encountered_density_glo{i_combo} = encountered_density;
            % enc = encountered_density(1:end,:);
            % enc = enc(:);
            %boxplot(enc)
            clear encountered_density_bau
            clear encountered_density_track
            clear encountered_density
            if cod_cleanup == 1
                total_mass_glo{i_combo} = total_mass;
            end
            total_mass_bau{i_combo} = total_mass2;
        end
        date_treated_glo{i_combo} = date_treated;
        name_treated{i_combo} = name_case;
        %plot(date_treated,movmean(mean_mass(:),28));
    end
    
    % Fo
end




