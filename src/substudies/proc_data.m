%clear
%close all
%load('data.mat')
meas = GPGPdata20212024S3.Measured_extracted;
mod1  = GPGPdata20212024S3.Modelled_extracted;
mod2  = GPGPdata20212024S2.Modelled_extracted;
mod3  = GPGPdata20212024S4.Modelled_extracted;

%% The Ocean Cleanup colormap
toc_navy=[0    0.2148    0.3320];
toc_blue_light = [0.0039    0.7930    0.8789];
toc_blue_dark = [0.0547    0.1211    0.1680];
toc_blue_mid = [0    0.2148    0.3320];
toc_blue_grey = [0.3555    0.4961    0.5703];
toc_light_grey = [0.9453    0.9570    0.9609];
map = [toc_blue_grey; toc_blue_light; toc_navy; toc_blue_dark];
%%
figure
scatter(meas,mod1,40,toc_blue_light,'Filled',MarkerFaceAlpha=1); hold on;
scatter(meas,mod2,40,toc_navy,'Filled',MarkerFaceAlpha=0.5); hold on;
plot(meas,meas,'k-')
legend('Modeled-extracted','Modeled-encountered','y=x')
xlabel('Measured')
ylabel('Modeled')
grid on;

index = 1:size(GPGPdata20212024S2,1);
for j = 0:1:100
    prctile_j_mod1 = prctile(mod1,j);
    prctile_j_meas = prctile(meas,j);
    index_prctile_j_pos = index(mod1>=prctile_j_mod1);
    index_prctile_j_neg = index(mod1<prctile_j_mod1);
    true_pos = 0;
    false_pos = 0;
    true_neg = 0;
    false_neg = 0;
    total = 0;
    for i=index_prctile_j_pos
        if meas(i)>= prctile_j_meas
            true_pos = true_pos + 1;
        else
            false_pos = false_pos + 1;
            if j == 90
            i
            end
        end
        total = total + 1;
    end
    true_pos_tab(j/1+1) = true_pos / total;
    false_pos_tab(j/1+1) = false_pos / total;
    total = 0;
    for i=index_prctile_j_neg
        if meas(i)>= prctile_j_meas
            true_neg = true_neg + 1;
            if j == 90
            i
            end
        else
            false_neg = false_neg + 1;
        end
        total = total + 1;
    end
    true_neg_tab(j/1+1) = true_neg / total;
    false_neg_tab(j/1+1) = false_neg / total;
end
prctile_tab = 0:1:100;

figure
plot(prctile_tab,movmean(true_pos_tab,10),'Color',toc_blue_light,'LineWidth',3); hold on;
plot(prctile_tab,movmean(false_neg_tab,10),'Color',toc_navy,'LineWidth',3);
xlabel('Percentile')
legend('True positive','False negative')
%plot(prctile_tab,movmean(true_neg_tab,10))
%plot(prctile_tab,movmean(false_neg_tab,10))

%%
val_max = 120;
val_min = 0;
for icase = 1:2
    if icase ==1
        dat = mod1;
        color = toc_blue_light;
    else
        dat = meas;
        color = toc_navy;
    end
    figure(2)
    test=histogram(dat(1:39),10,'BinLimits',[0 120000],'FaceColor',toc_blue_light,'FaceAlpha',0.3,'EdgeColor',toc_blue_light,'LineWidth',1,'Normalization','probability');hold on;
    %histogram(meas(1:39),10,'BinLimits',[0 120000],'FaceColor',toc_blue_light,'Normalization','probability'); 
    test_tab = test.Values;
    close 2
    step = (val_max-val_min)/10;
    val_tab = step/2:step:val_max - step/2;
    figure(1)
    scatter(val_tab,test_tab,100,color,'Filled'); hold on;
    grid on;
end
xlabel('Mass concentration (g/km2)')
ylabel('Probability')

% Comparison with GPGP content
%%
close all
values = [meas;mod1;mod2;mod3];
names = [(repmat({'Meas'}, 1, length(values)/4))';(repmat({'Mod1'}, 1, length(values)/4))';(repmat({'Mod2'}, 1, length(values)/4))';(repmat({'Mod3'}, 1, length(values)/4))'];

% Create the boxplot
boxplot(values', names','Symbol', '');

% Add title and axis labels if needed
title('Boxplot of Data for name1, name2, and name3');
xlabel('Categories');
ylabel('Values');

    

