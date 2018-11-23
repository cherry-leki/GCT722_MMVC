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
disp(seed_rgb);

numColorValue = 256;
step = numColorValue / histRes;

for i=1:histRes
    
end