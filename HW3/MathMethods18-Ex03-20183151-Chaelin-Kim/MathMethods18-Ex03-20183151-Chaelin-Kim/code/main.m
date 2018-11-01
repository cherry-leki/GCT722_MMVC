clear;

%% Initial Setting
srcData = load('../data/InputData.mat');
circleRad = srcData.CircleRadius;
image = srcData.I;
points = srcData.ListInputPoints;

% x = 1104, y = 549
lowerBound = 0;
upperBound = 200;
lowerBoundList = lowerBound;
upperBoundList = upperBound;

underX = 1;
underY = 1;
upperX = size(image, 2);
upperY = size(image, 1);

spaceList = {lowerBound, upperBound, [underX, upperX], [underY, upperY]};
iteration = 1;

getOut = 0;
result = [];
while getOut < 1
    currentSpace = spaceList(1,:);

    [spaceList(end+1,:), spaceList(end+1,:)] = doBNB(currentSpace, circleRad, points);

    spaceList = spaceList(2:end,:);
    
    spaceList = sortrows(spaceList, 2, 'descend');
    spaceList = sortrows(spaceList, 1, 'descend');

    for itr=1:size(spaceList, 1)
        if spaceList{1, 1} > spaceList{itr, 2}
            spaceList(itr, :) = [];
        end
        
        if itr >= size(spaceList, 1)
            break;
        end
    end

    iteration = iteration + 1;
    upperBoundList = [upperBoundList, spaceList{1, 2}];
    lowerBoundList = [lowerBoundList, spaceList{1, 1}];
    
    if spaceList{1, 2} - spaceList{1, 1} < 1
        getOut = 1;
        result = spaceList(1, :);
    end
end

[~,~,lowerInliersIndex, upperInlierIndex] = calBounds(result(3:4), circleRad, points);

inliers = [];
outliers = [];
step = 1;
for itr=1:size(points, 1)
    if itr == lowerInliersIndex(step)
        inliers = [inliers; points(itr, :)];
        step = step + 1;
    else
        outliers = [outliers; points(itr, :)];
    end
end

%% Show result image
subplot(2, 2, 1);
imshow(image);
title('Before BnB');
hold on;
plot(points(:, 1), points(:, 2), '.', 'Color', 'c', 'MarkerSize', 12);
hold off;

subplot(2, 2, 2);
imshow(image);
title('After BnB');
hold on;
plot(inliers(:,1), inliers(:,2), '.', 'Color', 'g', 'MarkerSize', 12);
plot(outliers(:,1), outliers(:,2), '.', 'Color', 'r', 'MarkerSize', 12);
viscircles([result{3}(1), result{4}(1)], circleRad, 'Color', 'b');
hold off;

subplot(2, 2, [3,4]);
hold on;
plot(upperBoundList, '-o');
plot(lowerBoundList, '-o');
title('Convergence of bounds');
hold off;