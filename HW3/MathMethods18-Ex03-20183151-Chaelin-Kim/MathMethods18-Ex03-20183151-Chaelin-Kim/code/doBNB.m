function [ firstChild, secondChild ] = doBNB( currentSpace, circleRad, points )
%DOBNB 이 함수의 요약 설명 위치
%   자세한 설명 위치

if (currentSpace{3}(2) - currentSpace{3}(1)) >= (currentSpace{4}(2) - currentSpace{4}(1))
    halfRangeX = (currentSpace{3}(2) - currentSpace{3}(1)) / 2;
    firstChildSpace = {[currentSpace{3}(1), currentSpace{3}(1) + halfRangeX], [currentSpace{4}(1), currentSpace{4}(2)]};
    [fcLowerBound, fcUpperBound, ~, ~] = calBounds(firstChildSpace, circleRad, points);
    
    if fcLowerBound <= currentSpace{1}
        fcLowerBound = currentSpace{1};
    end
    firstChild = [fcLowerBound, fcUpperBound, firstChildSpace];
    
    secondChildSpace = {[currentSpace{3}(1) + halfRangeX, currentSpace{3}(2)], [currentSpace{4}(1), currentSpace{4}(2)]};
    [scLowerBound, scUpperBound, ~, ~] = calBounds(secondChildSpace, circleRad, points);
    
    if scLowerBound <= currentSpace{1}
        scLowerBound = currentSpace{1};
    end
    secondChild = [scLowerBound, scUpperBound, secondChildSpace];
else
    halfRangeY = (currentSpace{4}(2) - currentSpace{4}(1)) / 2;
    firstChildSpace = {[currentSpace{3}(1), currentSpace{3}(2)], [currentSpace{4}(1), currentSpace{4}(1) + halfRangeY]};
    [fcLowerBound, fcUpperBound, ~, ~] = calBounds(firstChildSpace, circleRad, points);
    if fcLowerBound <= currentSpace{1}
        fcLowerBound = currentSpace{1};
    end
    firstChild = [fcLowerBound, fcUpperBound, firstChildSpace];
    
    secondChildSpace = {[currentSpace{3}(1), currentSpace{3}(2)], [currentSpace{4}(1) + halfRangeY, currentSpace{4}(2)]};
    [scLowerBound, scUpperBound, ~, ~] = calBounds(secondChildSpace, circleRad, points);
    if scLowerBound <= currentSpace{1}
        scLowerBound = currentSpace{1};
    end
    secondChild = [scLowerBound, scUpperBound, secondChildSpace];
end

end

