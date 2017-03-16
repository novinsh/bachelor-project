function pose2D = lateration_weightedMurphyHerman(sensors, dist)

% indicate valid indices
nonNanIndices = find(~isnan(dist));
numOfAnchors = size(nonNanIndices, 2);

% anchors = ginput(numOfAnchors);
% % anchors = importdata('anchors.mat');
% labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'];

%% LLS variables
radius = [];	% radiuses from each anchor r_i
d = []; % distances between anchors and anchor(1) d_i1

anchors = sensors(:, nonNanIndices);
radius = dist(nonNanIndices);   % radiuses from each anchor r_i

%% pre-calcs
for i=1:numOfAnchors
    %     plot(anchors(1, i), anchors(2, i), '*');
    %     text(anchors(1, i), anchors(2, i), labels(i));
    d(i) = sqrt((anchors(1, i)-anchors(1, 1))^2 + ...
        (anchors(2, i)-anchors(2, 1))^2);
end

%% main operation
% nonAnchorPoint = ginput(1);
%     nonAnchorPoint = [-6.86635944700461,-29.6783625730994];

% continue of pre-calc:
% for i=1:numOfAnchors
    % part of pre-calc:
%     radius(i) = sqrt((nonAnchorPoint(1, 1)-anchors(i, 1))^2 + ...
%         (nonAnchorPoint(1, 2)-anchors(i, 2))^2);

    % add noise from lognormal distribution (to simulate real world effect)
%     r_noisy = radius + lognrnd(1.7, 0.5);
%     radius = r_noisy;
% end

% plot(nonAnchorPoint(1), nonAnchorPoint(2), 'r*');
% text(nonAnchorPoint(1), nonAnchorPoint(2), 'X');

%% LLS
A = zeros(numOfAnchors-1, 2);
b = zeros(numOfAnchors-1, 1);
S = []; % covariance matrix of b

for i=2:numOfAnchors
    A(i-1, :) = [anchors(1, i)-anchors(1,1) anchors(2, i)-anchors(2, 1)];
    b(i-1, :) = 1/2 * (radius(1)^2 - radius(i)^2 + d(i)^2);
end
S = ones(numOfAnchors-1, numOfAnchors-1) * radius(1)^4 + diag(radius(2:numOfAnchors).^4);

x = inv(A' * A) * A' * b;
x_weighted = inv(A' * inv(S) * A) * A' * inv(S) * b;

x = x + [anchors(1, 1); anchors(1, 2)];
x_weighted = x_weighted + [anchors(1, 1); anchors(1, 2)];

pose2D = x_weighted;

% plot(x(1, 1), x(2, 1), 'r*');
% text(x(1), x(2), 'L');
% 
% plot(x_weighted(1), x_weighted(2), 'blue*');
% text(x_weighted(1), x_weighted(2), 'W');
end
