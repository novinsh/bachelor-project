function pose2D = lateration_murphyHerman(sensors, dist)

% indicate valid indices
nonNanIndices = find(~isnan(dist));
numOfAnchors = size(nonNanIndices, 2);

%% LLS variables	
anchors = sensors(:, nonNanIndices);
radius = dist(nonNanIndices);   % radiuses from each anchor r_i
d = []; % distances between anchors and anchor(1) d_i1

%% pre-calcs
for i=1:numOfAnchors
    d(i) = sqrt((anchors(1, i)-anchors(1, 1))^2 + ...
        (anchors(2, i)-anchors(2, 1))^2);
end

%% LLS
A = zeros(numOfAnchors-1, 2);
b = zeros(numOfAnchors-1, 1);
S = []; % covariance matrix of b

for i=2:numOfAnchors
    A(i-1, :) = [anchors(1,i)-anchors(1,1) anchors(2,i)-anchors(2,1)];
    b(i-1, :) = 1/2 * (radius(1)^2 - radius(i)^2 + d(i)^2);
end

x = inv(A' * A) * A' * b;
x =  x + [anchors(1, 1); anchors(2, 1)];

plot(x(1), x(2), '*k');

pose2D = x;
end