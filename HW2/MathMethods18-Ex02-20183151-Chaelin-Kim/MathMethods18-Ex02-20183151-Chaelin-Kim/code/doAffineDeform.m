function [ affineDef ] = doAffineDeform( weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat )
%DOAFFINEDEFORM 이 함수의 요약 설명 위치
% lv(x) = xM + T
%   - M: Linear transformation
%   - T: Translation
% => Affine transformation: shear, non-uniform scaling

% Calculate length
vLen = size(v,1);
sourceCPLen = size(sourceCP, 1);
targetCPLen = size(targetCP, 1);

% Compute fa(v) = sum(A * qhat) + qstar
% -> Precompute A = (v - pstar) * inv(sum(phat^T * w * phat)) * (w * phatT)

% 1. Calculate v - pstar
% v - pstar
vSubpstar = [v(:,1)-pstar(:,1), v(:,2)-pstar(:,2)];

% 2. Calculate inv(sum(phat^T * w * phat))
% phat^T * w * phat
% Though this solution requires the inversion of a matrix, the matrix is a contant size (2 X 2)
phatTwphat = zeros(2, 2, vLen, sourceCPLen);
for itr=1:sourceCPLen
    for itr2=1:vLen
        phatTwphat(:,:,itr2,itr) = phat(itr2,:,itr)' * weight(itr2,itr) * phat(itr2,:,itr);
    end
end

% sum(phat^T * w * phat)
phatTwphatSum = sum(phatTwphat, 4);

% inv(sum(phat^T * w * phat)
invphatTwphatSum = zeros(2, 2, vLen);
for itr=1:vLen
    invphatTwphatSum(:,:,itr) = inv(phatTwphatSum(:,:,itr));
end

% 3. Calculate (w * phatT) & 4. Calculate A
% w * phatT
wphatT = zeros(2, vLen, targetCPLen);
% Aj is a single scalar
A = zeros(vLen, targetCPLen);
for itr=1:targetCPLen
    wphatT(:, :, itr) = (weight(:,itr).*phat(:,:,itr))';
    for itr2=1:vLen
        A(itr2, itr) = vSubpstar(itr2,:)*invphatTwphatSum(:,:,itr2)*wphatT(:,itr2,itr);
    end
end

qhat_reshape_x = reshape(qhat(:,1,:), size(v,1), size(targetCP,1));
qhat_reshape_y = reshape(qhat(:,2,:), size(v,1), size(targetCP,1));

% result = sum(A * qhat) + qstar
affineDef = [sum(A.* qhat_reshape_x, 2) + qstar(:,1), sum(A.* qhat_reshape_y, 2) + qstar(:,2)];

end

