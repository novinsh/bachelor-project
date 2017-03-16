%% initialization
clear all;
close all;
clc;

numOfAnchors = 8;
numOfTests = 6;

figure(1);

ylim([-50 50]);
xlim([-20 20]);

anchors = ginput(numOfAnchors);
% anchors = importdata('anchors.mat');
labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'];

%% pre-calc
hold on;
for i=1:numOfAnchors
    plot(anchors(i, 1), anchors(i, 2), '*');
    text(anchors(i, 1), anchors(i, 2), labels(i));
end

%% main operation
for t=1:numOfTests
    nonAnchorPoint = ginput(1);
%     nonAnchorPoint = [-6.86635944700461,-29.6783625730994];
    
    plot(nonAnchorPoint(1), nonAnchorPoint(2), 'r*');
    text(nonAnchorPoint(1), nonAnchorPoint(2), 'X');
    
    %% LLS
    % taking the first item as the jth constraint item
    A = [];
    b = [];
    d = []; % distances of non-anchor node to the anchor ones
    S = []; % covariance matrix of b
    
    u_d = [];   % mean
    eta = 2;    % path-loss constant, 2 = free space to 4 = office
    sigma_d = 10 * log(10) / 10 * eta;
    
    d(1, :) = sqrt((0-nonAnchorPoint(1))^2+(0-nonAnchorPoint(2))^2);
    d_noisy(1, :) = d(1, :) + lognrnd(1.5, 0.5);
    u_d(1) = log(d_noisy(1));
    
    for i=2:numOfAnchors
        A(i-1, :) = [2*anchors(i, 1) 2*anchors(i, 2)];
        d(i, :) = sqrt((anchors(i, 1)-nonAnchorPoint(1))^2+(anchors(i, 2)-nonAnchorPoint(2))^2);
        
        d_noisy(i, :) = d(i, :) + lognrnd(1.5, 0.5);
        u_d(i) = log(d_noisy(i));
 
        b(i-1, :) = (anchors(i, 1)^2 + anchors(i, 2)^2 - d_noisy(i)^2 + d_noisy(1)^2);
    end
    S = ones(numOfAnchors-1, numOfAnchors-1) * d(1)^4 + diag(d(2:numOfAnchors).^4);
  
    x = inv(A' * A) * A' * b
    x_weighted = inv(A' * inv(S) * A) * A' * inv(S) * b
    
    plot(x(1), x(2), 'g*');
    text(x(1), x(2), 'LLS');
    
    plot(x_weighted(1), x_weighted(2), 'blue*');
    text(x_weighted(1), x_weighted(2), 'Wtd');
end
