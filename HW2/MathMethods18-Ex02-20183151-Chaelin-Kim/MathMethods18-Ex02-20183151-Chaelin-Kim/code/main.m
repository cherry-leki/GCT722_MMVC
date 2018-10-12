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

weight_alpha = 1;

%% Affine Transformation
% Calculate weight
% Method1
weight = zeros(rows, columns, size(sourceCP, 1));
for itr=1:size(sourceCP, 1)
    temp_x = sourceCP(itr, 1) - X;
    temp_y = sourceCP(itr, 2) - Y;
    weight(:,:,itr, 1) = 1./ sqrt(temp_x.^2 + temp_y.^2).^(2 * weight_alpha);
%     v = reshape([X Y], [], 2);
%     weightNorm = zeros(size(v));
%     for itr2=1:size(v, 1)
%         weightNorm(itr2) = 1./ norm(sourceCP(itr,:) - v(itr2, :), 2 * weight_alpha);
%     end
%     weight(:,:,itr) = reshape(weightNorm(:,1), [rows, columns, 1]);
end

% Calculate p_star & q_star
weightSum = sum(weight,3);

% p_star
weightp = {zeros(rows, columns, size(sourceCP, 1)), zeros(rows, columns, size(sourceCP, 1))};
for itr=1:size(sourceCP,1)
    weightp{1}(:,:,itr) = weight(:,:,itr)*sourceCP(itr, 1);
    weightp{2}(:,:,itr) = weight(:,:,itr)*sourceCP(itr, 2);
end

weightpSum = {sum(weightp{1}, 3), sum(weightp{2}, 3)};

pstar = {weightpSum{1}./weightSum, weightpSum{2}./weightSum};
 
% q_star
weightq = {zeros(rows, columns, size(targetCP, 1)), zeros(rows, columns, size(targetCP, 1))};
for itr=1:size(targetCP,1)
    weightq{1}(:,:,itr) = weight(:,:,itr)*targetCP(itr, 1);
    weightq{2}(:,:,itr) = weight(:,:,itr)*targetCP(itr, 2);
end

weightqSum = {sum(weightq{1}, 3), sum(weightq{2}, 3)};

qstar = {weightqSum{1}./weightSum, weightqSum{2}./weightSum};

% p_hat
phat = {zeros(rows, columns, size(sourceCP, 1)), zeros(rows, columns, size(sourceCP, 1))};
for itr=1:size(sourceCP, 1)
    phat{1}(:,:,itr) = sourceCP(itr, 1) - pstar{1};
    phat{2}(:,:,itr) = sourceCP(itr, 1) - pstar{2};
end

% q_hat
qhat = {zeros(rows, columns, size(targetCP, 1)), zeros(rows, columns, size(targetCP, 1))};
for itr=1:size(targetCP, 1)
    qhat{1}(:,:,itr) = targetCP(itr, 1) - qstar{1};
    qhat{2}(:,:,itr) = targetCP(itr, 1) - qstar{2};
end

% Precompute fa(v) -> compute Aj
% phat^T * w * phat
% Though this solution requires the inversion of a matrix, the matrix is a contant size (2 X 2)
phatTWphat = zeros(2, 2, rows, columns, size(sourceCP, 1));
for itr=1:size(sourceCP, 1)
    phatTw = {phat{1}(:,:,itr).*weight(:,:,itr), phat{2}(:,:,itr).*weight(:,:,itr)};
    phatTWphat_11 = phatTw{1}.*phat{1}(:,:,itr);         % xx
    phatTWphat_12 = phatTw{1}.*phat{2}(:,:,itr);         % xy
    phatTWphat_21 = phatTw{2}.*phat{1}(:,:,itr);         % yx
    phatTWphat_22 = phatTw{2}.*phat{2}(:,:,itr);         % yy
    
    phatTWphat(1, 1, :, :, itr) = phatTWphat_11;
    phatTWphat(1, 2, :, :, itr) = phatTWphat_12;
    phatTWphat(2, 1, :, :, itr) = phatTWphat_21;
    phatTWphat(2, 2, :, :, itr) = phatTWphat_22;
end

phatTWphatSum = sum(phatTWphat, 5);
invphatTWphatSum = inv(phatTWphatSum(:,:));
vSubpstar = {X - pstar{1}, Y - pstar{2}};

M = 0;
% Aj is a single scalar


%% Similarity Transformation

%% Rigid Transformation

%% Show the original image and result images
% figure('units','pixels','pos',[100 100 ((columns * 2) + 30) ((rows * 2) + 30)])
% subplot(2, 2, 1);
% image(ginger)
imshow(ginger)
title('Original Image')
hold on;
plot(sourceCP(:, 1), sourceCP(:, 2), 'o', 'Color', 'g')
plot(targetCP(:, 1), targetCP(:, 2), 'x', 'Color', 'r')

% Select some input and output control points
% [sourceCP_x, sourceCP_y] = ginput(8);
% plot(sourceCP_x, sourceCP_y, 'o')
% [targetCP_x, targetCP_y] = ginput(8);
% plot(targetCP_x, targetCP_y, 'x')
hold off;

%% subplot
% subplot(2, 2, 2);
% imshow(ginger)
% title('Affine Transform')
% subplot(2, 2, 3);
% imshow(ginger)
% title('Similarity Transform')
% subplot(2, 2, 4);
% imshow(ginger)
% title('Rigid Transform')