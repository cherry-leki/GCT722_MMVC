clear all

%% initial settings
n = 100;
a = 5 / 6;
b = 0.1;
outlierRatio = 0.1;
inlierThreshold = 0.1;

%% compute the number of outlier and inlier
outlierNum = outlierRatio * 100;
inlierNum = n - outlierNum;

%% setting noise
rng('shuffle', 'twister');
noise_x = - 0.1 + (0.1 + 0.1) * rand(inlierNum, 1);
noise_y = - 0.1 + (0.1 + 0.1) * rand(inlierNum, 1);

%% make inlier data
x_data_i = -10 + (10 + 10) * rand(inlierNum, 1) + noise_x;
y_data_i = (a * x_data_i + b) + noise_y;

%% make outlier data
itr = 0;
x_data_o = [];
y_data_o = [];

while itr < outlierNum
    temp_x = -10 + 20 * rand;
    temp_y = -10 + 20 * rand;
    if (abs(temp_y - (a * temp_x + b)) <= inlierThreshold)
        continue;
    end
    x_data_o = [x_data_o, temp_x];
    y_data_o = [y_data_o, temp_y];
    itr = itr + 1;
end

data = [[x_data_i', x_data_o]; [y_data_i', y_data_o]];

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

%% Norm 1 with LP
L1_f = [[0, 0]'; ones(size(data(1,:)))'];
L1_A = [data(1,:)', ones(size(data(1,:)))', -eye(size(data(1,:),2)); ...
        -data(1,:)', -ones(size(data(1,:)))', -eye(size(data(1,:),2))];
L1_b = [data(2,:), -data(2,:)];

result_L1 = linprog(L1_f', L1_A, L1_b');

%% Norm infinity with LP
Linf_f = [0 0 1];
Linf_A = [data(1,:)', ones(size(data(1,:)))', -ones(size(data(1,:)))'; -data(1,:)', -ones(size(data(1,:)))', -ones(size(data(1,:)))'];
Linf_b = [data(2,:), -data(2,:)];
result_inf = linprog(Linf_f, Linf_A, Linf_b');

x = [-10, 10];
p = plot(data(1,:), data(2,:), 'o');
xlim([-10, 10]);
ylim([-10, 15]);
hold on
% Synthesized line
plot(x, a * x + b, 'Color', 'g', 'LineWidth', 3);
% L1 with IRLS
plot(x, result_IRLS(1) * x + result_IRLS(2), 'Color', 'r', 'LineWidth', 1.8);
% L1 with LP
plot(x, result_L1(1) * x + result_L1(2), 'Color', 'black');
% L infinity with LP
plot(x, result_inf(1) * x + result_inf(2), 'Color', 'black');
hold off
