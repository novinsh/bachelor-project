function [ X_new, P_new ] = kf_update(Z, X, P, C, R)
%COMPASS_UPDATE Summary of this function goes here
%   Detailed explanation goes here
K = P * C' * inv(C * P * C' + R);
X_new = X + K * (Z - C * X);
P_new = (eye(size(X, 1))- K * C) * P;
end

