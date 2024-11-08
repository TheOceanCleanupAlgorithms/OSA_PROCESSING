%% Computing the business as usual for the different growth rate scenarios
cod_igr=1;
compute_bau
if cod_fig == 1
    figure(1)
end

%% Looping along the cases
%close all
for grs = 1:3 % 3 growth scenarios
    % Selecting the scenario
    switch grs
        case(1)
            str_scenario = 'GLORYS';
        case(2)
            str_scenario = 'Lebreton_GPGP';
        case(3)
            str_scenario = 'Lebreton_HST';
    end

    if cod_ver == 7
        I_nanoH=zeros(2,n_combo);
        I_microH=zeros(2,n_combo);
        I_microdegradH=zeros(2,n_combo);
        I_macroH=zeros(2,n_combo);
    end

    for i_tab = 1:n_combo
        if i_tab <= n_combo/2
            i_igr = 2*(grs-1) + 1;
        else
            i_igr = 2*(grs-1) + 2;
        end
        if cod_igr == 1
            ratio_exp = newmass1_tab_glo{i_igr}(13)/newmass2_tab_glo{i_igr}(13);
            ratio_bo_fr = ratio_exp/(ratio_exp+1);
        end
        if cod_ver == 7
            clean_ratio_loc = clean_ratio_glo{i_tab};
            clean_ratio_cu = clean_ratio_loc(52:52:end);
            cleaning_ratio = cleaning_ratio_tab(i_tab);
            growth_rate1 = [pc_gpgp_stats(i_tab)*0.01,pc_gpgp_stats(i_tab)*0.01];
            growth_rate2 = 0.34;
            masses(1,:) = [100*ratio_bo_fr, 100*ratio_bo_fr*(1+growth_rate1(1))^25, 100*(1.-ratio_bo_fr), 100*(1.-ratio_bo_fr)*(1+growth_rate2)^25];
            surfaces(1,:) = [1, 1];
            masses(2,:) = [100*ratio_bo_fr, 100*ratio_bo_fr*(1+growth_rate1(2))^25, 100*(1.-ratio_bo_fr), 100*(1.-ratio_bo_fr)*(1+growth_rate2)^25];
            surfaces(2,:) = [1, 1];
            title_str = [ num2str(growth_rate2*100) "% increase of fragments"];
        elseif cod_ver == 1 % old vs new comparison (Lebreton max)
            masses(1,:) = [20.871, 25.09, 6.16, 13.79];
            surfaces(1,:) = [1600000, 1600000];
            masses(2,:) = [21.70, 25.76, 6.61, 10.53];
            surfaces(2,:) = [1668494.75, 1483031.25];
            title_str = "old vs new (Lebreton max)";
        elseif cod_ver == 2 % NEMO max vs Lebreton max
            masses(1,:) = [20.871, 25.09, 6.16, 13.79];
            surfaces(1,:) = [1600000, 1600000];
            masses(2,:) = [21.70, 25.76, 6.61, 10.53];
            surfaces(2,:) = [1668494.75, 1483031.25];
            title_str = "Measured max vs NEMO max";
        elseif cod_ver == 3 % NEMO min vs NEMO max
            masses(1,:) = [11.18, 12.26, 6.61, 10.53];
            surfaces(1,:) = [1668494.75, 1483031.25];
            masses(2,:) = [21.70, 25.76, 6.61, 10.53];
            surfaces(2,:) = [1668494.75, 1483031.25];
            title_str = "NEMO min vs NEMO max";
        elseif cod_ver == 4 % Lebreton min vs Lebreton max
            masses(1,:) = [7.95, 19.28, 6.16, 13.79];
            surfaces(1,:) = [1600000, 1600000];
            masses(2,:) = [20.871, 25.09, 6.16, 13.79];
            surfaces(2,:) = [1600000, 1600000];
            title_str = "Measured min vs measured max";
        elseif cod_ver == 5 % NEMO vs Kaandorp
            masses(1,:) = [34.252, 41.178, 4.223, 5.678];
            surfaces(1,:) = [2600000, 2600000];
            masses(2,:) = [21.70, 25.76, 6.61, 10.53];
            surfaces(2,:) = [1668494.75, 1483031.25];
            title_str = "Kaandorp vs NEMO";
        elseif cod_ver == 6 % Lebreton vs Kaandorp
            masses(1,:) = [34.252, 41.178, 4.223, 5.678];
            surfaces(1,:) = [2600000, 2600000];
            masses(2,:) = [20.871, 25.09, 6.16, 13.79];
            surfaces(2,:) = [1600000, 1600000];
            title_str = "Kaandorp vs measured";
        end

        % Initializing inflow vectors
        if cod_ver == 1
            cod_num = 2;
        else
            cod_num = size(masses,1);
        end
        if cod_ver <= 6
            I_nanoH=zeros(cod_num,length(steps));
            I_microH=zeros(cod_num,length(steps));
            I_microdegradH=zeros(cod_num,length(steps));
            I_macroH=zeros(cod_num,length(steps));
        end
        % Loop through the cases
        cod_case_k = 0;
        for cod_case = 1:cod_num
            k=0;

            % Pick which version (method / masses)
            if cod_ver == 1
                MBO_2015 = surfaces(1,1)*masses(1,1); MBO_2022 = surfaces(1,2)*masses(1,2); MFR_2015 = surfaces(1,1)*masses(1,3); MFR_2022 = surfaces(1,2)*masses(1,4);
            else
                MBO_2015 = surfaces(cod_case,1)*masses(cod_case,1); MBO_2022 = surfaces(cod_case,2)*masses(cod_case,2); MFR_2015 = surfaces(cod_case,1)*masses(cod_case,3); MFR_2022 = surfaces(cod_case,2)*masses(cod_case,4);
            end

            % Loop for the degradation rates
            d1 = degradation_adr1_tab(i_igr);
            d2 = degradation_adr2_tab(i_igr);
            k=k+1;
            if cod_ver == 7
                i_output = i_tab;
            else
                i_output = k;
            end
            cod_case_k = cod_case_k + 1;
            wd_nanoH=zeros(length(start_year:end_year),1);
            wd_microH=zeros(length(start_year:end_year),1);
            wd_microdegradH=zeros(length(start_year:end_year),1);
            wd_macroH=zeros(length(start_year:end_year),1);
            wd_macroH_added=zeros(length(start_year:end_year),1);
            wd_microH_added=zeros(length(start_year:end_year),1);
            wd_nanoH(1)= 0;
            if cod_case == 1
                wd_microH(1)= MFR_2015;
                wd_microdegradH(1)= 0;
                wd_macroH(1)= MBO_2015;
                wd_macroH_added(1) = 0;
                wd_microH_added(1) = 0;
            else
                wd_macroH(1)= bau{i_output}.wd_macroH(1);
                wd_microdegradH(1)= 0;
                wd_microH(1)= bau{i_output}.wd_microH(1);
                wd_macroH_added(1) = 0;
                wd_microH_added(1) = 0;
                wd_nanoH(1) = 0;
            end
            for y=2:nsteps
                if (cod_cleanup == 0) || (cod_cleanup == 1 && cod_case == 1)
                    wd_macroH(y)= (1 + growth_rate1(cod_case))*wd_macroH(y-1);
                    wd_microH(y)= (1 + growth_rate2)*wd_microH(y-1);
                    wd_macroH_added(y) = wd_macroH_added(y-1) + wd_macroH(y) - wd_macroH(y-1) + d1*wd_macroH(y-1);
                    wd_microH_added(y) = wd_microH_added(y-1) + wd_microH(y) - wd_microH(y-1) - d1*wd_macroH(y-1) + d2*wd_microH(y-1);
                    wd_nanoH(y)= wd_nanoH(y-1) + d2*wd_microH(y-1);
                    wd_microdegradH(y)=wd_microdegradH(y-1) + d1*wd_macroH(y-1);
                elseif y >= (nsteps - us_cleanup_delay)
                    gradmac = gradient(bau{i_output}.wd_macroH_added);
                    wd_macroH(y)= clean_ratio_cu(y-1)*bau{i_output}.wd_macroH(y);%-cleaning_ratio*gradmac(y);
                    gradmic = bau{i_output}.wd_microH_added;
                    wd_microH(y) = wd_microH(y-1) + cleaning_ratio*gradmic(y) + d1*wd_macroH(y-1) - d2*wd_microH(y-1);
                    wd_macroH_added(y) = wd_macroH_added(y-1) + wd_macroH(y) - wd_macroH(y-1) + d1*wd_macroH(y-1);
                    wd_microH_added(y) = wd_microH_added(y-1) + wd_microH(y) - wd_microH(y-1) - d1*wd_macroH(y-1) + d2*wd_microH(y-1);
                    wd_nanoH(y)= wd_nanoH(y-1) + d2*wd_microH(y-1);
                    wd_microdegradH(y)=wd_microdegradH(y-1) + d1*wd_macroH(y-1);
                    wd_microH_added(y) = wd_microH_added(y-1) + cleaning_ratio*(wd_microH_added(y-1) - wd_microH_added(y-2));

                else
                    wd_macroH(y)= clean_ratio_cu(y-1)*bau{i_output}.wd_macroH(y);
                    gradmic = bau{i_output}.wd_microH_added;
                    wd_microH(y) = wd_microH(y-1) + gradmic(y) + d1*wd_macroH(y-1) - d2*wd_microH(y-1);
                    wd_macroH_added(y) = wd_macroH_added(y-1) + wd_macroH(y) - wd_macroH(y-1) + d1*wd_macroH(y-1);
                    wd_microH_added(y) = wd_microH_added(y-1) + wd_microH(y) - wd_microH(y-1) - d1*wd_macroH(y-1) + d2*wd_microH(y-1);
                    wd_nanoH(y)= wd_nanoH(y-1) + d2*wd_microH(y-1);
                    wd_microdegradH(y)=wd_microdegradH(y-1) + d1*wd_macroH(y-1);
                end
            end
            if cod_ver == 1 && cod_case == 1
                wd_macroH_added(nsteps) = 0;
            elseif cod_ver <= 6
                wd_macroH_added = (1-wd_macroH_added/nsteps);
            end

            A = 1; % GPGP area
            I_macroH(cod_case,i_output)= A * wd_macroH_added(nsteps);
            I_microH(cod_case,i_output)= A * wd_microH_added(nsteps);
            I_nanoH(cod_case,i_output) = A * wd_nanoH(nsteps);
            I_microdegradH(cod_case,i_output)= A * wd_microdegradH(nsteps);
            macroH_glo{cod_case_k} = A * wd_macroH(:);
            microH_glo{cod_case_k} = A * wd_microH(:);
            I_macroH_glo{cod_case_k}= A * (wd_macroH_added(:));
            I_microH_glo{cod_case_k}= A * (wd_microH_added(:));
            I_nanoH_glo{cod_case_k} = A * (wd_nanoH(:));
            I_microdegradH_glo{cod_case_k}= A * (wd_microdegradH(:));

            if (cod_case == 1 && cod_cleanup == 1) || cod_cleanup == 0
                bau{i_output} = table(wd_macroH_added,wd_macroH,wd_microdegradH,wd_microH_added,wd_nanoH,wd_microH);
                if cod_igr == 1
                    bau{i_output}.wd_macroH = newmass1_tab_glo{i_igr}(13:23);
                    tabint = newtinflow_mass1_tab_glo{i_igr}(13:23);
                    bau{i_output}.wd_macroH_added = tabint;
                    bau{i_output}.wd_microH = newmass2_tab_glo{i_igr}(13:23);
                    tabint = newtinflow_mass2_tab_glo{i_igr}(13:23);
                    bau{i_output}.wd_microH_added = tabint;
                    bau{i_output}.wd_nanoH = newmass3_tab_glo{i_igr}(13:23);
                end
            elseif cod_case == 2 && cod_cleanup == 1
                cleanup{i_output} = table(wd_macroH_added,wd_macroH,wd_microdegradH,wd_microH_added,wd_nanoH,wd_microH);
                micro_tab  = (cleanup{i_output}.wd_microH./bau{i_output}.wd_microH);
                macro_tab  = (cleanup{i_output}.wd_macroH./bau{i_output}.wd_macroH);
                nano_tab   = (cleanup{i_output}.wd_nanoH./bau{i_output}.wd_nanoH);
                global_tab = (cleanup{i_output}.wd_macroH+cleanup{i_output}.wd_microH)./(bau{i_output}.wd_macroH+bau{i_output}.wd_microH);
                cleanup_ratio_glo{i_output} = table(micro_tab,macro_tab,nano_tab,global_tab);
                micro_tab  = cleanup{i_output}.wd_microH;
                macro_tab  = cleanup{i_output}.wd_macroH;
                nano_tab   = (cleanup{i_output}.wd_nanoH);
                global_tab = (cleanup{i_output}.wd_macroH+cleanup{i_output}.wd_microH);
                wd_cleanup_glo{i_output} = table(micro_tab,macro_tab,nano_tab,global_tab);
                micro_tab  = bau{i_output}.wd_microH;
                macro_tab  = bau{i_output}.wd_macroH;
                nano_tab   = bau{i_output}.wd_nanoH;
                global_tab = bau{i_output}.wd_macroH+bau{i_output}.wd_microH;
                wd_bau_glo{i_output} = table(micro_tab,macro_tab,nano_tab,global_tab);
            end
        end
    end
    if cod_fig == 1
        plot_cases
    end
    res_final{grs} = cleanup_ratio_glo;
end

%% Plot figures
case_tab = [10,15,20];
case_cu = [0.32,0.56];
for c = case_tab
    figure
    hold on;
    for iss = [1,4,5]
        mask = nsys_list == c & ss_list == iss;
        tab1 = res_final{1}(mask);
        pc1 = pc_gpgp_file(mask);
        tab2 = res_final{3}(mask);
        switch iss
            case(1)
                col = 'b';
            case(2)
                col = 'b';
            case(3)
                col = 'g';
            case(4)
                col = 'g';
            case(5)
                col = 'r';
        end
        for pc_case = pc1
            switch pc_case
                case (1)
                    tick = '-';
                case (3)
                    tick = '--';
            end
        end
        fill([(2027:2037), fliplr((2027:2037))], [(tab2{end-1}.global_tab)', fliplr((tab1{2}.global_tab)')], col, 'FaceAlpha', 0.2);grid on;
        %fill([(2027:2037), fliplr((2027:2037))], [(tab2{end-1}.macro_tab)', fliplr((tab1{2}.macro_tab)')], col, 'FaceAlpha', 0.2);grid on;
        hold on;
        title(['GPGP area (100%) macro: ' num2str(c) ' systems'])
        ylim([0 1])
        plot([2027 2037],[0.2 0.2],'r--')
        plot([2032 2032.01],[0 1e6],'b--')
    end
end

%%
figure
for i = 1:36
    tab1 = res_final{1}(i);
    tab2 = res_final{2}(i);
    tab3 = res_final{3}(i);
    scatter(tab1{1}.nano_tab,tab3{1}.nano_tab,10,'b','Filled'); hold on;
    %scatter(2027:2037,tab2{1}.global_tab./tab1{1}.global_tab,'b','Filled');hold on;
end
%plot([2027 2037],[1 1],'k--');
%plot([0 1],[0 1],'k--');


