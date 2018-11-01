function [ lowerBound, upperBound, lowerInliers, upperInliers ] = calBounds( listValue, circleRad, points )
%DOBNB 이 함수의 요약 설명 위치
%   자세한 설명 위치
underX = listValue{1}(1);
underY = listValue{2}(1);
upperX = listValue{1}(2);
upperY = listValue{2}(2);

lowerInliers = [];
upperInliers = [];

% lower bound
x = (underX + upperX) / 2;
y = (underY + upperY) / 2;

for i=1:size(points, 1)
    if (points(i, 1) - x)^2 + (points(i, 2) - y)^2 <= circleRad^2
        lowerInliers = [lowerInliers; i];
    end
end

% upper bound
for i=1:size(points, 1)
    if points(i, 1) >= (underX - circleRad) && points(i, 1) <= (upperX + circleRad) && ...
       points(i, 2) >= (underY - circleRad) && points(i, 2) <= (upperY + circleRad)

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
        
        upperInliers = [upperInliers; i];
    end
end

lowerBound = size(lowerInliers,1);
upperBound = size(upperInliers,1);

end

