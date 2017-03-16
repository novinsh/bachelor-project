function [ parsed_osm_o, sensors_o ] = convert2Cartesian(refPoint, parsed_osm, sensors)
%CONVERT2CARTESIAN Summary of this function goes here
%   Detailed explanation goes here

p.longtitude = parsed_osm.node.xy(1, :);
p.latitude = parsed_osm.node.xy(2, :);
[parsed_osm.node.xy(1, :), parsed_osm.node.xy(2, :)] = geo2cart(refPoint, p);

p.longtitude = parsed_osm.bounds(1, :);
p.latitude = parsed_osm.bounds(2, :);
[parsed_osm.bounds(1, :), parsed_osm.bounds(2, :)] = geo2cart(refPoint, p);

p.longtitude = sensors.lon;
p.latitude = sensors.lat;
[sensors.xy(1, :), sensors.xy(2, :)] = geo2cart(refPoint, p);

parsed_osm_o = parsed_osm;
sensors_o = sensors;

end

