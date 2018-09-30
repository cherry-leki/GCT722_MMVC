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
    d1 = (selectPoint_x(2)-selectPoint_x(1)) / (selectPoint_y(2)-selectPoint_y(1));
    d2 = (selectPoint_x(3)-selectPoint_x(2)) / (selectPoint_y(3)-selectPoint_y(2));
    % Center of the circle
    cx = ((selectPoint_y(3)-selectPoint_y(1)) + (selectPoint_x(2) + selectPoint_x(3)) * d2 - (selectPoint_x(1) + selectPoint_x(2)) * d1) / (2 * (d2 - d1));
    cy = -d1 * (cx - (selectPoint_x(1) + selectPoint_x(2)) / 2) + (selectPoint_y(1) + selectPoint_y(2)) / 2;
    % Radius of the circle
    r = sqrt((selectPoint_x(1) - cx)^2 + (selectPoint_y(1) - cy)^2);

    % Caculate error
    inlierCount = ((data(1,:)-cx).^2 + (data(2,:)-cy).^2 >= (r - inlierThreshold)^2) & ...
        ((data(1,:)-cx).^2 + (data(2,:)-cy).^2 <= (r + inlierThreshold)^2);
    numOfInlier = nnz(inlierCount);     % The number of Inliers

    % Set the best result
    if numOfInlier > maxInlier
        maxInlier = numOfInlier;
        bestModel = [cx, cy, r];
    end
end

% Show the result of exhaustive search on the output window
disp("+------------- Outlier Ratio " + outlierRatio + " -------------+");
disp("Number of iteration: " + size(combination,1));
disp("Number of max Inlier: " + maxInlier);
disp("Model(x, y, r): " + bestModel(1) + "," + bestModel(2) + "," + bestModel(3)); 
disp("-----------------------------------------------");
end

