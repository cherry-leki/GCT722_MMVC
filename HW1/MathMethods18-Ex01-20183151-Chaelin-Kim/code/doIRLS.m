function [ result_IRLS ] = doIRLS( n, data )
%% Norm 1 with IRLS
compare = [];
% Initial weight: w = 1
weight = ones([1, 100]);
result_sum = Inf(1);

for itr=1:n
    % ¡ÓR/¡Óa = -2 * Sum(wi(yi-(axi + b))xi = 0
    % ¡ÓR/¡Ób = -2 * Sum(wi(yi-(axi + b)) = 0
    sumW = sum(weight);
    sumWX = sum(weight.*data(1,:));
    sumWXsqr = sum(weight.*data(1,:).^2);
    sumWY = sum(weight.*data(2,:));
    sumWXY = sum(weight.*data(1,:).*data(2,:));
    grad_a = (sumWXY - (sumWX*sumWY)/sumW) / (sumWXsqr - ((sumWX)^2)/sumW);
    grad_b = (sumWY - grad_a * sumWX) / sumW;
    temp_sum = sum(abs(data(2,:)-(data(1,:).* grad_a + grad_b)));
    
    if result_sum > temp_sum
        result_sum = temp_sum;
        result_IRLS = [grad_a, grad_b];
    end
    
    weight = 1./max(0.0001, abs(data(2,:) - (data(1,:).*grad_a + grad_b)));
    compare = [compare; grad_a, grad_b];
end
end

