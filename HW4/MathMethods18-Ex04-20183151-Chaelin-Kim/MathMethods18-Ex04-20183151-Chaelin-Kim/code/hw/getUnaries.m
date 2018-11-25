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
rows = size(I, 1);
cols = size(I, 2);
N = rows * cols;

img_rgb = zeros(N, 3);
for j=1:cols
    for i=1:rows
        img_rgb((j - 1) * rows + i,:) = I(i, j, :);
    end
end

histRes = 32;
numColorValue = 256;
step = numColorValue / histRes;

% rgbIntens = zeros(N, 3);
% for i=1:histRes
%     index_r = img_rgb(:,1) >= step * (i-1) & img_rgb(:,1) < step * i;
%     index_g = img_rgb(:,2) >= step * (i-1) & img_rgb(:,2) < step * i;
%     index_b = img_rgb(:,3) >= step * (i-1) & img_rgb(:,3) < step * i;
%     rgbIntens(index_r,1) = i;
%     rgbIntens(index_g,2) = i;
%     rgbIntens(index_b,3) = i;
% end

unaries = zeros(N, 2);

for j=1:cols
    for i=1:rows
        index = (j - 1) * rows + i;
%         hist_fgValue = hist_fg(rgbIntens(index,1), rgbIntens(index,2), rgbIntens(index,3));
%         hist_bgValue = hist_bg(rgbIntens(index,1), rgbIntens(index,2), rgbIntens(index,3));
        r = fix(img_rgb(index, 1) / step) + 1;
        g = fix(img_rgb(index, 2) / step) + 1;
        b = fix(img_rgb(index, 3) / step) + 1;
        hist_fgValue = hist_fg(r, g, b);
        hist_bgValue = hist_bg(r, g, b);
        unaries(index, 1) = lambda * (-log(hist_fgValue + 10^(-10)));
        unaries(index, 2) = lambda * (-log(hist_bgValue + 10^(-10)));
    end
end

for i=1:size(seed_fg,1)
    index = (seed_fg(:,1) - 1).* rows + seed_fg(:,2);
    unaries(index, 1) = 0;
    unaries(index, 2) = inf;
end

for i=1:size(seed_bg,1)
    index = (seed_bg(:,1) - 1).* rows + seed_bg(:,2);
    unaries(index,1) = inf;
    unaries(index,2) = 0;
end

% idx_fg = (seed_fg(:,1) - 1).* rows + seed_fg(:,2);
% idx_bg = (seed_bg(:,1) - 1).* rows + seed_bg(:,2);
% unaries(idx_fg,1) = 0;
% unaries(idx_fg,2) = inf;
% unaries(idx_bg,1) = inf;
% unaries(idx_bg,2) = 0;

% unaries = lambda.*unaries;

return