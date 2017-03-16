function map = build_map( openstreetmap_filename , observation_filename)
%MAPBUILDER Summary of this function goes here
%   Detailed explanation goes here

%% xml -> struct
[parsed_osm, osm_xml] = parse_openstreetmap(openstreetmap_filename);
map.osm_xml = osm_xml;

%% find sensors
sensors = extract_sensors(osm_xml);

%% geodetic -> cartesian (with min point as the origin)
% TODO: perhaps put this conversion earlier
refPoint.latitude = parsed_osm.bounds(2,1); 
refPoint.longtitude = parsed_osm.bounds(1,1);
% map height and width equals bounds of the map in cartesian!
[map.parsed_osm, map.sensors] = convert2Cartesian(refPoint, parsed_osm, sensors);

%% load log files
% TODO: load observations here
% find(ismember(map.sensors.mac, 'C4:BE:84:08:49:A8'));
observation = load(observation_filename);
map.data = observation.data;
% map.data(112:1012, :) = ones(1, 1:1012) .* observation.data(111);
% map.groundTruthData = zeros(100, 1);

%% plots
% setup figure and plot
fig = figure;
ax = axes('Parent', fig);
hold(ax, 'on')

% plot way and nodes
plotlabels.xaxis = 'X (m)';
plotlabels.yaxis = 'Y (m)';
plotlabels.title = 'SRC Map';
plot_way(ax, map.parsed_osm, plotlabels)
plotmd(ax, map.sensors.xy, '.r');

% hold(ax, 'off')

map.fig = fig;

end

