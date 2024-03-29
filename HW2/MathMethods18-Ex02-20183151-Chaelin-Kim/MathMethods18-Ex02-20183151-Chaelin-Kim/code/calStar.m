function [ resultStar ] = calStar( weight, vLength, controlPoint )
% Calculate control point star value
%  weight size = vLength x cpLength
%   vLength = (x, y) points length
%   cpLength = control point length
cpLength = size(controlPoint, 1);

% wcp = weight * controlPoint
wcp = zeros(vLength, 2, cpLength);
for itr=1:cpLength
    wcp(:,1,itr) = weight(:,itr).*controlPoint(itr, 1);
    wcp(:,2,itr) = weight(:,itr).*controlPoint(itr, 2);
end

wcpSum = sum(wcp, 3);       % sum(weight * controlPoint)
weightSum = sum(weight,2);  % sum(weight)

% cpStar = sum(weight * controlPoint) / sum(weight)
resultStar = [wcpSum(:,1)./weightSum, wcpSum(:,2)./weightSum];

end

