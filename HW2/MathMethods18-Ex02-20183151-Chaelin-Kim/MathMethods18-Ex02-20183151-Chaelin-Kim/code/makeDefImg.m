function [defImg] = makeDefImg( originImg, defCoord )
% Deform the image with deformed coordinates
[rows, columns, numOfColorChannels] = size(originImg);
[X, Y] = meshgrid(1:columns, 1:rows);

% reshape the image because defCoord is the list of [x, y]
% -> size: ((row * columns)x2)
reshapeImg = reshape(originImg, rows*columns, numOfColorChannels);

% No interpolation
defImg = zeros(size(reshapeImg));
for itr=1:size(reshapeImg,1)
    x = round(defCoord(itr,1));
    y = round(defCoord(itr,2));

    if x <= 0, x = 1; end
    if y <= 0, y = 1; end
    if x >= columns, x = columns; end
    if y >= rows,    y = rows;    end

    defImg((x-1) * rows + y, :) = reshapeImg(itr, :);
end

defImg = uint8(reshape(defImg, rows, columns, numOfColorChannels));

end

