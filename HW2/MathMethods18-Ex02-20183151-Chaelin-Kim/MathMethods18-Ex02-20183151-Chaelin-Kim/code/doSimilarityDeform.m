function [ similarityDef ] = doSimilarityDeform( weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat )
% Similarity transformations are a special subset of affine transformations
% that only include translation, rotation and uniform scaling.
%   To alter our deformation technique to only use similarity transformations,
%   we constrain the matrix M to have the property that
%   MTM =(��^2)I for some scalar ��.

% Calculate length
vLen = size(v,1);
sourceCPLen = size(sourceCP,1);
targetCPLen = size(targetCP,1);

% Compute fs(v) = sum(qhat * (1/��s * A)) + qstar
% -> Precompute A = w * [phat; -phat_ortho] * [(v - pstar); -(v - pstar)_ortho]T

% 1. Make [phat; -phat_ortho]
%	Calculate phat_ortho
phat_ortho = zeros(size(phat));
for itr=1:sourceCPLen
    phat_ortho(:,1,itr) = -phat(:,2,itr);
    phat_ortho(:,2,itr) =  phat(:,1,itr);
end

%	Make [phat; -phat_ortho] matrix [(x, y); (y, -x)]
pMatrix = zeros(2, 2, vLen, sourceCPLen);
for itr=1:sourceCPLen
    for itr2=1:vLen
        pMatrix(1,:,itr2,itr) = phat(itr2,:,itr);
        pMatrix(2,:,itr2,itr) = -phat_ortho(itr2,:,itr);
    end
end

% 2. Make [(v - pstar); -(v - pstar)_ortho]
%   Calculate v-pstar & (v-pstar)_ortho
vSubpstar = [v(:,1)-pstar(:,1), v(:,2)-pstar(:,2)];
vSubpstar_ortho = [-vSubpstar(:,2) vSubpstar(:,1)];

%   Make [(v - pstar); -(v - pstar)_ortho] matrix 
vSubpMatrix = zeros(2, 2, vLen);
for itr=1:vLen
    vSubpMatrix(1,:,itr) = vSubpstar(itr,:);
    vSubpMatrix(2,:,itr) = -vSubpstar_ortho(itr,:);
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
        A(:,:,itr2,itr) = weight(itr2, itr).* pMatrix(:,:,itr2,itr) * vSubpMatrix(:,:,itr2)';
        invmyuA(:,:,itr2,itr) = (1/myu(itr2)).* A(:,:,itr2,itr);
    end
end

% 5. Calculate qhat * (1/myu) * A
qinvmyuA = zeros(vLen,2,targetCPLen);
for itr=1:targetCPLen
    for itr2=1:vLen
        qinvmyuA(itr2,:,itr) = qhat(itr2,:,itr) * invmyuA(:,:,itr2,itr);
    end
end

similarityDef = [sum(qinvmyuA(:,1,:), 3) + qstar(:,1), sum(qinvmyuA(:,2,:), 3) + qstar(:,2)];
end

