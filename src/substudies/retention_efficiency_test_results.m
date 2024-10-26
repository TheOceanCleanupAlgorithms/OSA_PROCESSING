%% The Ocean Cleanup colormap
toc_navy=[0    0.2148    0.3320];
toc_blue_light = [0.0039    0.7930    0.8789];
toc_blue_dark = [0.0547    0.1211    0.1680];
toc_blue_mid = [0    0.2148    0.3320];
toc_blue_grey = [0.3555    0.4961    0.5703];
toc_light_grey = [0.9453    0.9570    0.9609];
map = [toc_blue_grey; toc_blue_light; toc_navy; toc_blue_dark];

% Example data
%caught = [77, 48, 420, 407, 562];
%lost = [65, 23, 119, 61, 67];
caught = [77, 48, 420, 342, 379];
lost = [65, 23, 119, 55, 27];
wind_magnitude = [25, 20, 15, 10, 5];
%errors = [0, 0, 0, 0, 0];  % Example error data for the lost category

% Normalize data to percentages
total = caught + lost;
caught_percent = (caught ./ total) * 100;
lost_percent = (lost ./ total) * 100;

% Combine data for stacked bar chart
data_percent = [caught_percent', lost_percent'];

% Create the horizontal stacked bar chart
figure;
barh_handle = barh(wind_magnitude, data_percent, 'stacked');
barh_handle(1).FaceColor = toc_blue_light;  % Color for 'Caught'
barh_handle(2).FaceColor = toc_navy;  % Color for 'Lost'

% Add labels and title
xlabel('Percentage');
ylabel('Wind magnitude (kn)');
title('Retention efficiency tests results');
legend('Caught', 'Lost', 'Location', 'southeast');

% Add error bars for the 'Lost' category
hold on;
% Calculate the positions for the error bars (midpoints of the 'lost' bars)
midpoints = wind_magnitude; 
% Normalize error values to percentages
%errors_percent = errors;%(errors ./ total) * 100;
%errorbar(caught_percent, midpoints, errors_percent, 'horizontal', 'k', 'linestyle', 'none', 'LineWidth', 1);
hold off;

% Add data labels
for i = 1:length(wind_magnitude)
    text(caught_percent(i) / 2, wind_magnitude(i), num2str(caught(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'white', 'FontWeight', 'bold');
    text(caught_percent(i) + lost_percent(i) / 2, wind_magnitude(i), num2str(lost(i)), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'white', 'FontWeight', 'bold');
end

% Adjust axes and grid
xlim([0 100]);
xticks(0:10:100);
grid on;

%%
figure
scatter(wind_magnitude-2.5,caught_percent,40,toc_blue_light,'Filled'); hold on;
plot(wind_magnitude-2.5,100*(-0.0194*(wind_magnitude-2.5) + 1.0034),'LineWidth',2,'LineStyle','--','Color',toc_navy)
title('Wind magnitude vs efficiency')
grid on;
legend('Measured efficiency','y=100*(-0.0194*(x-2.5) + 1.0034)');
%%
close all
names = [];
values = [];

end
for i_combo = 1:n_combo
    data_mat = encountered_density_glo2{i_combo}(1:end/10,:);
    data = data_mat(:);
    values = [values ; data];
    names = [names; (repmat(name_treated(i_combo), 1, length(data)))'];
end

% Create the boxplot
figure;
boxplot(values', names','Symbol', '');

% Add title and axis labels if needed
title('Boxplot of Data for name1, name2, and name3');
xlabel('Categories');
ylabel('Values');
ylim([0 200])