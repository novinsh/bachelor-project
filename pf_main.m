common;

%% run filter
n = 1000; % number of particles
p = initialise_particles(map, n);

nstep = size(map.data, 1);  % number of observations -> number of steps
for i = 1:nstep
    p = motion_model(p, 0.05);
    
%     if(i > 9)
%         p = observation_model(p, mean(map.data(i-9:i,:)), map.sensors);
%     else
        p = observation_model(p, map.data(i,:), map.sensors);
%     end
    
    % TODO: better condition for resampling
%     if mod(i,10) == 0
        p = resampling(p, map);
        plot_particles(p, map, i)
        drawnow
%     end % of resampling
    
end % of steps

% % sampling
% for m=1:M
%    % sample x_t[m] ~ p(x_t | u_t, x_t-1[m])
%    % w_t[m] = p(z_t | x_t[m])
%    % Xbar_t = Xbar_t + <x_t[m], w_t[m]>
% end
% 
% % importance sampling / resampling
% for m=1:M
%    % draw i with probability proportional to w_t[i]
%    % add x_t[i] to X_t
% end

