close all
GPGP_bo_starting_mass = [60000, 100000];
GPGP_fr_starting_mass = [10000, 5000];
GPGP_bo_inflow = [2.5, 4.5];
GPGP_fr_inflow = [4.5, 1.5];
GPGP_ratio_inflow = [2.25 6];
GPGP_bo_fr = [2.5, 2];
GPGP_fr_ud = [2.5, 3.5];

cleaning_rate_0 = 0.25;

for k = 1:2 % differentiate the two inflow methods
    for i = 1:2
        % initiate the mass vectors
        GPGP_bo_mass = zeros(size(2015:2037));
        GPGP_fr_mass = zeros(size(2015:2037));
        GPGP_bo_bau_mass = zeros(size(2015:2037));
        GPGP_fr_bau_mass = zeros(size(2015:2037));
        % initiate the counter mass
        bo = GPGP_bo_starting_mass(1,i);
        fr = GPGP_fr_starting_mass(1,i);
        bo_bau = bo;
        fr_bau = fr;
        % loop through time
        for j = 1:size(GPGP_bo_mass,2)
            % update mass values in the table
            GPGP_bo_mass(1,j) = bo;
            GPGP_fr_mass(1,j) = fr;
            GPGP_bo_bau_mass(1,j) = bo_bau;
            GPGP_fr_bau_mass(1,j) = fr_bau;
            % backup initial condition for the time step
            bo_bau_0 = bo_bau;
            fr_bau_0 = fr_bau;
            bo_0 = bo;
            fr_0 = fr;
            % differentiate cleaning / non cleaning conditions
            if (j-1+2015)>=2027
                cleaning_rate = cleaning_rate_0;
            else
                cleaning_rate = 0;
            end
            % differentiate the ratio case and the normal case
            if k==1 && i==1
                line_color = 'b';
            elseif k== 1 && i==2
                line_color = 'c';
            elseif k==2 && i==1
                line_color = 'r';
            elseif k==2 && i==2
                line_color = 'm';
            end
            if k == 1
                % Business as usual
                bo_bau = bo_bau_0 + (GPGP_bo_inflow(i) - GPGP_bo_fr(i))/100*bo_bau_0;
                fr_bau = fr_bau_0 + GPGP_bo_fr(i)/100*bo_bau_0 + GPGP_fr_inflow(i)/100*fr_bau_0 - GPGP_fr_ud(i)/100*fr_bau_0;
                % While cleaning
                bo = (1-cleaning_rate)*bo_0 + GPGP_bo_inflow(i)/100*bo_bau_0 - GPGP_bo_fr(i)/100*bo_0;
                fr = fr_0 + GPGP_bo_fr(i)/100*bo_0 + GPGP_fr_inflow(i)/100*fr_bau_0 - GPGP_fr_ud(i)/100*fr_0;
            else
                % Business as usual
                bo_bau = bo_bau_0 + (GPGP_bo_inflow(i) - GPGP_bo_fr(i))/100*bo_bau_0;
                fr_bau = fr_bau_0 + GPGP_bo_inflow(i)/100*bo_bau_0/GPGP_ratio_inflow(i) + GPGP_bo_fr(i)/100*bo_bau_0 - GPGP_fr_ud(i)/100*fr_bau_0;
                % While cleaning
                bo = (1-cleaning_rate)*bo_0 + GPGP_bo_inflow(i)/100*bo_bau_0 - GPGP_bo_fr(i)/100*bo_0;
                fr = fr_0 + GPGP_bo_fr(i)/100*bo_0 + GPGP_bo_inflow(i)/100*bo_bau_0/GPGP_ratio_inflow(i) - GPGP_fr_ud(i)/100*fr_0;
            end
        end
        figure(1)
        plot(2015:2037,GPGP_bo_mass+GPGP_fr_mass,line_color); hold on;
        plot(2015:2037,GPGP_bo_bau_mass+GPGP_fr_bau_mass,[line_color '--']); hold on;
        title(['Total mass evolution for ' num2str(cleaning_rate*100) '% yearly cleanup vs BAU'])
        figure(2)
        plot(2015:2037,(GPGP_bo_mass+GPGP_fr_mass)/(GPGP_bo_bau_mass(23)+GPGP_fr_bau_mass(23)),line_color); hold on;
        title(['Total cleaning ratio for ' num2str(cleaning_rate*100) '% yearly cleanup'])
        figure(3)
        plot(2015:2037,GPGP_bo_mass./(GPGP_bo_mass+GPGP_fr_mass),line_color); hold on;
        plot(2015:2037,GPGP_bo_bau_mass./(GPGP_bo_bau_mass+GPGP_fr_bau_mass),[line_color '--']); hold on;
        title(['BO ratio for ' num2str(cleaning_rate*100) '% yearly cleanup vs BAU'])
        figure(4)
        plot(2015:2037,GPGP_bo_mass,line_color); hold on;
        plot(2015:2037,GPGP_bo_bau_mass,[line_color '--']); hold on;
        title(['BO mass evolution for ' num2str(cleaning_rate*100) '% yearly cleanup vs BAU'])
        figure(5)
        plot(2015:2037,GPGP_fr_mass,line_color); hold on;
        plot(2015:2037,GPGP_fr_bau_mass,[line_color '--']); hold on;
        title(['Fragment mass evolution for ' num2str(cleaning_rate*100) '% yearly cleanup vs BAU'])
        figure(6)
        plot(2015:2037,GPGP_fr_mass/(GPGP_bo_bau_mass(23)+GPGP_fr_bau_mass(23)),line_color); hold on;
        plot(2015:2037,GPGP_fr_bau_mass/(GPGP_bo_bau_mass(23)+GPGP_fr_bau_mass(23)),[line_color '--']); hold on;
        title(['FR / total mass for ' num2str(cleaning_rate*100) '% yearly cleanup vs BAU'])
        figure(7)
        plot(2015:2037,(GPGP_bo_mass)/(GPGP_bo_bau_mass(23)),line_color); hold on;
        title(['BO cleaning ratio for ' num2str(cleaning_rate*100) '% yearly cleanup'])
    end
end
for f = 1:7
    figure(f)
    grid on;
    if f == 2 || f == 7
        legend('Inflow 1 / Low BO wcu','Inflow 1 / High BO wcu','Inflow 2 / Low BO wcu','Inflow 2 / High BO wcu')
    else
        legend('Inflow 1 / Low BO wcu','Inflow 1 / Low BO bau','Inflow 1 / High BO wcu','Inflow 1 / High BO bau','Inflow 2 / Low BO wcu','Inflow 2 / Low BO bau','Inflow 2 / High BO wcu','Inflow 2 / High BO bau')
    end
end
