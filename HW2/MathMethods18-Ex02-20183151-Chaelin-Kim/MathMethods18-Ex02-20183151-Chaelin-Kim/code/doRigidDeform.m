function [ rigidDef ] = doRigidDeform( weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat )
% For realistic shapes, deformations should be as rigid as possible;
% that is, the space of deformations should not even include uniform scaling.
%   Rigid deformations are related to the similarity deformations
%   MTM = I -> non-linear constraint
% => Rigid transformation: translation, rotation

% Calculate length
vLen = size(v,1);
sourceCPLen = size(sourceCP, 1);
targetCPLen = size(targetCP, 1);

% Compute fr(v) = |v - pstar| * (normalized frVector) + qstar
% frVector = sum(qhat * A)
% A is same as the A matrix in Similarity Deform
% : A = w * [phat; -phat_perp] * [(v - pstar); -(v - pstar)_perp]T

% 1. Make [phat; -phat_perp]
%	Calculate phat_perp
phat_perp = [-phat(:,2,:), phat(:,1,:)];
%	Make [phat; -phat_perp] matrix [(x, y); (y, -x)]
pMat = zeros(2, 2, vLen, sourceCPLen);
for itr=1:vLen
    pMat(:,:,itr,:) = [phat(itr,:,:); -phat_perp(itr,:,:)];
end

% 2. Make [(v - pstar); -(v - pstar)_perp]
%   Calculate v-pstar & (v-pstar)_perp
vSubpstar = v - pstar;
vSubpstar_perp = [-vSubpstar(:,2), vSubpstar(:,1)];
%   Make [(v - pstar); -(v - pstar)_perp] matrix 
vSubpstarMat = zeros(2, 2, vLen);
for itr=1:vLen
    vSubpstarMat(:,:,itr) = [vSubpstar(itr,:); -vSubpstar_perp(itr,:)];
end

% 3. Calculate A
A = zeros(2,2,vLen,sourceCPLen);
for itr=1:sourceCPLen
    for itr2=1:vLen
        A(:,:,itr2,itr) = weight(itr2, itr).*pMat(:,:,itr2,itr) * vSubpstarMat(:,:,itr2)';
    end
end

% 4. Calculate frVector = sum(qhat * A)
% qhat * A
qhatA = zeros(vLen,2,targetCPLen);
for itr=1:targetCPLen
    for itr2=1:vLen
        qhatA(itr2,:,itr) = qhat(itr2,:,itr) * A(:,:,itr2,itr);
    end
end
% frVector = sum(qhat * A)
frVector = sum(qhatA,3);

% 5. Calculate length of (v - pstar) & normalized frVector
% (Length of (v - pstar)) = sqrt((v_x - pstar_x)^2 + (v_y - pstar_y)^2)
vSubpstarLen = sqrt(vSubpstar(:,1).^2 + vSubpstar(:,2).^2);
% normalized frVector = frVector / norm(frVector)
frVectorNormal = zeros(vLen, 2);
for itr=1:vLen
    frVectorNormal(itr,:) = frVector(itr,:) / norm(frVector(itr,:));
end

% fr(v) = |v - pstar| * (normalized frVector) + qstar
rigidDef = vSubpstarLen.*frVectorNormal + qstar;
end

