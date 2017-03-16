clear all;
close all;
clc;

%% meta variables
duration = 10;
dt = .1;
motion = 0; % 0: constant velocity, 1: constant acceleration
simType = 0; % 0: generate sample, 1: load sample from file

%% main variables
a_max = 1.5;        % acceleration (m/s^2)
alpha_max = 0.5;    % angular acceleration (rad/s^2)
phi = 0;        % angular velocity (m/s)
w = 2;        % process noise
v_gps = 3;      % gps measurement noise (meter)
v_cmpss = 0.1;  % compass measurement noise (rad)
v_dr = 2;       % accelerometer measurement noise (meter)

X = [0; 0; 0; 0; 0];	% state vector

% process covariance
Sig_Px = dt^2*a_max/2;
Sig_Py = dt^2*a_max/2;
Sig_vel = dt*a_max;
Sig_phi = dt^2*alpha_max/2;
Sig_omega = dt*alpha_max;
Q = diag([Sig_Px^2 Sig_Py^2 Sig_vel^2 Sig_phi^2 Sig_omega^2]);

R_gps = v_gps^2;        % gps measurement covariance
R_cmpss = v_cmpss^2;    % compass measurement covariance
R_dr = v_dr^2;          % deadreckoning measurement covariance

P_gps = Q;      % estimate of initial state
P_cmpss = Q;    % estimate of initial state
P_dr = Q;       % estimate of initial state

%% transition matrices
A = [1 0 dt*cos(phi) 0 0 ;
    0 1 dt*sin(phi) 0 0 ;
    0 0 1 0 0 ;
    0 0 0 1 dt;
    0 0 0 0 1 ];

B = [dt^2/2; dt^2/2; dt; dt^2/2; dt];

C_gps = [1 0 0 0 0 ;
    0 1 0 0 0];

C_cmpss = [0 0 0 1 0];

C_dr = [0 0 1 0 0] ;
%     0 0 0 0 1];

%% initialize result variables
% actual position x, y and velocity
X_px = [];
X_py = [];
X_vel = [];
% measured position, heading and displacement
X_px_meas = [];
X_py_meas = [];
X_cmpss_meas = [phi];
X_dr_meas = [1];%; 0];
tt = 0;

%% simulate data
figure(1); clf;
set(gcf,'name','Position-2D and Velocity','numbertitle','off');
if motion == 0
    X = [0; 0; 1; 0; 0];
end

if simType == 0
    tt = 0:dt:duration;
    for t=tt
        % Generate the Quail flight
        
        if motion == 0
            X = A * X;
        elseif motion == 1
            QuailAccel_noise = w * [(dt^2/2)*randn; (dt^2/2)*randn; ...
                dt*randn; (dt^2/2)*randn; dt*randn];
            X = A * X + B * a_max + QuailAccel_noise;
        end
        
        % Generate what the Ninja sees
        NinjaVision_noise = v_gps * randn;
        z = C_gps * X + NinjaVision_noise;
        
        X_px = [X_px; X(1)];
        X_py = [X_py; X(2)];
        X_px_meas = [X_px_meas; z(1)];
        X_py_meas = [X_py_meas; z(2)];
        X_vel = [X_vel; X(3)];
        
        % iteratively plot what the ninja sees
        % axis x
        subplot(2, 2, 1);
        plot(0:dt:t, X_px, '-r.')
        plot(0:dt:t, X_px_meas, '-k.')
        hold on
        
        % axis y
        subplot(2, 2, 2);
        plot(0:dt:t, X_py, '-r.')
        plot(0:dt:t, X_py_meas, '-k.')
        hold on
        
        %pause
    end
else
    tmp = importdata('sample.txt');
    tmp = tmp.data;
    tt = 1:length(tmp);
    X_px_meas = tmp(1:length(tmp), 2);
    X_py_meas = tmp(1:length(tmp), 3);
    X_vel = zeros(length(tmp), 1);
    
    % iteratively plot what the ninja sees
    % axis x
    subplot(2, 2, 1);
    plot(tt, X_px_meas, '-k.')
    hold on
    
    % axis y
    subplot(2, 2, 2);
    plot(tt, X_py_meas, '-k.')
    hold on
end

% plot theoretical path of ninja that doesn't use kalman
Ymin = min([X_px_meas; X_py_meas]);
Ymax = max([X_px_meas; X_py_meas]);

subplot(2, 2, 1);
plot(tt, smooth(X_px_meas), '-g.')
% axis([0 duration Ymin Ymax])
title('X axis');
subplot(2, 2, 2);
plot(tt, smooth(X_py_meas), '-g.')
% axis([0 duration Ymin Ymax])
title('Y axis');

% plot velocity
subplot(2, 2, [3 4]);
plot(tt, X_vel, '-b.'), hold on;
title('Velocity');

%% kalman filtering
X = [0; 0; 0; 0; 0];
X_estimate = X;

P_mag_estimate = [];
predict_states = [];
predict_vars = [];

if length(X_px_meas) ~= length(X_py_meas)
    error('size of X_px_meas and X_px_meas does not match!');
end

for k=1:length(tt)
    A(1, 3) = dt*cos(phi);
    A(2, 3) = dt*sin(phi);

    % prediction
    X = A * X;
    P_gps = A * P_gps * A' + Q;
    P_cmpss = A * P_cmpss * A' + Q;
    P_dr = A * P_dr * A' + Q;
    
    predict_states(:, k) = X(1:2, 1);
    predict_vars(:, k) = [P_gps(1, 1); P_gps(2, 2)];
    
    % GPS update
    K_gps = P_gps * C_gps' * inv(C_gps * P_gps * C_gps' + R_gps);
    X = X + K_gps * ([X_px_meas(k); X_py_meas(k)] - C_gps * X);
    P_gps = (eye(5)- K_gps * C_gps) * P_gps;
    
    % Compass update
%     K_cmpss = P_cmpss * C_cmpss' * inv(C_cmpss * P_cmpss * C_cmpss' + R_cmpss);
%     X = X + K_cmpss * (X_cmpss_meas - C_cmpss * X);
%     P_cmpss = (eye(5)- K_cmpss * C_cmpss) * P_cmpss;
    
    % Deadreckoning update
%     K_dr = P_dr * C_dr' * inv(C_dr * P_dr * C_dr' + R_dr);
%     X = X + K_dr * (X_dr_meas - C_dr * X);
%     P_dr = (eye(5)- K_dr * C_dr) * P_dr;
    
    % store for plotting
    X_estimate(:, k) = X;
    P_mag_estimate(:, k) = [P_gps(1, 1); P_gps(2, 2); P_gps(3, 3); P_gps(4, 4); P_gps(5, 5)];
end

% plot kalman result
figure(1);
% axis x
subplot(2, 2, 1);
plot(tt, X_estimate(1, :), '.-y');
% axis y
subplot(2, 2, 2);
plot(tt, X_estimate(2, :), '.-y');
% velocity
subplot(2, 2, [3 4]);
plot(tt, X_estimate(3, :), '.-y');


%% distributions evolution
figure(2);
set(gcf,'name','Distributions','numbertitle','off');

for t=length(tt)
    clf
    x = X_estimate(t)-min(X_px):.1:X_estimate(t)+max(X_px);
    
    % predicted next position
    mu = predict_states(1, t);   % mean
    sigma = predict_vars(1, t);  % standard deviation
    y = normpdf(x, mu, sigma);   % pdf
    y = y/(max(y));
    h1 = line(x, y, 'Color', 'm'); hold on;
    
    % measured data
    mu = X_px_meas(t);          % mean
    sigma = v_gps;              % standard deviation
    y = normpdf(x, mu, sigma);  % pdf
    y = y/(max(y));
    hl = line(x, y, 'Color', 'k'); hold on;
    
    % combined position estimate
    mu = X_estimate(1, t); % mean
    sigma = P_mag_estimate(t); % standard deviation
    y = normpdf(x, mu, sigma); % pdf
    y = y/(max(y));
    hl = line(x, y, 'Color','g'); hold on;
    axis([X_estimate(1, t)-5 X_estimate(1, t)+5 0 1]);
    
    % actual position
    plot(X_px(t)); hold on;
    
    ylim=get(gca,'ylim');
    line([X_px(t); X_px(t)], ylim.', 'linewidth', 2, 'color', 'b');
    legend('state predicted','measurement','state estimate','actual position')
    
    pause(0.0001);
end