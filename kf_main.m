common;

%% run kalman filter 
kf = kf_params();
kf = kf_initialization(kf);

nstep = size(map.data, 1);  % number of observations -> number of steps
for i=1:nstep
    % update state transition matrice (which is time-variant)
    A(1, 3) = kf.metaparams.dt*cos(kf.params.phi);
    A(2, 3) = kf.metaparams.dt*sin(kf.params.phi);
    
    % prediction
    [kf.X, kf.P] = ...
        kf_prediction(kf.A, kf.X, kf.P, kf.Q, kf.B, 0, 0);

    % measurement (using multilateration)
    NanIndices = find(map.data(i, :) == -130, 1);   % keep invalids
    radius = inv_path_loss_model(map.data(i, :));
    radius(:, NanIndices) = nan;  % make sure to indicate invalids
%     kf.Z.gps(:, i) = lateration_paulaAnaJose(map.sensors.xy, radius);
    kf.Z.gps(:, i) = lateration_weightedMurphyHerman(map.sensors.xy, radius);
    if i==1 % initial position extracted
        kf.X(1:2, 1) = kf.Z.gps(:, i);
    end
    
    % update
    [kf.X, kf.P] = ...
        kf_update(kf.Z.gps(:, i), kf.X, kf.P, kf.C.gps, kf.R.gps);
        
%     [kf.X, kf.P.cmpss] = ...
%         kf_update(kf.Z.cmpss(:, s), kf.X, kf.P.cmpss, kf.C.cmpss, kf.R.cmpss);
%     [kf.X, kf.P.dr] = ...
%         kf_update(kf.Z.dr(:, s), kf.X, kf.P.dr, kf.C.dr, kf.R.dr);
       
    kf_plots(kf);
    pause(0.1);
end
