function [ bestModel, maxInlier ] = doExhaustiveSearch( data, k, inlierThreshold)

n = 1:1:size(data,2);
combination = nchoosek(n,k);
bestModel = [];
maxInlier = 0;
detectedInliers = zeros(1, 1000);

for itr=1:size(combination,1)
    % Select Random 3 points
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
    numOfInlier = nnz(inlierCount);

    detectedInliers(itr) = numOfInlier;
    
    if numOfInlier > maxInlier
        maxInlier = numOfInlier;
        bestModel = [cx, cy, r];
    end
end

disp("-----------------");
disp("Number of iteration: " + size(combination,1));
disp("Number of max Inlier: " + maxInlier);
disp("Model(x, y, r): " + bestModel); 
disp("-----------------");
end

