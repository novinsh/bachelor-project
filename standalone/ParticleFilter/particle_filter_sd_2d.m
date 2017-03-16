clc; clear all; close all;
set(0, 'DefaultFigureWindowStyle', 'docked');
   
P=struct;
P.n = 1000;   % number of samples
X = [0.1 0.5];  % process state i.e. axis x and y
z = [0 0];      % measurement state
N = [2 2];  % process noise
R = [4 4];  % measurement noise
timestep = 100; % number of iterations

v = 2;  % variance
P.x = zeros(P.n, 2);

% initialize particles
for i=1:P.n
   P.x(i, :) = X + sqrt(v) .* randn(1, 2); % TODO: findout about rand vs randn
end

%% plot initialized particles
figure(1);
clf;
subplot(121);
plot(P.x(:, 1), P.x(:, 2), '.');
% plot(P(1, :), 0, '.');    % only axis x
% plot(0, P(2, :), '.');    % only axis y

subplot(122);
hist3(P.x);
% hist(P(1, :), n); % only axis x
% hist(P(2, :), n);   % only axis y
pause

% generate observation
z_out = [X.^[2 3] ./ 20 + sqrt(R) .* randn];
x_out = [X];
x_est = [X];
x_est_out = [x_est];

%% rolling world
for t=1:timestep
   % actual position update
   X = [0.5 0.75].*X + [25 10].*X./(1 + X.^[2 3]) + [8*cos(1.2*(t-1)) 2*sin(1.2*(t-1))] +  sqrt(N)*randn;
%    X = [0.5 075].*X + [25 15].*X ./ (1 + X.^2) + [8*cos(1.2*(t-1)) 2*sin(1.2*(t-1))] +  sqrt(N)*randn;
   z = X.^[2 3]/20 + sqrt(R)*randn;
   
   %% particle filter
   for i=1:P.n
       % pf process update
       P.x_update(i, :) = ...
           [0.5 0.75] .* P.x(i, :) + [25 10] .* P.x(i, :) ./ (1 + P.x(i, :).^[2 3]) + [8*cos(1.2*(t-1)) 2*sin(1.2*(t-1))] + sqrt(N).*randn(1, 2);
       
       % pf measurement update
%        P.z_update(i, :) = [0.5 0.75].*P.x_update(i, :) + [25 10].*P.x_update(i, :)./(1 + P.x_update(i, :).^[2 3]);
       P.z_update(i, :) = P.x_update(i, :).^[2 3]./20; 
       
       % weight based on normal PDF
%        P.w(i, :) = (1./sqrt(2*pi.*R)) .* exp(-(z - P.z_update(i, :)).^2./(2.*R));
%        P.w(i, :) = (1./(sqrt(2*pi).*R)) .* exp(-(z - P.z_update(i, :)).^2./(2.*R.^2));
       P.w(i, :) = normpdf(z,P.z_update(i, :),R);
   end
   
   % normalize weight
   P.w = P.w ./ (ones(size(P.w, 1), 1) * sum(P.w));

   %% plots after PF operation
   %{
   figure(2);
   clf
   %%%%%%%%%%%%%%%%% dimension 1 %%%%%%%%%%%%%%%%%
   % particles after observation update
   subplot(221)
   plot(P.w(:, 1), P.z_update(:, 1), '.k');
   hold on;
   plot(0, z, '.r', 'markersize', 20);
   xlabel('weight magnitude');
   ylabel('observation (z)');
   % particles after process update
   subplot(222);
   plot(P.w(:, 1), P.x_update(:, 1), '.k');
   hold on;
   plot(0, X, '.r', 'markersize', 20);
   xlabel('weight magnitude');
   ylabel('process update (x)');
   %%%%%%%%%%%%%%%%% dimension 2 %%%%%%%%%%%%%%%%%
   subplot(223);
   plot(P.w(:, 2), P.z_update(:, 2), '.k');
   hold on;
   plot(0, z, '.r', 'markersize', 20);
   xlabel('weight magnitude');
   ylabel('observation (z)');
   hold off;
   % particles after process update
   subplot(224);
   plot(P.w(:, 2), P.x_update(:, 2), '.k');
   hold on;
   plot(0, X, '.r', 'markersize', 20);
   xlabel('weight magnitude');
   ylabel('process update (x)');
   pause
   %}
   
   % resampling
   for i=1:P.n
%       P.x(i, :) = P.x_update(find(rand <= cumsum(P.w(:, 1)), 1), :);
%       P.x(i, 2) = P.x_update(find(rand <= cumsum(P.w(i, 1)), 1), 2);
      P.x(i, :) = P.x_update(find((ones(size(P.w, 1), 1)*rand(1,2)) <= cumsum(P.w), 1), :); 
   end
   
   x_est = mean(P.x);
  
   %{
   figure(3)
   clf;   
   plot(P.x_update(:, 1), P.x_update(:, 2), '.b'); hold on;
   plot(P.x(:, 1), P.x(:, 2), '.r');
   plot(x_est(1), x_est(2), '.g', 'markersize', 20);
   xlim([-25 25]);
   ylim([-25 25]);
   hold off;
   pause(0.1);
   %}
   
   x_out = [x_out; X];
   z_out = [z_out; z];
   x_est_out = [x_est_out; x_est];
end

t=0:timestep;
figure(4);
subplot(121);
plot(t, x_out(:, 1), '.-r', t, x_est_out(:, 1), '.-b');%, t, z_out(:, 1), '.-g');
xlabel('time'); ylabel('position in X')
subplot(122);
plot(t, x_out(:, 2), '.-r', t, x_est_out(:, 2), '.-b');%, t, z_out(:, 1), '.-g');
xlabel('time'); ylabel('position in Y')