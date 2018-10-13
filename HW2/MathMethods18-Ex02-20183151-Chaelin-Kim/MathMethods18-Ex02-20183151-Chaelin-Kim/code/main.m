clear;

%% Initial Setting
ginger = imread('../materials/ginger.png');

[rows, columns, numberOfColorChannels] = size(ginger);

sourceCP = [[166, 55]; [40, 157]; [175, 185]; [270, 157]; [335, 157]; ...
            [181, 262]; [118, 369]; [252, 369]];
targetCP = [[166, 55]; [8, 268]; [175, 185]; [271, 111]; [338, 57]; ...
            [160, 266]; [147, 369]; [272, 369]];

[X, Y] = meshgrid(1:columns, 1:rows);

v = reshape([X Y], [], 2);
vLen = size(v,1);

weightAlpha = 1.1;

%% Calculate weight, star, hat
% Calculate weight
weight = calWeight(v, sourceCP, weightAlpha);

% Calculate pstar & phat
pstar = calStar(weight, vLen, sourceCP);
phat = calHat(vLen, sourceCP, pstar);
 
% Calculate qstar & qhat
qstar = calStar(weight, vLen, targetCP);
qhat = calHat(vLen, targetCP, qstar);

%% Affine Transformation
affineDeformCoord = doAffineDeform(weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat);

reshapeGinger = reshape(ginger, size(v, 1), numberOfColorChannels);
affineImg = uint8(zeros(rows, columns, numberOfColorChannels));
affineImg(:,:,1) = uint8(griddata(affineDeformCoord(:,1), affineDeformCoord(:,2), double(reshapeGinger(:,1)), X, Y));
affineImg(:,:,2) = uint8(griddata(affineDeformCoord(:,1), affineDeformCoord(:,2), double(reshapeGinger(:,2)), X, Y));
affineImg(:,:,3) = uint8(griddata(affineDeformCoord(:,1), affineDeformCoord(:,2), double(reshapeGinger(:,3)), X, Y));

%% Similarity Transformation
similarityCoord = doSimilarityDeform(weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat);

similarityImg = uint8(zeros(rows, columns, numberOfColorChannels));
similarityImg(:,:,1) = uint8(griddata(similarityCoord(:,1), similarityCoord(:,2), double(reshapeGinger(:,1)), X, Y));
similarityImg(:,:,2) = uint8(griddata(similarityCoord(:,1), similarityCoord(:,2), double(reshapeGinger(:,2)), X, Y));
similarityImg(:,:,3) = uint8(griddata(similarityCoord(:,1), similarityCoord(:,2), double(reshapeGinger(:,3)), X, Y));

%% Rigid Transformation
phat_ortho = [-phat(:,2,:), phat(:,1,:)];


%% Show the original image and result images
% figure('units','pixels','pos',[100 100 ((columns * 2) + 30) ((rows * 2) + 30)])
subplot(2, 2, 1);
imshow(ginger)
title('Original Image')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 2, 2);
imshow(affineImg)
title('Affine Transform')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 2, 3);
imshow(similarityImg)
title('Similarity Transform')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;


% Select some input and output control points
% [sourceCP_x, sourceCP_y] = ginput(8);
% plot(sourceCP_x, sourceCP_y, 'o')
% [targetCP_x, targetCP_y] = ginput(8);
% plot(targetCP_x, targetCP_y, 'x')
%% subplot
% subplot(2, 2, 3);
% imshow(ginger)
% title('Similarity Transform')
% subplot(2, 2, 4);
% imshow(ginger)
% title('Rigid Transform')