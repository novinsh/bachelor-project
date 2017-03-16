function [ resultX, resultY ] = geo2cart(relativeNullPoint, p)
%G2C Summary of this function goes here
%   Detailed explanation goes here

deltaLatitude = p.latitude - relativeNullPoint.latitude;
deltaLongtitude = p.longtitude - relativeNullPoint.longtitude;

latitudeCircumference = 40075160 * cos(toRadian(relativeNullPoint.latitude));

resultX = deltaLongtitude * latitudeCircumference / 360;
resultY = deltaLatitude * 40008000 / 360;

end

function theta = toRadian( deg )
theta = deg * pi / 180;
end