clear all

%% Initial settings
n = 100;                % Number of data points
center = [0, 0];        % Center value for the synthesized circle
radius = 5;             % Radius value for the synthesized circle
inlierThreshold = 0.1;
outlierRatio = [0.05, 0.2, 0.3, 0.7];

data = [];
ransacResult = [];
histResult = [];

%% RANSAC
% Generate synthesized data
for itr = 1:size(outlierRatio, 2)
    data{itr} = genCircleData(n, center, radius, inlierThreshold, outlierRatio(itr));
end
    
% Execute RANSAC
for itr = 1:size(outlierRatio, 2)
    [ransacResult{itr}, histResult{itr}] = doRANSAC(data{itr}, 1000, inlierThreshold, outlierRatio(itr));
end

% Execute exhaustive search
for itr = 1:size(outlierRatio, 2)
    % The result is shown on the output window
    doExhaustiveSearch(data{itr}, 3, inlierThreshold, outlierRatio(itr));
end

% Draw RANSACplots
drawRANSACPlot(center, radius, data, ransacResult, histResult, outlierRatio);