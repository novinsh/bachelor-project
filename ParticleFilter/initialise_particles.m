function [p, map] = initialise_particles(map, n)

p = [];
p.n = n;

for i = 1:n
    % rand[0, x_upperbound] = width of the map
    p.x(i,1) = rand * map.parsed_osm.bounds(1, 2);
    % rand[0, y_upperbound] = height of the map
    p.y(i,1) = rand * map.parsed_osm.bounds(2, 2);  
    p.h(i,1) = (rand * 2*pi) - pi;  % rand[-pi, pi]
    p.w(i,1) = 1;
end

figure(map.fig)
p.fig = plot(p.x,p.y,'+','MarkerEdgeColor','b');
% linkdata on

