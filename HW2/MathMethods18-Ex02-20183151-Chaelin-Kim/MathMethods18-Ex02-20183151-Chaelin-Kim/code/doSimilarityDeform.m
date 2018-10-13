function [ similarityDef ] = doSimilarityDeform( weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat )
% Similarity transformations are a special subset of affine transformations
% that only include translation, rotation and uniform scaling.
%   To alter our deformation technique to only use similarity transformations,
%   we constrain the matrix M to have the property that
%   MTM =(¥ë^2)I for some scalar ¥ë.

% Calculate length
vLen = size(v,1);
sourceCPLen = size(sourceCP,1);
targetCPLen = size(targetCP,1);

% Compute fs(v) = sum(qhat * (1/¥ìs * A)) + qstar
% -> Precompute A = w * [phat; -phat_ortho] * [(v - pstar); -(v - pstar)_ortho]T

% 1. Make [phat; -phat_ortho]
%	Calculate phat_ortho
phat_ortho = [-phat(:,2,:), phat(:,1,:)];
%	Make [phat; -phat_ortho] matrix [(x, y); (y, -x)]
pMat = zeros(2, 2, vLen, sourceCPLen);
for itr=1:vLen
    pMat(:,:,itr,:) = [phat(itr,:,:); -phat_ortho(itr,:,:)];
end

% 2. Make [(v - pstar); -(v - pstar)_ortho]
%   Calculate v-pstar & (v-pstar)_ortho
vSubpstar = v - pstar;
vSubpstar_ortho = [-vSubpstar(:,2) vSubpstar(:,1)];
%   Make [(v - pstar); -(v - pstar)_ortho] matrix 
vSubpstarMat = zeros(2, 2, vLen);
for itr=1:vLen
    vSubpstarMat(:,:,itr) = [vSubpstar(itr,:); -vSubpstar_ortho(itr,:)];
end

% 3. Calculate myu = sum(weight * phat * phatT)
wphatphatT = zeros(vLen, sourceCPLen);
for itr=1:sourceCPLen
    for itr2=1:vLen
        wphatphatT(itr2,itr) = weight(itr2,itr) * phat(itr2,:,itr) * phat(itr2,:,itr)';
    end
end
myu = sum(wphatphatT, 2);

% 4. Calculate A & (1/myu) * A
A = zeros(2, 2, vLen, sourceCPLen);
invmyuA = zeros(2, 2, vLen, sourceCPLen);
for itr=1:sourceCPLen
    for itr2=1:vLen
        A(:,:,itr2,itr) = weight(itr2, itr).* pMat(:,:,itr2,itr) * vSubpstarMat(:,:,itr2)';
        invmyuA(:,:,itr2,itr) = (1/myu(itr2)).* A(:,:,itr2,itr);
    end
end

% 5. Calculate qhat * (1/myu) * A
qhatinvmyuA = zeros(vLen,2,targetCPLen);
for itr=1:targetCPLen
    for itr2=1:vLen
        qhatinvmyuA(itr2,:,itr) = qhat(itr2,:,itr) * invmyuA(:,:,itr2,itr);
    end
end

similarityDef = [sum(qhatinvmyuA(:,1,:), 3) + qstar(:,1), sum(qhatinvmyuA(:,2,:), 3) + qstar(:,2)];
end

