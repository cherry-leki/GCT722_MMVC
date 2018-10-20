function [ defImg ] = makeDefImgBack( originImg, bDefCoord )
% Deform the image with deformed coordinates
[rows, columns, numOfColorChannels] = size(originImg);
[X, Y] = meshgrid(1:columns, 1:rows);
v = reshape([X Y], [], 2);

% reshape the image because defCoord is the list of [x, y]
% -> size: ((row * columns)x2)
reshapeImg = reshape(originImg, rows*columns, numOfColorChannels);

% Deform the image using griddata for interpolation
bDefCoord_x = reshape(bDefCoord(:,1), rows, columns);
bDefCoord_y = reshape(bDefCoord(:,2), rows, columns);
defImg = uint8(zeros(rows, columns, numOfColorChannels));
for itr = 1:numOfColorChannels
    defImg(:,:,itr) = uint8(griddata(v(:,1), v(:,2), double(reshapeImg(:,itr)), bDefCoord_x, bDefCoord_y, 'cubic'));
end


% No interpolation
% defImg = zeros(size(reshapeImg));
% for itr=1:size(reshapeImg,1)
%     x = round(bDefCoord(itr,1));
%     y = round(bDefCoord(itr,2));
%     
%     if x <= 0, x = 1; end
%     if y <= 0, y = 1; end
%     if x >= columns, x = columns; end
%     if y >= rows,    y = rows;    end
%     
%     defImg(itr, :) = reshapeImg((x-1) * rows + y, :);
% end
% defImg = uint8(reshape(defImg, rows, columns, numOfColorChannels));

% With interpolation
% defImg = zeros(rows*columns, numOfColorChannels);
% for itr=1:size(reshapeImg,1)
%     if (bDefCoord(itr,1) >= 1 && bDefCoord(itr,1) <= 348 && bDefCoord(itr,2) >= 1 && bDefCoord(itr,2) <= 404)
%         A = [floor(bDefCoord(itr,1)), ceil(bDefCoord(itr,2))];
%         B = [floor(bDefCoord(itr,1)), floor(bDefCoord(itr,2))];
%         C = [ceil(bDefCoord(itr,1)), floor(bDefCoord(itr,2))];
%         D = [ceil(bDefCoord(itr,1)), ceil(bDefCoord(itr,2))];
%         h1 = abs(bDefCoord(itr,2) - A(2));
%         h2 = abs(bDefCoord(itr,2) - B(2));
%         w1 = abs(bDefCoord(itr,1) - B(1));
%         w2 = abs(bDefCoord(itr,1) - C(1));
% 
%         a = h1 / (h1 + h2);
%         b = h2 / (h1 + h2);
%         p = w1 / (w1 + w2);
%         q = w2 / (w1 + w2);
%         
%         temp = (q.*b.*originImg(A(2),A(1),:)) + (q.*a.*originImg(B(2),B(1),:)) + ...
%                             (p.*b.*originImg(D(2),D(1),:)) + (p.*a.*originImg(C(2),C(1),:));
%         defImg(itr, :) = temp;
%     else
%         defImg(itr, :) = [255, 255, 255];
%     end
% end
% defImg = uint8(reshape(defImg, rows, columns, numOfColorChannels));

end

