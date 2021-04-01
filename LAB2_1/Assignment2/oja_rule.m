%%%%%%%%%%%%%%% Learning using Oja Rule %%%%%%%%%%%%%%%
clear variables;

data = readtable('../lab2_1_data.csv');  % importing data as table
U = table2array(data);  % converting table into input array
U_size = size(U,2);  % training set dimension
eta = 10e-6;  % learning rate
epochs=1000;  % iterations
alpha = 10e-3;
theta = 10e-6;  % threshold for early stopping
Q = U'*U;  % input correlation matrix
W_t = zeros(2, epochs);

W = -1 + (1+1)*rand(2,1);  % random weights initialization
W_norm = zeros(1, epochs);
w_norm = norm(W);

for i = 1:epochs
    U = U(:,randperm(U_size));  % reshuffling dataset
    
    for n = 1:U_size
        % linear firing model
        v = W' * U(:,n);  % compute output
        delta_W = v * U(:,n) - (alpha * v^2 * W);  % Oja delta
        W = W + eta * delta_W;  % update weights
    end
    
    W_norm(i) = w_norm;
    w_norm_new = norm(W);
    W_out = W/norm(W);
    W_t(:,i) = W_out;
    
    diff = w_norm_new - w_norm;
    w_norm = w_norm_new;
    
    fprintf('Epoch: %d Norm(W): %1.5f Diff: %1.7f Theta: %1.7f \n', i, w_norm, diff, theta)
    
    if diff < theta
        break;
    end    
end

[EV, D] = eig(Q);  % computing eigenvalues and eigenvectors of Q
[d, ind] = sort(diag(D));  % sort eigenvectors
EV = EV(:,ind);
ev = EV(:,1);  % take the principal eigenvector

% Plotting data points and comparison between final weight vector and
% principal eigenvector of Q
fig = figure;
scatter(U(1,:),U(2,:), '.')
hold on
plotv(ev);
set(findall(gca,'Type', 'Line'),'LineWidth',1.75);
plotv(W)
hold off
legend('data points','principal eigenvector','weight vector','Location', 'best')
title('P1: data points, final weight vector and principal eigenvector of Q');
print(fig,'P1.png','-dpng')


x=(1:1:epochs);
% weight evolution, first component
fig = figure;
plot(x, W_t(1,:));
xlabel('time')
ylabel('weight')
title('Weight vector time evolution (1st component)')
print(fig,'P2.1.png','-dpng')

% weight evolution, second component
fig = figure;
plot(x, W_t(2,:))
xlabel('time')
ylabel('weight')
title('Weight vector time evolution (2nd component)')
print(fig,'P2.2.png','-dpng')

% weight norm evolution
fig = figure;
plot(x, W_norm)
xlabel('time')
ylabel('weight')
title('Weight norm vector time evolution')
print(fig,'P2.3.png','-dpng')

save('W_t.mat','W_t');