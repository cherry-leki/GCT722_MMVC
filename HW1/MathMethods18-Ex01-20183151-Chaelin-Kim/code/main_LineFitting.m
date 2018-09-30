clear all

%% Initial settings
n = 100;            % Number of data points
a = 5 / 6;          % Gradient value for the synthesized line
b = 0.1;            % Bias value for the synthesized line
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
    
% L1 Norm with IRLS
for itr=1:size(outlierRatio,2)
    result_IRLS{itr} = doIRLS(data{itr});
end

% L1 Norm with LP
for itr=1:size(outlierRatio,2)
    result_L1{itr} = doLP(data{itr}, "L1");
end

% L infinity Norm with LP
for itr=1:size(outlierRatio,2)
    result_Linf{itr} = doLP(data{itr}, "Linf");
end

% Draw Line Fitting plots
drawLineFittingPlot(a, b, data, {result_IRLS, result_L1, result_Linf}, outlierRatio);