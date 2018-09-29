clear all

%% Initial settings
n = 100;
center = [0, 0];
radius = 5;
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

% Execute exhaustive search
for itr = 1:size(outlierRatio, 2)
    doExhaustiveSearch(data{itr}, 3, inlierThreshold);
end
    
% Execute RANSAC function
for itr = 1:size(outlierRatio, 2)
    [ransacResult{itr}, histResult{itr}] = doRANSAC(data{itr}, inlierThreshold, outlierRatio(itr));
end

% Draw RANSACplots
drawRANSACPlot(center, radius, data, ransacResult, histResult, outlierRatio);