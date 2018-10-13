function [ similarityDef ] = doSimilarityDeform( weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat )
% Similarity transformations are a special subset of affine transformations
% that only include translation, rotation and uniform scaling.
%   To alter our deformation technique to only use similarity transformations,
%   we constrain the matrix M to have the property that
%   MTM =(¥ë^2)I for some scalar ¥ë.

% Calculate length
vLen = size(v,1);
sourceCPLen = size(sourceCP, 1);
targetCPLen = size(targetCP, 1);

% Compute fs(v) = sum(qhat * (1/¥ìs * A)) + qstar
% -> Precompute A = w * ¦¢ phat      ¦¢¦¢ (v - pstar)      ¦¢T
%                       ¦¢-phat_ortho¦¢¦¢-(v - pstar)_ortho¦¢

% 1. Calculate vector (phat -phat_ortho)

end

