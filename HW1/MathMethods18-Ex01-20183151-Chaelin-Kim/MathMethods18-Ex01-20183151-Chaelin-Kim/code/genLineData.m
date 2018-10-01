function [ data ] = genLineData( n, a, b, inlierThreshold, outlierRatio )

outlierNum = outlierRatio * 100;
inlierNum = n - (outlierRatio * 100);

rng('shuffle', 'twister');
%% make inlier data

noise_x = -inlierThreshold + (2 * inlierThreshold) * rand(inlierNum, 1);
noise_y = -inlierThreshold + (2 * inlierThreshold) * rand(inlierNum, 1);

x_data_i = -10 + (10 + 10) * rand(inlierNum, 1) + noise_x;
y_data_i = (a * x_data_i + b) + noise_y;

%% make outlier data
oDataNum = 0;

x_data_o = [];
y_data_o = [];

while oDataNum < outlierNum
    temp_x = -10 + 20 * rand;
    temp_y = -10 + 20 * rand;
    if (abs(temp_y - (a * temp_x + b)) <= inlierThreshold)
        continue;
    end
    x_data_o = [x_data_o, temp_x];
    y_data_o = [y_data_o, temp_y];
    oDataNum = oDataNum + 1;
end

data = [[x_data_i', x_data_o]; [y_data_i', y_data_o]];

end

