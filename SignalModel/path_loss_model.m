function Ploss = path_loss_model(d)
% estimating RSSI
K =  -40.0460;
gamma = 3;
d_0 = 1;

Ploss = K - 10 * gamma * log10(d/d_0);