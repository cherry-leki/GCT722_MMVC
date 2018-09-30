function [ result_IRLS ] = doIRLS( data )

%% Norm 1 with IRLS
compare = ones(1,2);
% Initial weight: w = 1
weight = ones([1, 100]);
result_sum = Inf(1);
threshold = 1;

while threshold > 0.0001
    % Compute the weighted least squares(WLS)
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
    
    % Update the result
    if result_sum > temp_sum
        result_sum = temp_sum;
        result_IRLS = [grad_a, grad_b];
    end
    
    % Compute the weight
    weight = 1./max(0.0001, abs(data(2,:) - (data(1,:).*grad_a + grad_b)));
    % Compute the threshold to get out the loop if the best result is found. 
    threshold = abs(([compare(end,1), compare(end,2)]-[grad_a, grad_b]));
    compare = [compare; grad_a, grad_b];
end
end

