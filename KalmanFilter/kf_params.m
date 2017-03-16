function kalman = kf_params()
%KALMAN_PARAMS Summary of this function goes here
%   Detailed explanation goes here
%% meta variables
duration = 10;
dt = .1;
motion = 0; % 0: constant velocity, 1: constant acceleration
simType = 0; % 0: generate sample, 1: load sample from file

kalman.metaparams.duration = duration;
kalman.metaparams.dt = dt;
kalman.metaparams.motion = motion; 
kalman.metaparams.simType = simType;

%% main variables
a_max = 1.5;        % acceleration (m/s^2)
alpha_max = 0.5;    % angular acceleration (rad/s^2)
phi = 0;        % angular velocity (m/s)
w = 1;          % process noise (meter)
v_gps = 3;      % gps measurement noise (meter)
v_cmpss = 0.1;  % compass measurement noise (rad)
v_dr = 2;       % accelerometer measurement noise (meter)

kalman.params.a_max = a_max;
kalman.params.alpha_max = alpha_max;
kalman.params.phi = phi;
kalman.params.w = w;
kalman.params.v.gps = v_gps;
kalman.params.v.cmpss = v_cmpss;
kalman.params.v.dr = v_dr;

%% process covariance
Sig_Px = dt^2*a_max/2;
Sig_Py = dt^2*a_max/2;
Sig_vel = dt*a_max;
Sig_phi = dt^2*alpha_max/2;
Sig_omega = dt*alpha_max;
kalman.Q = diag([Sig_Px^2 Sig_Py^2 Sig_vel^2 Sig_phi^2 Sig_omega^2]);

%% measurement covariance
kalman.R.gps = v_gps^2;        % gps measurement covariance
kalman.R.cmpss = v_cmpss^2;    % compass measurement covariance
kalman.R.dr = v_dr^2;          % deadreckoning measurement covariance

end

