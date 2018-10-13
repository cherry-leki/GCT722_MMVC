function [ resultOrtho ] = calOrtho( vLength, source )
%CALORTHO 이 함수의 요약 설명 위치
%   자세한 설명 위치
spLength = size(source, 3);
tempOrtho = zeros(source);
for itr=1:spLength
    tempOrtho(:,1,itr) = -source(:,2,itr);
    tempOrtho(:,2,itr) = source(:,1,itr);
end

resultOrtho = tempOrtho;
end

