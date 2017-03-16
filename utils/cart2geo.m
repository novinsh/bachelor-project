function [ resultLatitude, resultLongtitude ] = cart2geo( relativeNullPoint, p )
%CART2GEO Summary of this function goes here
%   Detailed explanation goes here

latitudeCircumference = 40075160 * cos(toRadian(relativeNullPoint.latitude))

deltaLongtitude = p.x * 360 / latitudeCircumference
deltaLatitude = p.y * 360 / 40008000

resultLatitude = deltaLatitude + relativeNullPoint.latitude
resultLongtitude = deltaLongtitude + relativeNullPoint.longtitude

end


function theta = toRadian( deg )
theta = deg * pi / 180;
end