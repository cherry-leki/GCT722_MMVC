function [ similarityDef ] = doSimilarityDeform( weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat )
% Similarity transformations are a special subset of affine transformations
% that only include translation, rotation and uniform scaling.
%   To alter our deformation technique to only use similarity transformations,
%   we constrain the matrix M to have the property that
%   MTM =(ル^2)I for some scalar ル.
% => Similarity transformation: translation, rotation, uniform scaling
%                               (no shear and non-uniform scaling)

% Calculate length
vLen = size(v,1);
sourceCPLen = size(sourceCP,1);
targetCPLen = size(targetCP,1);

% Compute fs(v) = sum(qhat * (1/レs * A)) + qstar
% -> Precompute A = w * [phat; -phat_perp] * [(v - pstar); -(v - pstar)_perp]T

% 1. Make [phat; -phat_perp]
%	Calculate phat_perp
phat_perp = [-phat(:,2,:), phat(:,1,:)];
%	Make [phat; -phat_perp] matrix [(x, y); (y, -x)]
phatMat = zeros(2, 2, vLen, sourceCPLen);
for itr=1:vLen
    phatMat(:,:,itr,:) = [phat(itr,:,:); -phat_perp(itr,:,:)];
end

% 2. Make [(v - pstar); -(v - pstar)_perp]
%   Calculate v-pstar & (v-pstar)_perp
vSubpstar = v - pstar;
vSubpstar_perp = [-vSubpstar(:,2) vSubpstar(:,1)];
%   Make [(v - pstar); -(v - pstar)_perp] matrix 
vSubpstarMat = zeros(2, 2, vLen);
for itr=1:vLen
    vSubpstarMat(:,:,itr) = [vSubpstar(itr,:); -vSubpstar_perp(itr,:)];
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
        A(:,:,itr2,itr) = weight(itr2, itr).* phatMat(:,:,itr2,itr) * vSubpstarMat(:,:,itr2)';
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

% fs(v) = sum(qhat * (1/レs * A)) + qstar
similarityDef = [sum(qhatinvmyuA(:,1,:), 3) + qstar(:,1), sum(qhatinvmyuA(:,2,:), 3) + qstar(:,2)];

% % Backward Warping
% qhat_perp = [-qhat(:,2,:), qhat(:,1,:)];
% qhatTMat = zeros(2, 2, vLen, sourceCPLen);
% for itr=1:sourceCPLen
%     for itr2=1:vLen
%         qhatTMat(:,:,itr2,itr) = [qhat(itr2,:,itr)', -qhat_perp(itr2,:,itr)'];
%     end
% end
% 
% wphatMatqhatMat = zeros(2, 2, vLen, sourceCPLen);
% for itr=1:sourceCPLen
%     for itr2=1:vLen
%         wphatMatqhatMat(:, :, itr2, itr) = ...
%             weight(itr2,itr) * phatMat(:,:,itr2,itr) * qhatTMat(:,:,itr2,itr);
%     end
% end
% 
% wphatvecTqhatvecSum = sum(wphatMatqhatMat, 4);
% 
% M = zeros(2, 2, vLen);
% b_similarityDef = zeros(vLen, 2);
% for itr=1:vLen
%     M(:,:,itr) = (1./myu(itr)) * wphatvecTqhatvecSum(:,:,itr);
%     b_similarityDef(itr,:) = (v(itr,:) - qstar(itr,:)) * inv(M(:,:,itr)) + pstar(itr,:);
% end

end

