function [bestModel, detectedInliers] = doRANSAC(data, M, inlierThreshold, outlierRatio)

% Compute the number of RANSAC iteration
N = log(1-0.99) / log(1 - (1 - outlierRatio)^3);
disp("The computed value of RANSAC iteration("+ outlierRatio +"): " + N);

bestModel = [];                     % The result of exhaustive searching 
maxInlier = 0;                      % The result of the number of inliers
detectedInliers = zeros(1, 1000);   % The result matrix of the number of inliers for histogram

% Iteration for re-apply RANSAC 
for itr=1:M
    itrModel = [];
    itrInlier = 0;
    % RANSAC iteration
    for itr2=1:N
        % Select Random 3 points
        randomNum = floor(100 * rand(3, 1)) + 1;
        randomPoint_x = data(1, randomNum);
        randomPoint_y = data(2, randomNum);
        % Calculate the circle including upper 3 points
        % ref: http://egloos.zum.com/heilow/v/418569
        % Gradient
        grad1 = (randomPoint_x(2)-randomPoint_x(1)) / (randomPoint_y(2)-randomPoint_y(1));
        grad2 = (randomPoint_x(3)-randomPoint_x(2)) / (randomPoint_y(3)-randomPoint_y(2));
        % Center of the circle
        center_X = ((randomPoint_y(3)-randomPoint_y(1)) + (randomPoint_x(2) + randomPoint_x(3)) * grad2 - (randomPoint_x(1) + randomPoint_x(2)) * grad1) / (2 * (grad2 - grad1));
        center_Y = -grad1 * (center_X - (randomPoint_x(1) + randomPoint_x(2)) / 2) + (randomPoint_y(1) + randomPoint_y(2)) / 2;
        % Radius of the circle
        radius = sqrt((randomPoint_x(1) - center_X)^2 + (randomPoint_y(1) - center_Y)^2);
        
        % Caculate error
        inlierCount = ((data(1,:)-center_X).^2 + (data(2,:)-center_Y).^2 >= (radius - inlierThreshold)^2) & ...
            ((data(1,:)-center_X).^2 + (data(2,:)-center_Y).^2 <= (radius + inlierThreshold)^2);
        numOfInlier = nnz(inlierCount);
        
        if numOfInlier > itrInlier
            itrInlier = numOfInlier;
            itrModel = [center_X, center_Y, radius];
        end
    end
    detectedInliers(itr) = itrInlier;
    if itrInlier > maxInlier
        maxInlier = itrInlier;
        bestModel = itrModel;
    end
end
end