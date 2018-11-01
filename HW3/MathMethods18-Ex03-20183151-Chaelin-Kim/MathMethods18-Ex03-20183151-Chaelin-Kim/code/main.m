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

spaceList = {lowerBound, upperBound, [1, size(image, 2)], [1, size(image, 1)]};

getOut = 0;
result = [];
while 1
    currentSpace = spaceList(1,:);

    % Split the space into two children and put them into the list
    [spaceList(end+1,:), spaceList(end+1,:)] = doBNB(currentSpace, circleRad, points);

    spaceList = spaceList(2:end,:);
    
    % Find the best lower bound
    spaceList = sortrows(spaceList, 1, 'descend');
    if spaceList{1, 1} > lowerBound
        lowerBound = spaceList{1, 1};
    end
    
    % Find the best upper bound
    spaceList = sortrows(spaceList, 2, 'descend');
    if spaceList{1, 2} < upperBound
        upperBound = spaceList{1, 2};
    end
    
    
    if upperBound - lowerBound <= 1
        result = spaceList(1, :);
        break;
    end
        
    upperBoundList = [upperBoundList, upperBound];
    lowerBoundList = [lowerBoundList, lowerBound]; 
        
    for itr=1:size(spaceList, 1)
        if lowerBound > spaceList{itr, 2}
            spaceList(itr, :) = [];
        end
        
        if itr >= size(spaceList, 1)
            break;
        end
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
subplot(2, 4, [1,2]);
imshow(image);
title('Before BnB');
hold on;
plot(points(:, 1), points(:, 2), '.', 'Color', 'c', 'MarkerSize', 12);
hold off;

subplot(2, 4, [3,4]);
imshow(image);
title('After BnB');
hold on;
plot(inliers(:,1), inliers(:,2), '.', 'Color', 'g', 'MarkerSize', 12);
plot(outliers(:,1), outliers(:,2), '.', 'Color', 'r', 'MarkerSize', 12);
viscircles([result{3}(1), result{4}(1)], circleRad, 'Color', 'b');
hold off;

subplot(2, 4, [6,7]);
hold on;
plot(upperBoundList, '-', 'Color', 'r');
plot(upperBoundList, '.', 'Color', 'r','MarkerSize', 12);
plot(lowerBoundList, '-', 'Color', 'b');
plot(lowerBoundList, '.', 'Color', 'b','MarkerSize', 12);
title('Convergence of bounds');
hold off;