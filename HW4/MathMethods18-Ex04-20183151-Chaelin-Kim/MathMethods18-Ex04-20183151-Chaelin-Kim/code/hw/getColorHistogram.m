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
% Resolution of 32 for the color histogram
numColorValue = 256;
step = numColorValue / histRes;
seed_rgb = zeros(size(seed,1), 3);
% Create the histogram
for i=1:size(seed,1)
    % Get the rgb data of seed from image
    seed_rgb(i,:) = I(seed(i,2), seed(i,1), :);
    
    r = fix(seed_rgb(i,1) / step) + 1;
    g = fix(seed_rgb(i,2) / step) + 1;
    b = fix(seed_rgb(i,3) / step) + 1;
    
    hist(r, g, b) = hist(r, g, b) + 1;
end


% rgbIntens = zeros(size(seed,1), 3, histRes);
% for i=1:histRes
%     rgbIntens(:,1,i) = seed_rgb(:,1) >= step * (i-1) & seed_rgb(:,1) < step * i;
%     rgbIntens(:,2,i) = seed_rgb(:,2) >= step * (i-1) & seed_rgb(:,2) < step * i;
%     rgbIntens(:,3,i) = seed_rgb(:,3) >= step * (i-1) & seed_rgb(:,3) < step * i;
% end
% 
% % Create the histogram
% for r=1:histRes
%     for g=1:histRes
%         for b=1:histRes
%             hist(r,g,b) = nnz(rgbIntens(:,1,r) & ...
%                               rgbIntens(:,2,g) & ...
%                               rgbIntens(:,3,b));
%         end
%     end
% end

% Smooth the histogram
hist = smooth3(hist,'gaussian',7,std(hist(:)));

% Normalize the histogram
histSum = sum(hist(:));
hist = hist./histSum;

return
