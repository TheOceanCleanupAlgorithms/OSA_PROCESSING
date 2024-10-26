%lambda = 2*10^(-4);
%lambda=2.29*10^(-2)/52;
%
%lambda = 0.85*10^(-2)/52; %3%BO1 %0.43%BO2 %0.47%FR1 8.6%FR2 
lambda = 0.25*10^(-2)/52; %1%BO1 %0.14%BO2 %0.16%
% FR1 2.9%FR2


p = 0.4;  
step = 0.1;
%size_classes_start = [0.05 0.5 1];
size_classes_start = [0.015 0.05 0.5 1];
%size_classes_start = [0.0005 0.0015 0.005 0.015 0.05];
%size_classes_start = [0.0005 0.0015 0.005 0.015];
%wd_starting = [17.6/2 17.6/2+31.2/2 31.2/2];
wd_starting = [2.1/2 2.1/2+17.6/2 17.6/2+31.2/2 31.2/2];
%wd_starting = [0.23/2 0.23/2+2.29/2 2.29/2+1.95/2 1.95/2+2.1/2 2.1/2];
%wd_starting = [0.23/2 0.23/2+2.29/2 2.29/2+1.95/2 1.95/2];
%size_classes_end = [0.0005 0.05];
size_classes_end = [0.005 0.015];
%size_classes_end = [1e-9 0.0005];
%size_classes_end = [1e-9 0.005];
%size_classes_end = [0.0005 0.015];
total_mass_end = 0;

for scstart = 1:length(size_classes_start)
    for k=0:10/step
        for iweek = 1:52
            f = lambda*(iweek-1);
            mass(k+1,iweek)=gamma(k*step+f)/(gamma(k*step+1)*gamma(f))*p^(k*step)*(1-p)^f;
            size2(k+1)=size_classes_start(scstart)*(0.5^(k*step));
        end
    end
    for iweek = 1:52
        mass(:,iweek) = wd_starting(scstart)*mass(:,iweek)/sum(mass(:,iweek));
    end

    figure
    for i=1:4:52
        plot(size2,mass(:,i)), hold on;
    end
    set(gca, 'XScale', 'log', 'YScale', 'log');
    grid on;
    title('Evolution of the mass distribution over time');
    xlabel('Plastic fraction')
    ylabel('Mass')

    mass_final = mass(:,end);
    total_mass_end = total_mass_end + sum(mass_final(size2>size_classes_end(1) & size2<size_classes_end(2)));
end
total_mass_start = sum(wd_starting);
total_mass_end/total_mass_start