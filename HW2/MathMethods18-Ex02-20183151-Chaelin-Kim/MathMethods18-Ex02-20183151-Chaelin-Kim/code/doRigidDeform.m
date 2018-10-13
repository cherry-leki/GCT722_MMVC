function [ rigidDef ] = doRigidDeform( weight, v, sourceCP, targetCP, pstar, phat, qstar, qhat )
%DORIGIDDEFORM 이 함수의 요약 설명 위치
%   자세한 설명 위치

% Calculate length
vLen = size(v,1);
sourceCPLen = size(sourceCP, 1);
targetCPLen = size(targetCP, 1);

phat_ortho = [-phat(:,2,:), phat(:,1,:)];
pMat = zeros(2,2,vLen,sourceCPLen);
for itr=1:vLen
    pMat(:,:,itr,:) = [phat(itr,:,:); -phat_ortho(itr,:,:)];
end

vSubpstar = v - pstar;
vSubpstar_ortho = [-vSubpstar(:,2), vSubpstar(:,1)];
vSubpstarMat = zeros(2,2,vLen);
for itr=1:vLen
    vSubpstarMat(:,:,itr) = [vSubpstar(itr,:); -vSubpstar_ortho(itr,:)];
end

A = zeros(2,2,vLen,sourceCPLen);
for itr=1:sourceCPLen
    for itr2=1:vLen
        A(:,:,itr2,itr) = weight(itr2, itr).*pMat(:,:,itr2,itr) * vSubpstarMat(:,:,itr2)';
    end
end

qhatA = zeros(vLen,2,targetCPLen);
for itr=1:targetCPLen
    for itr2=1:vLen
        qhatA(itr2,:,itr) = qhat(itr2,:,itr) * A(:,:,itr2,itr);
    end
end

frVector = sum(qhatA,3);
vSubpstarLen = sqrt(vSubpstar(:,1).^2 + vSubpstar(:,2).^2);
frVectorNormal = zeros(vLen, 2);
for itr=1:vLen
    frVectorNormal(itr,:) = frVector(itr,:) / norm(frVector(itr,:));
end

rigidDef = vSubpstarLen.*frVectorNormal + qstar;
end

