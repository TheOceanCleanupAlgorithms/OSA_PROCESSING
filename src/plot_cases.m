for i_tab = 1:n_combo
    % Computing the mass evolution in the different areas
    if ss_list(i_tab) == 1
        str_ss = 'opti';
    elseif ss_list(i_tab) == 2
        str_ss = 'hs';
    else
        str_ss = 'random';
    end

    if us_cleanup(i_tab) == 0.06
        tick1 = '-';
    else
        tick1 = '--';
    end

    name_case = [num2str(nsys_list(i_tab)) ' systems, ' num2str(pc_gpgp_stats(i_tab)) '% GPGP G1 agr and ' num2str(us_cleanup(i_tab)) '% upstream cleanup '  str_ss ' ss' ];

    figure(i_tab)
    if ss_list(i_tab) == 1
        col = 'r';
        ss_str = 'Optimal';
    elseif ss_list(i_tab) == 2
        col = 'g';
        ss_str = 'Hotspots';
    elseif ss_list(i_tab) == 3
        col = 'b';
        ss_str = 'Random';
    end
    tick1 = '-';
    plot(2027:2037,cleanup_ratio_glo{i_tab}.global_tab,['r' tick1],'DisplayName',['detectable for ' num2str(100*growth_rate2) '% agr micro']); hold on;
    plot(2027:2037,(cleanup{i_tab}.wd_macroH)./(bau{i_tab}.wd_macroH),['g' tick1],'DisplayName',['macro-mega for ' num2str(100*growth_rate2) '% agr micro']);
    plot(2027:2037,(cleanup{i_tab}.wd_microH)./(bau{i_tab}.wd_microH),['b' tick1],'DisplayName',['micro-meso for' num2str(100*growth_rate2) '% agr micro']');
    plot(2027:2037,(cleanup{i_tab}.wd_nanoH)./(bau{i_tab}.wd_nanoH),['k' tick1],'DisplayName',['undetected for ' num2str(100*growth_rate2) '% agr micro']);
    xlim([2027 2037]);
    xlabel('Year');
    ylabel('Cleanup ratio (in %)');
    title(name_case);
    %title([num2str(100*d) '% degradation rate']);
    grid on;
    legend;
end

for i_tab=1:n_combo
    scatter(-1000,-1000,100,'k','d','filled','DisplayName','all size classes');hold on;
    scatter(-1000,-1000,100,'k','o','DisplayName','Mega-macro-meso2');
    scatter(-1000,-1000,100,'k','s','DisplayName','Meso1');
    scatter(-1000,-1000,100,'k','+','DisplayName','Micro-undetectable');
end

for i_tab = 1:n_combo
    if pc_gpgp_stats(i_tab) == 0 || pc_gpgp_stats(i_tab) == 2
    else
        if ss_list(i_tab) == 1
            col = 'r';
            ss_str = 'Optimal';
        elseif ss_list(i_tab) == 2
            col = 'g';
            ss_str = 'Hotspots';
        elseif ss_list(i_tab) == 3
            col = 'b';
            ss_str = 'Random';
        end
        scatter(pc_gpgp_stats(i_tab),100*cleanup_ratio_glo{i_tab}.global_tab(end),100,col,'d','filled');hold on;
        scatter(pc_gpgp_stats(i_tab),100*cleanup_ratio_glo{i_tab}.macro_tab(end),100,col,'o');hold on;
        scatter(pc_gpgp_stats(i_tab),100*cleanup_ratio_glo{i_tab}.micro_tab(end),100,col,'s');hold on;
        scatter(pc_gpgp_stats(i_tab),100*cleanup_ratio_glo{i_tab}.nano_tab(end),100,col,'+');hold on;
        title(ss_str)
    end
    figure(1)
    if ss_list(i_tab) == 1
        str_ss = 'opti';
    elseif ss_list(i_tab) == 2
        str_ss = 'hs';
    else
        str_ss = 'random';
    end
    name_case = [str_ss];
    plot(movmean(100*cleanup_ratio_glo{i_tab}.global_tab,1),'DisplayName',name_case ); hold on;
end

for i = 1:n_combo
    xlabel('Macro net growth rate');
    ylabel('Percentage of 2037 bau level remaining in 2037');
    grid on;
    xlim([0 4]);
    ylim([0 100])
    legend('All sizes','Mega-macro-meso2','Meso1','Undetectable')
end
figure(1);
legend;
title(['Evolution of the mass ratio of all detectables for scenario ' str_scenario]);
grid on;
ylim([0 2])