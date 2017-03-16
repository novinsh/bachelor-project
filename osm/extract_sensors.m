function sensors = extract_sensors( osm_xml )
%EXTRACT_SENSORS Summary of this function goes here
%   Detailed explanation goes here

sensors = struct;
nodeSize = length(osm_xml.node);
sIdx = 1;   % sensor index

for i=1:nodeSize % navigate nodes
    if isfield(osm_xml.node{1, i}, 'tag') == 1  % if node has a tag
        tagSize = length(osm_xml.node{1, i}.tag);
        
        sensorTmp = struct; % probable sensor data (node)
        sensorTmp.brand = '';
        sensorTmp.mac = '';
        sensorTmp.ssid = '';
        sensorTmp.type = '';
        sensorNodeValid = false;
        
        for j=1:tagSize % navigate labels of the tag
            % find desired labels within the tag
            switch osm_xml.node{1, i}.tag{1, j}.Attributes.k
                case 'ap_brand'
                    sensorTmp.brand = ...
                        osm_xml.node{1, i}.tag{1, j}.Attributes.v;
                case 'ap_mac'
                    sensorTmp.mac = ...
                        osm_xml.node{1, i}.tag{1, j}.Attributes.v;
                case 'ap_ssid'
                    sensorTmp.ssid = ...
                        osm_xml.node{1, i}.tag{1, j}.Attributes.v;
                case 'ap_type'
                    sensorTmp.type = ...
                        osm_xml.node{1, i}.tag{1, j}.Attributes.v;
                case 'name'
                    % this node is a sensor provided that its got a label
                    % with the name of 'AP'
                    if strcmp(osm_xml.node{1, i}.tag{1, j}.Attributes.v,'AP')
                        sensorNodeValid = true;
                    end
            end % of switch
        end % of loop for tags
        
        % copy as an array of sensor data within sensors struct
        if sensorNodeValid == true
            sensors.brand{sIdx} = sensorTmp.brand;
            sensors.mac{sIdx} = sensorTmp.mac;
            sensors.ssid{sIdx} = sensorTmp.ssid;
            sensors.type{sIdx} = sensorTmp.type;
            sensors.lat(sIdx) = str2double(osm_xml.node{1, i}.Attributes.lat);
            sensors.lon(sIdx) = str2double(osm_xml.node{1, i}.Attributes.lon);
            sIdx = sIdx + 1;
        end
        
    end % of checking tag condition
end % of navigating nodes loop