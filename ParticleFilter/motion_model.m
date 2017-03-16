function pnew = motion_model(p, u)
% motion model
su = 0.1;
sh = 15*pi/180; % 15 degree in radian

for i = 1:p.n
    p.h(i) = mod(p.h(i) + randn * sh, 2*pi);
    d = R2d(p.h(i)) * [(2*u + randn*su)-u; 0];
    p.x(i) = p.x(i) + d(1) + 0.1*rand - 0.05;
    p.y(i) = p.y(i) + d(2) + 0.1*rand - 0.05;
end

pnew = p;