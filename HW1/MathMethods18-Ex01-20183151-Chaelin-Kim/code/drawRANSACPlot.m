function [ ] = drawRANSACPlot( center, radius, data, ransacResult, histResult, outlierRatio )
f = figure('Position',[0 0 1280 900]);
p = uipanel('Parent', f, 'BorderType', 'none');
set(p, 'Title', 'RANSAC FOR CIRCLE FITTING');
set(p, 'TitlePosition', 'centertop');
set(p, 'FontWeight', 'bold', 'FontSize', 14);
for itr=1:size(outlierRatio,2)
    % histogram plot
    subplot(2,4,itr,'Parent', p);
    hist(histResult{itr}, 0:100);
    title("Outlier Ratio: " + outlierRatio(itr));
    xlabel('Nb of detected inliers')
    ylabel('Nb of experiments')
    xlim([1, 100]);
    % RANSAC plot
    sp = subplot(2,4,(itr + 4),'Parent', p);
    inlierNum = 100 - outlierRatio(itr) * 100;
    dataModel = plot(data{itr}(1,1:inlierNum), data{itr}(2,1:inlierNum), 'o', data{itr}(1,(inlierNum+1):100), data{itr}(2,(inlierNum+1):100), 'o');
    synModel = viscircles(center, radius, 'Color', 'g', 'LineWidth', 0.05);
    ransacModel = viscircles([ransacResult{itr}(1), ransacResult{itr}(2)], ransacResult{itr}(3), 'Color', 'black', 'LineWidth', 0.05);
    lh = legend(sp, [dataModel;synModel;ransacModel],{'RANSAC inliers','RANSAC outliers','RANSAC model', 'synth.model'});
    set(lh, 'Location', 'southoutside');
    xlim([-10, 10]);
    ylim([-10, 10]);
end
end

