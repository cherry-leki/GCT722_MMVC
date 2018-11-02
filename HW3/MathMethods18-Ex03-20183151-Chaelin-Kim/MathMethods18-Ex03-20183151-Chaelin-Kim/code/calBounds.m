function [ lowerBound, upperBound, lowerInliers, upperInliers ] = calBounds( listValue, circleRad, points )
% calBounds: compute cardinality bounds

% Set the lower and upper range of model.
underX = listValue{1}(1);
underY = listValue{2}(1);
upperX = listValue{1}(2);
upperY = listValue{2}(2);

% Initialize the list that contain the indexes of inlier points.
lowerInliers = [];
upperInliers = [];

% Compute the lower cardinality bound
% by testing the model at the center in the current space.
x = (underX + upperX) / 2;
y = (underY + upperY) / 2;

% If the point is located in the model of lower bound, put the index of
% point into lowerInliers list
for i=1:size(points, 1)
    if (points(i, 1) - x)^2 + (points(i, 2) - y)^2 <= circleRad^2
        lowerInliers = [lowerInliers; i];
    end
end


% Compute the upper cardinality bound
% by testing an "extended shape" corresponding to the union of all the antenna coverages in the current space.
for i=1:size(points, 1)
    % Test in the range of the current space plus circleRad
    % [(underX - circleRad, upperX + circleRad), (underY - circleRad, uperY + circleRad)]
    if points(i, 1) >= (underX - circleRad) && points(i, 1) <= (upperX + circleRad) && ...
       points(i, 2) >= (underY - circleRad) && points(i, 2) <= (upperY + circleRad)

        % Except the point that is not in the range of four circles that
        % the center is the edge of original current space
        % left upper circle
        if points(i, 1) >= (underX - circleRad) && points(i, 1) <= underX && ...
           points(i, 2) >= (underY - circleRad) && points(i, 2) <= underY
            if (points(i, 1) - underX)^2 + (points(i, 2) - underY)^2 >= circleRad^2
                continue;
            end
        end
        % right upper circle
        if points(i, 1) >= upperX               && points(i, 1) <= (upperX + circleRad) && ...
           points(i, 2) >= (underY - circleRad) && points(i, 2) <= underY
            if (points(i, 1) - upperX)^2 + (points(i, 2) - underY)^2 >= circleRad^2
                continue;
            end
        end
        % left lower circle
        if points(i, 1) >= (underX - circleRad) && points(i, 1) <= underX && ...
           points(i, 2) >= upperY               && points(i, 2) <= (underY + circleRad)
            if (points(i, 1) - underX)^2 + (points(i, 2) - upperY)^2 >= circleRad^2
                continue;
            end
        end
        % right lower circle
        if points(i, 1) >= upperX               && points(i, 1) <= (upperX + circleRad) && ...
           points(i, 2) >= upperY               && points(i, 2) <= (underY + circleRad)
            if (points(i, 1) - upperX)^2 + (points(i, 2) - upperY)^2 >= circleRad^2
                continue;
            end
        end
        
        % If the point is located in the model of upper bound,
        % put the index of point into upperInliers list
        upperInliers = [upperInliers; i];
    end
end

% Compute the number of inliers (cardinality)
lowerBound = size(lowerInliers,1);
upperBound = size(upperInliers,1);

end

