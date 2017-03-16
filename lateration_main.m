common;

%% run multi-lateration
nstep = size(map.data, 1);  % number of observations -> number of steps
for i = 1:nstep    
    NanIndices = find(map.data(i, :) == -130, 1);  % keep invalids
    radius = inv_path_loss_model(map.data(i, :));  % calculate dist/radius
    radius(:, NanIndices) = nan;  % make sure to indicate invalids
    
    % different methods, simple and weighted
%     lateration_murphyHermann(map.sensors.xy, radius);
%     pose2D = lateration_paulaAnaJose(map.sensors.xy, radius);
    pose2D = lateration_weightedMurphyHerman(map.sensors.xy, radius);
    
    % plot
    lateration_plot(pose2D);
    
    pause(0.05);
end