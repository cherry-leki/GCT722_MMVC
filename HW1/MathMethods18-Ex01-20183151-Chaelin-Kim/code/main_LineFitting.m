clear all

%% Initial settings
n = 100;
a = 5 / 6;
b = 0.1;
inlierThreshold = 0.1;
outlierRatio = [0, 0.1];

data = [];
result_IRLS = [];
result_L1 = [];
result_Linf = [];

%% IRLS AND NORMS FOR LINE FITTING
% Generate synthesized data
for itr=1:size(outlierRatio,2)
    data{itr} = genLineData(n, a, b, inlierThreshold, outlierRatio(itr));
end
    
% Norm 1 with IRLS
for itr=1:size(outlierRatio,2)
    result_IRLS{itr} = doIRLS(n, data{itr});
end

% Norm 1 with LP
for itr=1:size(outlierRatio,2)
    result_L1{itr} = doLP(data{itr}, "L1");
end

% Norm infinity with LP
for itr=1:size(outlierRatio,2)
    result_Linf{itr} = doLP(data{itr}, "Linf");
end

% Draw Line Fitting plots
drawLineFittingPlot(a, b, data, {result_IRLS, result_L1, result_Linf}, outlierRatio);