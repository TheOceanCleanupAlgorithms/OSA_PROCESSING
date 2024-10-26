load("../data/stats/1800/2pc/statsY2018.mat","LAT_AVG","LON_AVG","stats");
load("../data/barriers/1800/2pc/barriers_14Y2018.mat");
%%
figure
outputVideo = VideoWriter('outputdensity_barriers.avi'); % You can use 'MPEG-4' for .mp4 files
outputVideo.FrameRate = 20; % Set the frame rate
open(outputVideo);
for i = 1:4:size(mask_bau_tab,2)-3%size(stats)
    %ibar = (i-1)*2 + 1;
    hold off;
    new_tab = double(mask_bau_tab{i});
    for j = 2:4
        new_tab = new_tab + double(mask_bau_tab{i+j-1});
    end
    new_tab = new_tab/4;
    pcolor(LON_AVG,LAT_AVG,new_tab);
    shading flat;
    hold on;
    %scatter(p.LON(ibar,:),p.LAT(ibar,:),25,'m','filled');
    title(['Day: ' num2str((i-1)*7)]);
    %axis([-170+360 -110+360 15 45])
    axis([-160+360 -125+360 20 45])
    clim([0.5 0.500001]);
    %colormap jet;
    %colorbar;
    drawnow
    frame = getframe(gcf);
    writeVideo(outputVideo, frame);
end
close(outputVideo);
