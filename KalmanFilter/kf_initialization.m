function kalman_new = kf_initialization( kalman )
%KF_INITIALIZATION Summary of this function goes here
%   Detailed explanation goes here

%% state vector
kalman.X = [0; 0; 0; 0; 0];	

%% transition matrices
% state transition matrice
dt = kalman.metaparams.dt;
phi = kalman.params.phi;

kalman.A = [ 
    1 0 dt*cos(phi) 0 0 ;
    0 1 dt*sin(phi) 0 0 ;
    0 0 1 0 0 ;
    0 0 0 1 dt;
    0 0 0 0 1 ];

% control input transition matrice
kalman.B = [dt^2/2; dt^2/2; dt; dt^2/2; dt];

% measurement transition matrice for gps
kalman.C.gps = [1 0 0 0 0 ;
    0 1 0 0 0];

% measurement transition matrice for compass
kalman.C.cmpss = [0 0 0 1 0];

% measurement transition matrice for dead reackoning
kalman.C.dr = [0 0 1 0 0] ;
%     0 0 0 0 1];

%% estimate of initial state
kalman.P = kalman.Q;

kalman_new = kalman;
end

