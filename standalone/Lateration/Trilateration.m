% A simple trilateration for the aim of testing its function

clear all;
close all;

% circle = [x y];
circleA = [10 49];
circleB = [50 0];
circleC = [60 50];

figure(1);
plot(circleA(1), circleA(2), '*');
text(circleA(1)+1, circleA(2)+1, 'A');
hold on;
plot(circleB(1), circleB(2), '*');
text(circleB(1)+1, circleB(2)+1, 'B');
plot(circleC(1), circleC(2), '*');
text(circleC(1)+1, circleC(2)+1, 'C');
xlim([-100 100]);
ylim([-100 100]);

% get position
knownPoint = ginput(1);

d1 = sqrt((knownPoint(1)-circleA(1))^2+(knownPoint(2)-circleA(2))^2)
d2 = sqrt((knownPoint(1)-circleB(1))^2+(knownPoint(2)-circleB(2))^2)
d3 = sqrt((knownPoint(1)-circleC(1))^2+(knownPoint(2)-circleC(2))^2)

% radius of the circles
dA = [d1];
dB = [d2];
dC = [d3];

% draw circles
ang=0:0.01:2*pi; 
xp=dA*cos(ang);
yp=dA*sin(ang);
plot(circleA(1)+xp,circleA(2)+yp);
xp=dB*cos(ang);
yp=dB*sin(ang);
plot(circleB(1)+xp,circleB(2)+yp);
xp=dC*cos(ang);
yp=dC*sin(ang);
plot(circleC(1)+xp,circleC(2)+yp);


% Matrix X Nominator
Xa = (dA^2 - dB^2) - (circleA(1)^2 - circleB(1)^2) - (circleA(2)^2 - circleB(2)^2);
Xb = 2 * (circleB(2) - circleA(2));
Xc = (dA^2 - dC^2) - (circleA(1)^2 - circleC(1)^2) - (circleA(2)^2 - circleC(2)^2);
Xd = 2 * (circleC(2) - circleA(2));

% Matrix Y Nominator
Ya = 2 * (circleB(1) - circleA(1));
Yb = (dA^2 - dB^2) - (circleA(1)^2 - circleB(1)^2) - (circleA(2)^2 - circleB(2)^2);
Yc = 2 * (circleC(1) - circleA(1));
Yd = (dA^2 - dC^2) - (circleA(1)^2 - circleC(1)^2) - (circleA(2)^2 - circleC(2)^2);

% Common Denominator
Da = 2 * (circleB(1) - circleA(1));
Db = 2 * (circleB(2) - circleA(2));
Dc = 2 * (circleC(1) - circleA(1));
Dd = 2 * (circleC(2) - circleA(2));

X = [Xa Xb; Xc Xd];
Y = [Ya Yb; Yc Yd];
Denominator = [Da Db; Dc Dd];

if det(Denominator) == 0
    error('Zero value denominator!');
end

x = det(X) / det(Denominator)
y = det(Y) / det(Denominator)

plot(x, y, 'r*');
% text(x+2, y+1, 'Trilat.');

% nearest neighbour
sum = 1/dA + 1/dB + 1/dC
w = [1/(dA*sum) 1/(dB*sum) 1/(dC*sum)]

nn_x = circleA(1)*w(1) + circleB(1)*w(2) + circleC(1)*w(3)
nn_y = circleA(2)*w(1) + circleB(2)*w(2) + circleC(2)*w(3)

plot(nn_x, nn_y, 'black*');
text(nn_x+2, nn_y+1, 'NN');