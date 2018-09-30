function [ ] = doExhaustiveSearch( data, k, inlierThreshold, outlierRatio)

n = 1:1:size(data,2);               % Data size
combination = nchoosek(n,k);        % The number of combinations of the elements
bestModel = [];                     % The result of exhaustive searching
maxInlier = 0;                      % The result of the number of inliers

for itr=1:size(combination,1)
    % Select 3 points according to combination
    selectPoint_x = data(1, combination(itr,1:3));
    selectPoint_y = data(2, combination(itr,1:3));
    % Calculate the circle including upper 3 points
    % ref: http://egloos.zum.com/heilow/v/418569
    % Gradient
    grad1 = (selectPoint_x(2)-selectPoint_x(1)) / (selectPoint_y(2)-selectPoint_y(1));
    grad2 = (selectPoint_x(3)-selectPoint_x(2)) / (selectPoint_y(3)-selectPoint_y(2));
    % Center of the circle
    center_X = ((selectPoint_y(3)-selectPoint_y(1)) + (selectPoint_x(2) + selectPoint_x(3)) * grad2 - (selectPoint_x(1) + selectPoint_x(2)) * grad1) / (2 * (grad2 - grad1));
    center_Y = -grad1 * (center_X - (selectPoint_x(1) + selectPoint_x(2)) / 2) + (selectPoint_y(1) + selectPoint_y(2)) / 2;
    % Radius of the circle
    radius = sqrt((selectPoint_x(1) - center_X)^2 + (selectPoint_y(1) - center_Y)^2);

    % Caculate error
    inlierCount = ((data(1,:)-center_X).^2 + (data(2,:)-center_Y).^2 >= (radius - inlierThreshold)^2) & ...
        ((data(1,:)-center_X).^2 + (data(2,:)-center_Y).^2 <= (radius + inlierThreshold)^2);
    numOfInlier = nnz(inlierCount);     % The number of Inliers

    % Set the best result
    if numOfInlier > maxInlier
        maxInlier = numOfInlier;
        bestModel = [center_X, center_Y, radius];
    end
end

% Show the result of exhaustive search on the output window
disp("+------------- Outlier Ratio " + outlierRatio + " -------------+");
disp("Number of iteration: " + size(combination,1));
disp("Number of max Inlier: " + maxInlier);
disp("Model(x, y, r): " + bestModel(1) + "," + bestModel(2) + "," + bestModel(3)); 
disp("-----------------------------------------------");
end

