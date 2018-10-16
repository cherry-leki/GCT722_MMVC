function [ defImg ] = makeDefImgBack( originImg, bDefCoord )
% Deform the image with deformed coordinates
[rows, columns, numOfColorChannels] = size(originImg);
[X, Y] = meshgrid(1:columns, 1:rows);
v = reshape([X Y], [], 2);

% reshape the image because defCoord is the list of [x, y]
% -> size: ((row * columns)x2)
reshapeImg = reshape(originImg, rows*columns, numOfColorChannels);

% Deform the image
% Use griddata to find the new values of the new transformed coordinates
% Color channel: Red(1), Green(2), Blue(3)
bDefCoord_x = reshape(bDefCoord(:,1), rows, columns);
bDefCoord_y = reshape(bDefCoord(:,2), rows, columns);
defImg = uint8(zeros(rows, columns, numOfColorChannels));
for itr = 1:numOfColorChannels
    defImg(:,:,itr) = uint8(griddata(v(:,1), v(:,2), double(reshapeImg(:,itr)), bDefCoord_x, bDefCoord_y));
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

end

