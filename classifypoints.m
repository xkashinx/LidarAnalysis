function [xOnLine,yOnLine,xNotOnLine,yNotOnLine] = classifypoints(x,y,r,th)
%CLASSIFYPOINTS classify lidar points as wall or not wall
%   Detailed explanation goes here

distanceThresh = 0.25; % in meters

% initialize params
xOnLine = zeros(721, 1);
yOnLine = zeros(721, 1);
xNotOnLine = zeros(721, 1);
yNotOnLine = zeros(721, 1);

% calculate r estimation
rHatRight = x(1:360)*cos(th(1))+y(1:360)*sin(th(1));
rHatLeft = x(361:721)*cos(th(2))+y(361:721)*sin(th(2));
rHat = [rHatRight; rHatLeft];

% classify points
onCount = 0;
notOnCount = 0;
for i=1:721
    if (abs(rHat(i) - r(floor(i/361) + 1)) < distanceThresh)
        onCount = onCount + 1;
        xOnLine(onCount) = x(i);
        yOnLine(onCount) = y(i);
    else
        notOnCount = notOnCount + 1;
        xNotOnLine(notOnCount) = x(i);
        yNotOnLine(notOnCount) = y(i);
    end
end

% cut off zeros of classified points
xOnLine = xOnLine(1:onCount);
yOnLine = yOnLine(1:onCount);
xNotOnLine = xNotOnLine(1:notOnCount);
yNotOnLine = yNotOnLine(1:notOnCount);
end

