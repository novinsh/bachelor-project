function d = inv_path_loss_model(RSSI)
% estimating distance from the measured RSSI
% Pr = Tx + K - 10 * gamma * log10(d/d0)
A = -72; % A = Tx + K
gamma = 3;
% d_0 = 1;

d = 10.^((A - RSSI)/(10*gamma));