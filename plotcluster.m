function plotcluster(clusters, isObj)
%PLOTCLUSTER Summary of this function goes here
%   Detailed explanation goes here
[a, num] = size(clusters);

for i = 2:num
    line = plot(clusters(i), 'MaximumRange', 10);
    disp(i);
    if isObj(i)
        line.Color = 'r';
    else
        line.Color = 'b';
    end
    hold on;
end
disp('end');
hold off;
end

