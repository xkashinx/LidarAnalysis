function [clusters] = scanCluster(msg)
%SCANCLUSTER Summary of this function goes here
%   Detailed explanation goes here
max_range = 60;
ranges_default(1:1081, 1) = max_range;
msg_base = msg.copy;
msg_base.Ranges = ranges_default;
msg_curr = msg_base.copy;
prev_range = msg.Ranges(1);
msg_curr.Ranges(1) = prev_range;
clusters = msg.copy;

size = 0;
for i = 2:1081
    msg_curr.Ranges(i) = msg.Ranges(i);
    if abs(msg.Ranges(i) - prev_range) > 0.25
        if size > 10
            clusters = [clusters, msg_curr.copy];
        end
        msg_curr = msg_base.copy;
        size = 0;
    else
        size = size + 1;
    end
    prev_range = msg.Ranges(i);
end
clusters = [clusters, msg_curr];

