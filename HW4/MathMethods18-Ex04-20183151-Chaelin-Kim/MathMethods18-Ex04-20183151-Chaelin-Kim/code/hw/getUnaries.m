function unaries = getUnaries(I,lambda,hist_fg,hist_bg, seed_fg, seed_bg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Unaries for all pixels in inputImg, using the foreground and
% background color histograms, and enforcing hard constraints on pixels
% marked by the user as foreground and background
% 
% INPUT :
% - I       : color image
% - hist_fg : foreground color histogram
% - hist_bg : background color histogram
% - seed_fg : pixels marked as foreground by the user
% - seed_bg : pixels marked as background by the user
% 
% OUTPUT :
% - unaries : Nx2 (FG cost and BG cost) matrix containing the unary cost for every pixels in I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO
row = size(I, 1);
col = size(I, 2);
N = row * col;
[X, Y] = meshgrid(1:col, 1:row);

img_rgb = zeros(N, 3);
for i=1:N
    img_rgb(i,:) = I(Y(i), X(i), :);
end

histRes = 32;
numColorValue = 256;
step = numColorValue / histRes;
rgbIntens = zeros(N, 3);
for i=1:histRes
    index_r = img_rgb(:,1) >= step * (i-1) & img_rgb(:,1) < step * i;
    index_g = img_rgb(:,2) >= step * (i-1) & img_rgb(:,2) < step * i;
    index_b = img_rgb(:,3) >= step * (i-1) & img_rgb(:,3) < step * i;
    rgbIntens(index_r,1) = i;
    rgbIntens(index_g,2) = i;
    rgbIntens(index_b,3) = i;
end

unaries = zeros(N, 2);
idx_fg = (seed_fg(:,1) - 1).* row + seed_fg(:,2);
idx_bg = (seed_bg(:,1) - 1).* row + seed_bg(:,2);

for i=1:N
    if find(idx_fg == i)
        unaries(idx_fg,1) = inf;
        unaries(idx_fg,2) = 0;
    elseif find(idx_bg == i)
        unaries(idx_bg,1) = 0;
        unaries(idx_bg,2) = inf;
    else
        unaries(i, 1) = hist_fg(rgbIntens(i,1), rgbIntens(i,2), rgbIntens(i,3)) * 2;
        unaries(i, 2) = hist_bg(rgbIntens(i,1), rgbIntens(i,2), rgbIntens(i,3)) * 2;
    end
end

% Fill empty entries
unaries(unaries == 0) = 10^(-10);

% Applyting the logarithm
unaries = -log(unaries);

unaries = lambda.*unaries;