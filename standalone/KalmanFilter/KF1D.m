% close all;
clc;
clear;
tmp = importdata('sample.txt');
tmp = tmp.data;

% tmp(length(tmp)+1:2*length(tmp), 2) = tmp(1:length(tmp), 2); 
% tmp(length(tmp)+1:2*length(tmp), 3) = tmp(1:length(tmp), 3); 

data(1, 1:length(tmp)) = tmp(1:length(tmp), 2);
data(2, 1:length(tmp)) = tmp(1:length(tmp), 3);
% data(2, 50) = 5069714;
% data(2, 51) = 5069714;
% data(2, 52) = 5069714;
% data(2, 53) = 5069714;
% data(2, 54) = 5069714;
% data(2, 55) = 5069714;
% data(2, 56) = 5069714;
% data(2, 57) = 5069714;
% data(2, 58) = 5069714;
% data(2, 59) = 5069714;

smoothData = tsmovavg(data, 's', 10);

dt = 0.1;

A = [1 0 dt ; 0 1 dt ; 0 0 1];
C = [1 0 0; 0 1 0];

u = 1.5;
Q = [data(1, 1); data(2, 1); 0;];
Q_estimate = Q;
QuailAccel_noise_mag = 0.5;
NinjaVision_noise_mag = 3;
Ez = diag([NinjaVision_noise_mag^2 NinjaVision_noise_mag^2]);
Ex = QuailAccel_noise_mag^2 * diag([dt^4/4 dt^4/4 dt^2]); % Ex into covariance matrix

P = Ex;

Q_loc = []; % has to be loaded from offline logs
vel = []; % perhaps from offline logs
Q_loc_meas = []; % has to be loaded from offline logs

for i=1:length(data)
    Q_loc(1, i) = data(1, i);
    Q_loc(2, i) = data(2, i);
end

Q_loc_meas = Q_loc;
    
KalmanPose = [];
KalmanPose2 = [];
for t=1:length(Q_loc)
    % prediction
    Q_estimate = A * Q_estimate;
    % covariance location based on prediction
    P = A * P * A' + Ex;
    
% for z in every measurement sources
    % kalman gain
    K = P * C' * inv(C * P * C' + Ez);
    % estimation (fusion of prediction and measurement)
    Q_estimate = Q_estimate + K * (Q_loc_meas(:, t) - C * Q_estimate);
% end

    KalmanPose2(t) = Q_estimate(1);
    KalmanPose(t) = Q_estimate(2);
    
    % update covariance location
    P = (eye(3)- K * C) * P;
end

figure(1);
hold on;
plot(smoothData(2, 1:length(tmp)), '-g.');
plot(Q_loc_meas(2, 1:length(Q_loc_meas)), '-r.');
plot(KalmanPose(1:length(Q_loc_meas)), '-b.');

% plot the movement on 2D space (requires global to cartesian translation)
figure(2)
hold on;
plot(smoothData(1, 1:length(tmp)), '-g.');
plot(Q_loc_meas(1, 1:length(Q_loc_meas)), '-r.');
plot(KalmanPose2(1:length(Q_loc_meas)), '-b.');