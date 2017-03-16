function pose2D = lateration_paulaAnaJose(sensors, dist)

% indicate valid indices
nonNanIndices = find(~isnan(dist));
numOfAnchors = size(nonNanIndices, 2);
anchors = sensors(:, nonNanIndices);

%% LLS
% taking the first item as the jth constraint item
A = [];
b = [];
radius = dist(nonNanIndices);   % radiuses from each anchor
S = []; % covariance matrix of b

u_d = [];   % mean
eta = 2;    % path-loss constant, 2 = free space to 4 = office
sigma_d = 10 * log(10) / 10 * eta;

u_d(1) = log(radius(1));

for i=2:numOfAnchors
    A(i-1, :) = [2*anchors(1, i) 2*anchors(2, i)];
    u_d(i) = log(radius(i));
    b(i-1, :) = (anchors(1, i)^2 + anchors(2, i)^2 - radius(i)^2 + radius(1)^2);
end
S = ones(numOfAnchors-1, numOfAnchors-1) * radius(1)^4 + diag(radius(2:numOfAnchors).^4);

x = inv(A' * A) * A' * b;
x_weighted = inv(A' * inv(S) * A) * A' * inv(S) * b;

% plot(x(1), x(2), 'g*');
% text(x(1), x(2), 'LLS');

% plot(x_weighted(1), x_weighted(2), 'blue*');
% text(x_weighted(1), x_weighted(2), 'Wtd');

pose2D = x_weighted;
end
