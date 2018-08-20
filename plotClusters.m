function plotClusters(clusters, msg)
%PLOTCLUSTERSSIMPLE Summary of this function goes here
%   Detailed explanation goes here
max_range = max(msg.Ranges);
ranges_default(1:1081, 1) = max_range;
msg_base = msg.copy;
msg_base.Ranges = ranges_default;
[a, num] = size(clusters);

for i = 2:num
    plot(clusters(i), 'MaximumRange', 10);
    hold on;
end
hold off;
end

