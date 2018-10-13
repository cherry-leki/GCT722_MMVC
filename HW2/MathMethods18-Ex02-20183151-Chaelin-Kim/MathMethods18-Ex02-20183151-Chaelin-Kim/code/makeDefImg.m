function [ defImg ] = makeDefImg( originImg, vLen, numOfColorChannels, defCoord )
%MAKEDEFIMG �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
[rows, columns, ~] = size(originImg);
[X, Y] = meshgrid(1:columns, 1:rows);
reshapeImg = reshape(originImg, vLen, numOfColorChannels);

defImg = uint8(zeros(rows, columns, numberOfColorChannels));
defImg(:,:,1) = uint8(griddata(defCoord(:,1), defCoord(:,2), double(reshapeImg(:,1)), X, Y));
defImg(:,:,2) = uint8(griddata(defCoord(:,1), defCoord(:,2), double(reshapeImg(:,2)), X, Y));
defImg(:,:,3) = uint8(griddata(defCoord(:,1), defCoord(:,2), double(reshapeImg(:,3)), X, Y));
end

