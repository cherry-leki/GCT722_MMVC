function hist = getColorHistogram(I,seed, histRes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute a color histograms based on selected points from an image
% 
% INPUT
% - I       : color image
% - seed    : Nx2 matrix [x,y] containing the position of pixels which will be
%             uset to compute the color histogram
% - histRes : resolution of the histogram (the exercise sheet says bin of 32)
% 
% OUTPUT
% - hist : color histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hist = zeros(histRes,histRes,histRes); % initialize for R,G,B

% % TODO
seed_rgb = zeros(size(seed,1), 3);
for i=1:size(seed,1)
    seed_rgb(i,:) = I(seed(i,2), seed(i,1), :);
end

numColorValue = 256;
step = numColorValue / histRes;
rgb_Intens = zeros(size(seed,1), 3, histRes);
for i=1:histRes
    rgb_Intens(:,1,i) = seed_rgb(:,1) >= step * (i-1) & seed_rgb(:,1) < step * i;
    rgb_Intens(:,2,i) = seed_rgb(:,2) >= step * (i-1) & seed_rgb(:,2) < step * i;
    rgb_Intens(:,3,i) = seed_rgb(:,3) >= step * (i-1) & seed_rgb(:,3) < step * i;
end

% Create the histogram
for r=1:histRes
    for g=1:histRes
        for b=1:histRes
            hist(r,g,b) = nnz(rgb_Intens(:,1,r) & ...
                              rgb_Intens(:,2,g) & ...
                              rgb_Intens(:,3,b));
        end
    end
end

% Smooth the histogram
hist = smooth3(hist,'gaussian',7);

% Normalize the histogram
histSum = sum(sum(sum(hist)));
hist = hist./histSum;

% Fill empty entries
hist(hist == 0) = 10^(-10);

% Applyting the logarithm to the histogram
hist = -log(hist);

