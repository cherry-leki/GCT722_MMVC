function [ similarityDef ] = doSimilarityDeform( weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat )
% Similarity transformations are a special subset of affine transformations
% that only include translation, rotation and uniform scaling.
%   To alter our deformation technique to only use similarity transformations,
%   we constrain the matrix M to have the property that
%   MTM =(¥ë^2)I for some scalar ¥ë.

% Compute fs(v) = sum(qhat * (1/¥ìs * A)) + qstar
% -> Precompute A = 
end

