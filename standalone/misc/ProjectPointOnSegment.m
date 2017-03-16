%%
% uesful links: 
%   - http://www.alecjacobson.com/weblog/?p=1486
%   - http://intumath.org/Math/Geometry/Analytic%20Geometry/projectionofpoin.html
%%

clear all;
clc;
close all;

figure(1); hold on;

ylim([0 15])
xlim([0 15])

A = [10 10];
B = [5 5];

if A(1) < B(1)
    x = A(1):0.1:B(1);
else
    x = B(1):0.1:A(1);
end

m = (A(2)-B(2))/(A(1)-B(1));
y = m * (x - A(1)) + A(2);

plot(x, y);
plot(A(1), A(2), 'b*');
text(A(1), A(2), 'A');
plot(B(1), B(2), 'b*');
text(B(1), B(2), 'B');

for i=3:0.5:12
    
    p = [i 2];
    
    % vector from A to B
    AB = (B-A);
    % squared distance from A to B
    AB_squared = dot(AB,AB);
    if(AB_squared == 0)
        % A and B are the same point
        q = A;
    else
        % vector from A to p
        Ap = (p-A);
        % from http://stackoverflow.com/questions/849211/
        % Consider the line extending the segment, parameterized as A + t (B - A)
        % We find projection of point p onto the line.
        % It falls where t = [(p-A) . (B-A)] / |B-A|^2
        t = dot(Ap,AB)/AB_squared
        if (t < 0.0)
            % "Before" A on the line, just return A
            q = A;
        else if (t > 1.0)
                % "After" B on the line, just return B
                q = B;
            else
                % projection lines "inbetween" A and B on the line
                q = A + t * AB;
            end
        end
    end
    
    plot(p(1), p(2), 'red*');
    text(p(1), p(2), 'p');
    plot(q(1), q(2), 'red.');
%     text(q(1), q(2), 'q');
    
    pause(0.1);
end