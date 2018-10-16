clear;

%% Initial Setting
srcImg = imread('../materials/ginger.png');
% srcImg = imread('../materials/Pooh.jpg');

[rows, columns, numberOfColorChannels] = size(srcImg);

% Create a mesh grid for all the coordinate in the matrix
[X, Y] = meshgrid(1:columns, 1:rows);

% Make the image to pixel point list (rows x columns) x 1 
v = reshape([X Y], [], 2);
vLen = size(v,1);

weightAlpha = 1.1;

% Example Control point
sourceCP = [[166, 55]; [40, 157]; [175, 185]; [270, 157]; [335, 157]; ...
            [181, 262]; [118, 369]; [252, 369]];
targetCP = [[166, 55]; [8, 268]; [175, 185]; [271, 111]; [338, 57]; ...
            [160, 266]; [147, 369]; [272, 369]];

%% Show the original image
% Select some input and output control points
figure('units','pixels','pos',[100 100 ((columns * 2) + 30) ((rows * 2) + 30)])
subplot(2, 2, 1);
imshow(srcImg)
title('Original Image')
hold on;
% sourceCP = ginput;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
% targetCP = ginput(size(sourceCP, 1));
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

%% Calculate weight, star, hat
% Calculate weight
weight = calWeight(v, sourceCP, weightAlpha);
bWeight = calWeight(v, targetCP, weightAlpha);

% Calculate pstar & phat
pstar = calStar(weight, vLen, sourceCP);
phat = calHat(vLen, sourceCP, pstar);
 
% Calculate qstar & qhat
qstar = calStar(weight, vLen, targetCP);
qhat = calHat(vLen, targetCP, qstar);

%% Affine Transformation
[affineDefCoord,affineDefCoordBack] = doAffineDeform(weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat);
affineImg = makeDefImg(srcImg, affineDefCoord);
affineImgBack = makeDefImgBack(srcImg, affineDefCoordBack);

%% Similarity Transformation
similarityDefCoord = doSimilarityDeform(weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat);
similarityImg = makeDefImg(srcImg, similarityDefCoord);

%% Rigid Transformation
rigidDefCoord = doRigidDeform(weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat);
rigidImg = makeDefImg(srcImg, rigidDefCoord);

%% Show result images
subplot(2, 4, 3);
imshow(affineImg)
title('Affine Transform')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 4, 4);
imshow(affineImgBack)
title('Affine Transform')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 4, 5);
imshow(similarityImg)
title('Similarity Transform')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 4, 7);
imshow(rigidImg)
title('Rigid Transform')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;


% imwrite(affineImg, '../materials/affineVer.png');
% imwrite(similarityImg, '../materials/similarityVer.png');
% imwrite(rigidImg, '../materials/rigidVer.png');