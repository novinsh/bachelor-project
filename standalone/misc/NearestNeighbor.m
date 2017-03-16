clear all;
close all;
clc;

numOfAnchors = 7;
numOfTest = 10;

figure(1);

ylim([-50 50])
xlim([-20 20])

anchors = ginput(numOfAnchors);
labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'];

hold on;
for i=1:numOfAnchors
    plot(anchors(i, 1), anchors(i, 2), '*');
    text(anchors(i, 1), anchors(i, 2), labels(i));
end

for i=1:numOfTest

    nonAnchorPoint = ginput(1);

    plot(nonAnchorPoint(1), nonAnchorPoint(2), 'r*');
    text(nonAnchorPoint(1), nonAnchorPoint(2), 'X');


    % nearest neighbour
    sum = 0;
    w = [];
    x = 0;
    y = 0;

    for i=1:numOfAnchors
        anchors(i, 3) = sqrt((nonAnchorPoint(1)-anchors(i, 1))^2+(nonAnchorPoint(2)-anchors(i, 2))^2);
        sum = sum + 1/anchors(i, 3);
    end

    for i=1:numOfAnchors
       w(i) = 1/(anchors(i, 3)*sum); 
    end

    for i=1:numOfAnchors
        x = x + anchors(i, 1)*w(i);
        y = y + anchors(i, 2)*w(i);
    end

    plot(x, y, 'black*');
    text(x, y, 'NN');

end