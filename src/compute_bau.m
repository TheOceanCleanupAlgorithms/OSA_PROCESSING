% Starting masses (in the following order NEMO mass evolution / Lebreton
% all / Lebreton HST
ratio_tab=[21.5,21.5,29.7,29.7,102.1,102.1];
starting_mass_macro=[73.067,73.067,73.067,73.067,73.067,73.067];
starting_mass_meso=[3.397,3.397,2.4602,2.4602,0.7156,0.7156];
inflow_agr_fact=[1,1,1,1,1,1];
degradation_adr1_tab = [0.0016,0.0046,0.0014,0.0046,0.0014,0.0046];
degradation_adr2_tab = [0.029,0.086,0.029,0.086,0.029,0.086];
inflow_agr1_tab = [0.04,0.04,0.04,0.04,0.04,0.04];
nagr1_tab = [0.01,0.03,0.01,0.03,0.01,0.03];
nagr2_tab = [0.091,0.091,0.136,0.136,0.340,0.340];
%%
for itab = 1:6
    ratio = ratio_tab(itab);
    mass1 = ratio/(ratio+1);
    mass2 = 1/(ratio+1);
    % Degradation_rates
    degradation_adr1 = degradation_adr1_tab(itab);
    degradation_adr2 = degradation_adr2_tab(itab);
    frac_agr = inflow_agr_fact(itab);
    inflow_agr1 = inflow_agr1_tab(itab);
    inflow_agr2 =frac_agr*inflow_agr1;
    nagr1 = nagr1_tab(itab);
    nagr2 = nagr2_tab(itab);

    % Mass balance over the years

    % Initializing
    mass1_tab = zeros(26,1);
    mass2_tab = zeros(26,1);
    mass3_tab = zeros(26,1);
    tinflow_mass1_tab = nan(26,1);
    tinflow_mass2_tab = nan(26,1);
    newtinflow_mass1_tab = nan(26,1);
    newtinflow_mass2_tab = nan(26,1);
    mass1_tab(1) = mass1;
    mass2_tab(1) = mass2;
    mass3_tab(1) = 0;
    newmass1_tab = mass1_tab;
    newmass2_tab = mass2_tab;
    newmass3_tab = mass3_tab;

    % Loop through the years
    for i = 2:8
        mass1_tab(i) = mass1_tab(i-1)*(1+nagr1);
        mass2_tab(i) = mass2_tab(i-1)*(1+nagr2);
        tinflow_mass1_tab(i) = (nagr1+degradation_adr1)*mass1_tab(i-1);
        tinflow_mass2_tab(i) = (nagr2+degradation_adr2)*mass2_tab(i-1) - degradation_adr1*mass1_tab(i-1);
    end

    inflow_mass1_0 = sum(tinflow_mass1_tab(~isnan(tinflow_mass1_tab)))/(1-(1+inflow_agr1)^7)*(-inflow_agr1);
    inflow_mass2_0 = sum(tinflow_mass2_tab(~isnan(tinflow_mass2_tab)))/(1-(1+inflow_agr2)^7)*(-inflow_agr2);

    for i = 2:26
        newtinflow_mass1_tab(i) = inflow_mass1_0*(1+inflow_agr1)^(i-2);
        newtinflow_mass2_tab(i) = inflow_mass2_0*(1+inflow_agr2)^(i-2);
        newmass1_tab(i) = newmass1_tab(i-1)*(1-degradation_adr1)+newtinflow_mass1_tab(i);
        newmass2_tab(i) = newmass2_tab(i-1)*(1-degradation_adr2)+newtinflow_mass2_tab(i)+degradation_adr1*newmass1_tab(i-1);
        newmass3_tab(i) = newmass3_tab(i-1) + degradation_adr2*newmass2_tab(i-1);
    end

    for i = 9:26
        mass1_tab(i) = mass1_tab(i-1)*(1+nagr1);
        mass2_tab(i) = mass2_tab(i-1)*(1+nagr2);
        tinflow_mass1_tab(i) = (nagr1+degradation_adr1)*mass1_tab(i-1);
        tinflow_mass2_tab(i) = (nagr2+degradation_adr2)*mass2_tab(i-1) - degradation_adr1*mass1_tab(i-1);
    end
    newmass1_tab_glo{itab} = newmass1_tab;
    newmass2_tab_glo{itab} = newmass2_tab;
    newmass3_tab_glo{itab} = newmass3_tab-newmass3_tab(13);
    newtinflow_mass1_tab_glo{itab} = newtinflow_mass1_tab;
    newtinflow_mass2_tab_glo{itab} = newtinflow_mass2_tab;

    % figure
    % plot(2015:2037,tinflow_mass2_tab); hold on;
    % plot(2015:2037,newtinflow_mass2_tab); hold on;
    figure
    plot(2015:2040,mass1_tab./mass2_tab); hold on;
    plot(2015:2040,newmass1_tab./newmass2_tab);
    plot(2015:2040,tinflow_mass1_tab./tinflow_mass2_tab); hold on;
    plot(2015:2040,newtinflow_mass1_tab./newtinflow_mass2_tab); hold on;
    title('Ratio between big and small')
    title(['Mmm2dr: ' num2str(degradation_adr1) ' m1dr: '  num2str(degradation_adr1) ' iagr1: ' num2str(inflow_agr1) ' iagr2: ' num2str(inflow_agr2) ' nagr1: ' num2str(nagr1) ' nagr2: ' num2str(nagr2)]);
    ylabel('Ratio between big and small')
    xlabel('Date')
    legend('Total mass w/ direct annual growth rates','Total mass w/ influx annual growth rates','Influx mass w/ direct annual growth rates','Influx mass w/ influx annual growth rates')
    grid on;

end
%%
for i=1:2
    newtinflow_mass1_2015(i)= (starting_mass_macro(i)+starting_mass_meso(i))*newtinflow_mass1_tab_glo{i}(2);
    newtinflow_mass2_2015(i)= (starting_mass_macro(i)+starting_mass_meso(i))*newtinflow_mass2_tab_glo{i}(2);
    netgrowth1_2015{i}=100*gradient(newmass1_tab_glo{i})./newmass1_tab_glo{i};
    netgrowth2_2015{i}=100*gradient(newmass2_tab_glo{i})./newmass2_tab_glo{i};
end
figure 
plot(newtinflow_mass1_2015); hold on;
plot(newtinflow_mass2_2015)

figure
for i=1:2
    plot(netgrowth1_2015{i}); hold on;
    plot(netgrowth2_2015{i}); hold on;
end


