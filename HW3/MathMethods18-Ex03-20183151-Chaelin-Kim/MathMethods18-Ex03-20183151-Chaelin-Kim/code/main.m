clc;
clear;

%% Initial Setting
% Load the data
srcData = load('../data/InputData.mat');
circleRad = srcData.CircleRadius;
image = srcData.I;
points = srcData.ListInputPoints;

% Set the first lower bound and upper bound
lowerBound = 0;
upperBound = 200;

% Initialize lower bound list and upper bound list
% The list is updated at every iteration
lowerBoundList = lowerBound;
upperBoundList = upperBound;

% Set the whole space to the list
% w = 1104, h = 549 -> [1, 1104], [1, 549]
spaceList = {lowerBound, upperBound, [1, size(image, 2)], [1, size(image, 1)]};

% Initialize the antenna location maximizing the consensus set
finalSpace = [];

%% Branch and Bound
while 1
    % Take the best candidate in the list
    currentSpace = spaceList(1,:);

    % Split the space into two children and put them into the list
    % The cardinality bounds are computed in makeChilds function
    [spaceList(end+1,:), spaceList(end+1,:)] = makeChilds(currentSpace, circleRad, points);

    % Remove the best candidate from the list
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
        
    % Put the upper and lower bounds into the upperBoundList and
    % lowerBoundList for display.
    upperBoundList = [upperBoundList, upperBound];
    lowerBoundList = [lowerBoundList, lowerBound]; 
    
    % Remove all the elements in the list with a "bad" bound.
    % Current "lowerBound" is the highest lower bound of the number of inliers obtained so far.
    % If the upper bound of a space is less than "lowerBound", it can be removed.
    for itr=1:size(spaceList, 1)
        if itr >= size(spaceList, 1)
            break;
        end
        
        if lowerBound > spaceList{itr, 2}
            spaceList(itr, :) = [];
            itr = itr - 1;
        end        
    end
    
    % The iterations stop when the lower and upper bound are nearer than 1,
    % because they will lead to the same number of inliers
    if (spaceList{1, 2} == upperBound && spaceList{1, 1} == lowerBound) && ...
        (upperBound - lowerBound < 1)
        finalSpace = spaceList(1, :);
        break;
    end
end

%% Compute inliers points and outliers points in the final antenna location
[~,~,lowerInliersIndex, upperInlierIndex] = calBounds(finalSpace(3:4), circleRad, points);

inliers = [];
outliers = [];
outlierIndices = [];
step = 1;
for itr=1:size(points, 1)
    if itr == lowerInliersIndex(step)
        inliers = [inliers; points(itr, :)];
        step = step + 1;
    else
        outliers = [outliers; points(itr, :)];
        outlierIndices = [outlierIndices; itr];
    end
end

%% Show result image
% The image before the BNB
subplot(2,2,1);
imshow(image);
title('\fontsize{16} \bf Before BnB');
hold on;
plot(points(:, 1), points(:, 2), '.', 'Color', 'c', 'MarkerSize', 12);
hold off;

% The image after the BNB
subplot(2,2,3);
imshow(image);
title('\fontsize{16} \bf After BnB');
hold on;
plot(inliers(:,1), inliers(:,2), '.', 'Color', 'g', 'MarkerSize', 12);
plot(outliers(:,1), outliers(:,2), '.', 'Color', 'r', 'MarkerSize', 12);
viscircles([finalSpace{3}(1), finalSpace{4}(1)], circleRad, 'Color', 'b');
hold off;

% The graph of evolution of the lower and upper bounds of the number of
% inliers along the BNB iterations
subplot(2,2,2);
hold on;
grid on;
plot(upperBoundList, '.-', 'Color', 'r', 'MarkerSize', 12);
plot(lowerBoundList, '.-', 'Color', 'b', 'MarkerSize', 12);
title('\fontsize{16} \bf Convergence of bounds');
legend({'upper', 'lower'}, 'Location', 'southeast');
xlabel('\fontsize{12} Iterations');
ylabel('\fontsize{12} Upper and lower bounds');
hold off;