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
pVector = zeros(rows * cols, 1);
qVector = zeros(rows * cols, 1);
B = zeros(rows * cols, 1);
count = 1;
for j=1:cols
    for i=1:rows
        p = (i - 1) * rows + j;
        % right
        if j ~= cols
            q = (i - 1) * rows + (j + 1);
            I_p = I(i, j, :);
            I_q = I(i, j+1, :);
            I_p = [(I_p(1) - 1) * rows + I_p(2), I_p(3)];
            I_q = [(I_q(1) - 1) * rows + I_q(2), I_q(3)];
            diff_pq = double(I_p) - double(I_q);
            comp_exp = exp(- (diff_pq^2)./(2 * sigma^2));
            dist = 1;
            % input values
            pVector(count) = p;
            qVector(count) = q;
            B(count) = sum(comp_exp) / dist;
            count = count + 1;
        end
        % down
        if i ~= rows
            q = i * rows + j;
            % Compute I_p and I_q
            I_p = I(i, j, :);
            I_q = I(i+1, j, :);
            I_p = [(I_p(1) - 1) * rows + I_p(2), I_p(3)];
            I_q = [(I_q(1) - 1) * rows + I_q(2), I_q(3)];
            % Compute exp
            diff_pq = double(I_p) - double(I_q);
            comp_exp = exp(- (diff_pq^2)./(2 * sigma^2));
            dist = 1;
            % input values
            pVector(count) = p;
            qVector(count) = q;
            B(count) = sum(comp_exp) / dist;
            count = count + 1;
        end
    end
end

pairWise = sparse(pVector',qVector',B',rows*cols,rows*cols);



