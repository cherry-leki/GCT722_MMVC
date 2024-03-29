function [ resultHat ] = calHat( vLength, controlPoint, cpStar )
% Calculate control point star value
%   vLength = (x, y) points length
%   cpLength = control point length
cpLength = size(controlPoint, 1);

% cpHat = controlPoint - cpStar
cpHat = zeros(vLength, 2, cpLength);
for itr=1:cpLength
    cpHat(:,1,itr) = controlPoint(itr, 1) - cpStar(:,1);
    cpHat(:,2,itr) = controlPoint(itr, 2) - cpStar(:,2);
end

resultHat = cpHat;
end


