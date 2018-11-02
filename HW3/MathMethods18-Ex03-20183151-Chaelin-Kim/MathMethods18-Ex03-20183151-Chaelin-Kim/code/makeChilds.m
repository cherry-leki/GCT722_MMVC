function [ firstChild, secondChild ] = makeChilds( currentSpace, circleRad, points )
%DOBNB �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ

if (currentSpace{3}(2) - currentSpace{3}(1)) >= (currentSpace{4}(2) - currentSpace{4}(1))
    halfRangeX = (currentSpace{3}(2) - currentSpace{3}(1)) / 2;
    firstChildSpace = {[currentSpace{3}(1), currentSpace{3}(1) + halfRangeX], [currentSpace{4}(1), currentSpace{4}(2)]};
    [fcLowerBound, fcUpperBound, ~, ~] = calBounds(firstChildSpace, circleRad, points);
    firstChild = [fcLowerBound, fcUpperBound, firstChildSpace];
    
    secondChildSpace = {[currentSpace{3}(1) + halfRangeX, currentSpace{3}(2)], [currentSpace{4}(1), currentSpace{4}(2)]};
    [scLowerBound, scUpperBound, ~, ~] = calBounds(secondChildSpace, circleRad, points);
    secondChild = [scLowerBound, scUpperBound, secondChildSpace];
else
    halfRangeY = (currentSpace{4}(2) - currentSpace{4}(1)) / 2;
    firstChildSpace = {[currentSpace{3}(1), currentSpace{3}(2)], [currentSpace{4}(1), currentSpace{4}(1) + halfRangeY]};
    [fcLowerBound, fcUpperBound, ~, ~] = calBounds(firstChildSpace, circleRad, points);
    firstChild = [fcLowerBound, fcUpperBound, firstChildSpace];
    
    secondChildSpace = {[currentSpace{3}(1), currentSpace{3}(2)], [currentSpace{4}(1) + halfRangeY, currentSpace{4}(2)]};
    [scLowerBound, scUpperBound, ~, ~] = calBounds(secondChildSpace, circleRad, points);
    secondChild = [scLowerBound, scUpperBound, secondChildSpace];
end

end

