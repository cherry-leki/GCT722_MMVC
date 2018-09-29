function [ data ] = genCircleData(  n, center, radius, inlierThreshold, outlierRatio )

outlierNum = outlierRatio * 100;
inlierNum = n - outlierNum;

rng('shuffle', 'twister');

%% make inlier data
angle = 2 * pi * rand(inlierNum, 1);

noise_x = -inlierThreshold + (2 * inlierThreshold) * rand(inlierNum, 1);
noise_y = -inlierThreshold + (2 * inlierThreshold) * rand(inlierNum, 1);

x_data_i = (noise_x + radius).*cos(angle) + center(1);
y_data_i = (noise_y + radius).*sin(angle) + center(2);

%% make outlier data
oDataNum = 0;

x_data_o = [];
y_data_o = [];

while oDataNum < outlierNum
    temp_x = -10 + 20 * rand;
    temp_y = -10 + 20 * rand;
    if ((center(1)-temp_x)^2 + (center(2)-temp_y)^2 >= (radius - inlierThreshold)^2) && ...
            ((center(1)-temp_x)^2 + (center(2)-temp_y)^2 <= (radius + inlierThreshold)^2)
        continue;
    end
    x_data_o = [x_data_o, temp_x];
    y_data_o = [y_data_o, temp_y];
    oDataNum = oDataNum + 1;
end

data = [[x_data_i', x_data_o]; [y_data_i', y_data_o]];

end

