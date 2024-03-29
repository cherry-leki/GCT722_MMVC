function [ weight ] = calWeight( v, sourceCP, alpha )
% Calculate weight vectors for each pixels.
sourceCPLen = size(sourceCP, 1);

% w = 1 / |p - v|^2��
weight = zeros(size(v, 1), sourceCPLen);
for itr=1:sourceCPLen
    dist_x = sourceCP(itr, 1) - v(:,1);
    dist_y = sourceCP(itr, 2) - v(:,2);
    weight(:, itr) = 1./ sqrt(dist_x.^2 + dist_y.^2).^(2 * alpha);
end
weight(weight==inf) = 1;    % for the case of sourceCP == v coordinates

end

