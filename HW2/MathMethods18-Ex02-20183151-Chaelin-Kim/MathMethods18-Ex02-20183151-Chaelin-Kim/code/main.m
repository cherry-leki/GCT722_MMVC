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
figure('units','pixels','pos',[100 100 ((columns * 4) + 30) ((rows * 2) + 30)])
subplot(2, 4, [1,5]);
imshow(srcImg)
title('Original Image')
hold on;
% sourceCP = ginput;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
% targetCP = ginput(size(sourceCP, 1));
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

%% Calculate weight, star, hat
% Calculate weight for forward warping
weight = calWeight(v, sourceCP, weightAlpha);

% Calculate pstar & phat for forward warping
pstar = calStar(weight, vLen, sourceCP);
phat = calHat(vLen, sourceCP, pstar);
 
% Calculate qstar & qhat for forward warping
qstar = calStar(weight, vLen, targetCP);
qhat = calHat(vLen, targetCP, qstar);

% Calculate weight for backward warping
weight_b = calWeight(v, targetCP, weightAlpha);

% Calculate pstar & phat for back warping
pstar_b = calStar(weight_b, vLen, targetCP);
phat_b = calHat(vLen, targetCP, pstar_b);
 
% Calculate qstar & qhat for back warping
qstar_b = calStar(weight_b, vLen, sourceCP);
qhat_b = calHat(vLen, sourceCP, qstar_b);

%% Affine Transformation
affineDefCoord = doAffineDeform(weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat);
affineDefCoord_b = doAffineDeform(weight_b, v, targetCP, sourceCP, pstar_b, phat_b, qstar_b, qhat_b);
affineImg = makeDefImg(srcImg, affineDefCoord);
affineImg_b = makeDefImgBack(srcImg, affineDefCoord_b);

%% Similarity Transformation
similarityDefCoord = doSimilarityDeform(weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat);
similarityDefCoord_b = doSimilarityDeform(weight_b, v, targetCP, sourceCP, pstar_b, phat_b, qstar_b, qhat_b);
similarityImg = makeDefImg(srcImg, similarityDefCoord);
similarityImg_b = makeDefImgBack(srcImg, similarityDefCoord_b);

%% Rigid Transformation
rigidDefCoord = doRigidDeform(weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat);
rigidDefCoord_b = doRigidDeform(weight_b, v, targetCP, sourceCP, pstar_b, phat_b, qstar_b, qhat_b);
rigidImg = makeDefImg(srcImg, rigidDefCoord);
rigidImg_b = makeDefImgBack(srcImg, rigidDefCoord_b);

%% Show result images
subplot(2, 4, 2);
imshow(affineImg)
title('Affine Transform(Forward Warping)')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 4, 6);
imshow(affineImg_b)
title('Affine Transform(Backward Warping)')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 4, 3);
imshow(similarityImg)
title('Similarity Transform(Forward Warping)')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 4, 7);
imshow(similarityImg_b)
title('Similarity Transform(Backward Warping)')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 4, 4);
imshow(rigidImg)
title('Rigid Transform(Forward Warping)')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;

subplot(2, 4, 8);
imshow(rigidImg_b)
title('Rigid Transform(Backward Warping)')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')
hold off;


% imwrite(affineImg, '../materials/affineVer.png');
% imwrite(similarityImg, '../materials/similarityVer.png');
% imwrite(rigidImg, '../materials/rigidVer.png');