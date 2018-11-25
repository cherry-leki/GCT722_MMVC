function pairWise = getPairWise(I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get pairwise terms for each pairs of pixels on image I and for
% regularizer lambda.
% 
% INPUT :
% - I      : color image
% - lambda : regularizer parameter
% 
% OUTPUT :
% - pairwise : sparse square matrix containing the pairwise costs for image
%              I and parameter lambda
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%TODO
rows = size(I, 1);
cols = size(I, 2);
sigma = 5;

pVector = zeros(rows * cols, 1);    % i index
qVector = zeros(rows * cols, 1);    % j index
% B = exp(-(Ip - Iq)^2 / (2*¥ò^2)) / dist(Ip, Iq)
B = zeros(rows * cols, 1);
count = 1;

for j=1:cols
    for i=1:rows
        p = (j - 1) * rows + i;
        % right
        if j ~= cols
            q = j * rows + i;
            % Compute I_p and I_q
            I_p = zeros(1,3);
            I_q = zeros(1,3);
            for k=1:3
                I_p(1,k) = I(i,j,k);
                I_q(1,k) = I(i,j+1,k);
            end
            % Compute exp
            diff_pq = double(I_p) - double(I_q);
            comp_exp = exp(- norm(diff_pq)./(2 * sigma^2));
            dist = 1;
            % input values
            pVector(count) = p;
            qVector(count) = q;
            B(count) = comp_exp / dist;
            count = count + 1;
        end
        % down
        if i ~= rows
            q = (j-1) * rows + (i+1);
            % Compute I_p and I_q
            I_p = zeros(1,3);
            I_q = zeros(1,3);
            for k=1:3
                I_p(1,k) = I(i,j,k);
                I_q(1,k) = I(i+1,j,k);
            end
            % Compute exp
            diff_pq = double(I_p) - double(I_q);
            comp_exp = exp(- norm(diff_pq)./(2 * sigma^2));
            dist = 1;
            % input values
            pVector(count) = p;
            qVector(count) = q;
            B(count) = comp_exp / dist;
            count = count + 1;
        end
    end
end

pairWise = sparse(pVector',qVector',B',rows*cols,rows*cols);
return;


