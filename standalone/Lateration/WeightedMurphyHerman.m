%% initialization
clear all;
close all;
clc;

numOfAnchors = 8;
numOfTests = 7;

figure(1);
hold on;

ylim([-50 50])
xlim([-20 20])

anchors = ginput(numOfAnchors);
% anchors = importdata('anchors.mat');
labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'];

%% LLS variables
r = [];	% radiuses from each anchor r_i
d = []; % distances between anchors and anchor(1) d_i1

%% pre-calcs
for i=1:numOfAnchors
    plot(anchors(i, 1), anchors(i, 2), '*');
    text(anchors(i, 1), anchors(i, 2), labels(i));
    
    d(i) = sqrt((anchors(i, 1)-anchors(1, 1))^2 + ...
        (anchors(i, 2)-anchors(1, 2))^2);
end

%% main operation
for t=1:numOfTests
    nonAnchorPoint = ginput(1);
    %     nonAnchorPoint = [-6.86635944700461,-29.6783625730994];
    
    % continue of pre-calc:
    for i=1:numOfAnchors
        % part of pre-calc:
        r(i) = sqrt((nonAnchorPoint(1, 1)-anchors(i, 1))^2 + ...
            (nonAnchorPoint(1, 2)-anchors(i, 2))^2);
        
        % add noise from lognormal distribution (to simulate real world effect)
        r_noisy = r + lognrnd(1.7, 0.5);
        r = r_noisy;
    end
    
    plot(nonAnchorPoint(1), nonAnchorPoint(2), 'r*');
    text(nonAnchorPoint(1), nonAnchorPoint(2), 'X');
    
    %% LLS
    A = zeros(numOfAnchors-1, 2);
    b = zeros(numOfAnchors-1, 1);
    S = []; % covariance matrix of b
    
    for i=2:numOfAnchors
        A(i-1, :) = [anchors(i,1)-anchors(1,1) anchors(i,2)-anchors(1,2)];
        b(i-1, :) = 1/2 * (r(1)^2 - r(i)^2 + d(i)^2);
    end
    S = ones(numOfAnchors-1, numOfAnchors-1) * r(1)^4 + diag(r(2:numOfAnchors).^4);
    
    x = inv(A' * A) * A' * b;
    x_weighted = inv(A' * inv(S) * A) * A' * inv(S) * b;
    
    x = x + [anchors(1, 1); anchors(1, 2)];
    x_weighted = x_weighted + [anchors(1, 1); anchors(1, 2)];
    
    plot(x(1), x(2), 'g*');
    text(x(1), x(2), 'L');
    
    plot(x_weighted(1), x_weighted(2), 'blue*');
    text(x_weighted(1), x_weighted(2), 'W');
end
