function [ ] = drawRANSACPlot( center, radius, data, ransacResult, histResult, outlierRatio )
f = figure('Position',[0 0 1280 800]);
p = uipanel('Parent', f, 'BorderType', 'none');
for itr=1:size(outlierRatio,2)
    % histogram plot
    subplot(2,4,itr,'Parent', p);
    hist(histResult{itr}, 0:100);
    xlabel('Nb of detected inliers')
    ylabel('Nb of experiments')
    xlim([1, 100]);
    % RANSAC plot
    subplot(2,4,(itr + 4),'Parent', p);
    inlierNum = 100 - outlierRatio(itr) * 100;
    dataPlot = plot(data{itr}(1,1:inlierNum), data{itr}(2,1:inlierNum), 'o', data{itr}(1,(inlierNum+1):100), data{itr}(2,(inlierNum+1):100), 'o');
    synCircle = viscircles(center, radius, 'Color', 'g', 'LineWidth', 0.05);
    ransacCircle = viscircles([ransacResult{itr}(1), ransacResult{itr}(2)], ransacResult{itr}(3), 'Color', 'black', 'LineWidth', 0.05);
    hold on
    legend(dataPlot, {'RANSAC inliers', 'RANSAC outliers'}, 'Location', 'southoutside');
    
    hold off
    xlim([-10, 10]);
    ylim([-10, 10]);
end
end

