function [ ] = drawLineFittingPlot( a, b, data, result, outlierRatio )
x = [-10, 10];
f = figure('Position', [0, 0, 900, 500]);
p = uipanel('Parent', f, 'BorderType', 'none');
set(p, 'Title', 'IRLS AND NORMS FOR LINE FITTING');
set(p, 'TitlePosition', 'centertop');
set(p, 'FontWeight', 'bold', 'FontSize', 14);
for itr=1:size(outlierRatio,2)
    subplot(1,2,itr,'Parent',p);
    plot(data{itr}(1,:), data{itr}(2,:), 'o');
    title("Outlier Ratio: " + outlierRatio(itr) )
    xlim([-10, 10]);
    ylim([-10, 15]);
    hold on
    % Synthesized line
    plot(x, a * x + b, 'Color', 'g', 'LineWidth', 2);
    % L1 with IRLS
    plot(x, result{1}{itr}(1) * x + result{1}{itr}(2), 'Color', 'black');
    % L1 with LP
    plot(x, result{2}{itr}(1) * x + result{2}{itr}(2), 'Color', 'black');
    % L infinity with LP
    plot(x, result{3}{itr}(1) * x + result{3}{itr}(2), 'Color', 'black');
    lh = legend('data points', 'synth.model', 'L1 with IRLS', 'L1 with LP', 'Linf with LP');
    set(lh, 'Location','southoutside');
    hold off
end

end

