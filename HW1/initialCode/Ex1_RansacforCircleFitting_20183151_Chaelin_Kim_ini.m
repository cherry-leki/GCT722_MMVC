clear all

%% initial settings
n = 100;
center = [0,0];
radius = 5;

outlierRatio = 0.7;
inlierThreshold = 0.1;

%% compute the number of outlier and inlier
outlierNum = outlierRatio * 100;
inlierNum = n - outlierNum;

%% setting for point of data with noise
rng('shuffle', 'twister');
angle = 2 * pi * rand(inlierNum, 1);
noise_x = -0.1 + (0.1 + 0.1) * rand(inlierNum, 1);
noise_y = -0.1 + (0.1 + 0.1) * rand(inlierNum, 1);

%% make inlier data
x_data_i = (noise_x + radius).*cos(angle) + center(1);
y_data_i = (noise_y + radius).*sin(angle) + center(2);

%% make outlier data
a = 0;
x_data_o = [];
y_data_o = [];

while a < outlierNum
    temp_x = -10 + 20 * rand;
    temp_y = -10 + 20 * rand;
    if ((center(1)-temp_x)^2 + (center(2)-temp_y)^2 >= (radius - inlierThreshold)^2) && ...
            ((center(1)-temp_x)^2 + (center(2)-temp_y)^2 <= (radius + inlierThreshold)^2)
        continue;
    end
    x_data_o = [x_data_o, temp_x];
    y_data_o = [y_data_o, temp_y];
    a = a + 1;
end

data = [[x_data_i', x_data_o]; [y_data_i', y_data_o]];

%% RANSAC
M = 1000;
N = log(1-0.99) / log(1 - (1 - outlierRatio)^3);
bestModel = [];
maxInlier = 0;
detectedInliers = zeros(1, 1000);

for itr=1:M
    itrModel = [];
    itrInlier = 0;
    for itr2=1:N
        % Select Random 3 points
        randomNum = floor(100 * rand(3, 1)) + 1;
        randomPoint_x = data(1, randomNum);
        randomPoint_y = data(2, randomNum);
        % Calculate the circle including upper 3 points
        % ref: http://egloos.zum.com/heilow/v/418569
        % Gradient
        d1 = (randomPoint_x(2)-randomPoint_x(1)) / (randomPoint_y(2)-randomPoint_y(1));
        d2 = (randomPoint_x(3)-randomPoint_x(2)) / (randomPoint_y(3)-randomPoint_y(2));
        % Center of the circle
        cx = ((randomPoint_y(3)-randomPoint_y(1)) + (randomPoint_x(2) + randomPoint_x(3)) * d2 - (randomPoint_x(1) + randomPoint_x(2)) * d1) / (2 * (d2 - d1));
        cy = -d1 * (cx - (randomPoint_x(1) + randomPoint_x(2)) / 2) + (randomPoint_y(1) + randomPoint_y(2)) / 2;
        % Radius of the circle
        r = sqrt((randomPoint_x(1) - cx)^2 + (randomPoint_y(1) - cy)^2);
        
        % Caculate error
        inlierCount = ((data(1,:)-cx).^2 + (data(2,:)-cy).^2 >= (r - inlierThreshold)^2) & ...
            ((data(1,:)-cx).^2 + (data(2,:)-cy).^2 <= (r + inlierThreshold)^2);
        numOfInlier = nnz(inlierCount);
        
        if numOfInlier > itrInlier
            itrInlier = numOfInlier;
            itrModel = [cx, cy, r];
        end
    end
    detectedInliers(itr) = itrInlier;
    if itrInlier > maxInlier
        maxInlier = itrInlier;
        bestModel = itrModel;
    end
end

%% draw plots
f = figure;
p = uipanel('Parent', f, 'BorderType', 'none');
s1 = subplot(1, 2, 1, 'Parent', p);
hist(detectedInliers, 0:100);
xlim([1, 100]);
s2 = subplot(1, 2, 2, 'Parent', p);
plot(x_data_i, y_data_i, 'o', x_data_o, y_data_o, 'o');
viscircles(center, radius, 'Color', 'g', 'LineWidth', 0.05);
viscircles([bestModel(1), bestModel(2)], bestModel(3), 'Color', 'black', 'LineWidth', 0.05);
xlim([-10, 10]);
ylim([-10, 10]);

% f = figure;
% p = uipanel('Parent', f, 'BorderType', 'none');
% set(p, 'title', 'Robust Estimation')
% p.TitlePosition = 'centertop';
% s1 = subplot(2,4,5,'Parent',p)
% plot(x_data, y_data, 'o', x_data_o, y_data_o, 'o')
% xlim([-10, 10])
% ylim([-10, 10])
% title('5%')
% s2 = subplot(2,4,6,'Parent',p)
% plot(x_data, y_data, 'o', x_data_o, y_data_o, 'o')
% xlim([-10, 10])
% ylim([-10, 10])
% title('20%')
% s3 = subplot(2,4,7,'Parent',p)
% plot(x_data, y_data, 'o', x_data_o, y_data_o, 'o')
% xlim([-10, 10])
% ylim([-10, 10])
% title('30%')
% s4 = subplot(2,4,8,'Parent',p)
% plot(x_data, y_data, 'o', x_data_o, y_data_o, 'o')
% xlim([-10, 10])
% ylim([-10, 10])
% title('70%')