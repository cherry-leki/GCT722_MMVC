function [ weight ] = calWeight( v, sourceCP, alpha )
%CALWEIGHT 이 함수의 요약 설명 위치
%   자세한 설명 위치

sourceCPLen = size(sourceCP, 1);

weight = zeros(size(v, 1), sourceCPLen);
for itr=1:sourceCPLen
    dis_x = sourceCP(itr, 1) - v(:,1);
    dis_y = sourceCP(itr, 2) - v(:,2);
    weight(:, itr) = 1./ sqrt(dis_x.^2 + dis_y.^2).^(2 * alpha);
end
weight(weight==inf) = 1;

end

