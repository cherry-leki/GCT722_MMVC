function [bestModel, detectedInliers] = doRANSAC(data, inlierThreshold, outlierRatio)
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
end