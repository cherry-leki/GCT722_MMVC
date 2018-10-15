function [ defImg ] = makeDefImg( originImg, defCoord )
% Deform the image with deformed coordinates
[rows, columns, numOfColorChannels] = size(originImg);
[X, Y] = meshgrid(1:columns, 1:rows);

% reshape the image because defCoord is the list of [x, y]
% -> size: ((row * columns)x2)
reshapeImg = reshape(originImg, rows*columns, numOfColorChannels);

% Deform the image
% Use griddata to find the new values of the new transformed coordinates
% Color channel: Red(1), Green(2), Blue(3)
defImg = uint8(zeros(rows, columns, numOfColorChannels));
for itr = 1:numOfColorChannels
    defImg(:,:,itr) = uint8(griddata(defCoord(:,1), defCoord(:,2), double(reshapeImg(:,itr)), X, Y));
end

end

