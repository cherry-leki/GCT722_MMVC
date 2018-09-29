function [ result_LP ] = doLP( data, Lnorm )
L_f = [];
L_A = [];
if strcmp(Lnorm, "L1")
    L_f = [[0, 0], ones(size(data(1,:)))];
    L_A = [data(1,:)', ones(size(data(1,:)))', -eye(size(data(1,:),2)); ...
        -data(1,:)', -ones(size(data(1,:)))', -eye(size(data(1,:),2))];
elseif strcmp(Lnorm, "Linf")
    L_f = [0 0 1];
    L_A = [data(1,:)', ones(size(data(1,:)))', -ones(size(data(1,:)))'; ...
        -data(1,:)', -ones(size(data(1,:)))', -ones(size(data(1,:)))'];
end
L_b = [data(2,:), -data(2,:)];

result_LP = linprog(L_f, L_A, L_b');

end

