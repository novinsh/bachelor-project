function pnew = observation_model(p, z, sensors)
% observation model

w = ones(p.n,1);
kachal = true;
for i = 1:p.n
    dist = dist2Sensor([p.x(i);p.y(i)], sensors);
    for j = 1:length(z)
        % FIXME: there might be some cases that no valid measurement exist
        % (handle in resampling)
        if z(j) ~= -130
            kachal = false;
            d = inv_path_loss_model(z(j));
            w(i) = w(i) * lognpdf(d,dist(j),1); % multi. for effect of all sensors
        end
    end
end
if(kachal)
    disp('kachalid');
end

for i = 1:p.n
    p.w(i) = w(i) * 0.9999 + 0.0001;    % add a constant noise
end

figure(2);
hist(p.w);
% pause

pnew = p;


function dist = dist2Sensor(p,sensors)
n = size(sensors.xy,2);
dist = zeros(n,1);

for i = 1:size(sensors.xy,2)
    dist(i) = sqrt((p(1)-sensors.xy(1, i))^2 + (p(2)-sensors.xy(2, i))^2);
end