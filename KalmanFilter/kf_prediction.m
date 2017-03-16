function [ X_new, P_new ] = kf_prediction(A, X, P, Q, B, u, w)
%PREDICTION Summary of this function goes here
%   Detailed explanation goes here

if nargin < 7
    w = 0;
end

if nargin < 6 || nargin < 5
    w = 0;
    u = 0;
    B = 0;
end

X_new = A * X + B * u + w;
P_new = A * P * A' + Q;
end

