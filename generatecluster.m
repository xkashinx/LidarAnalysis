function [clusters, isObj] = generatecluster(msg)
%GENERATECLUSTER Summary of this function goes here
%   Detailed explanation goes here
max_range = 65.533;
ranges_default(1:1081, 1) = max_range;
msg_base = msg.copy;
msg_base.Ranges = ranges_default;
msg_curr = msg_base.copy;
prev_range = msg.Ranges(1);
msg_curr.Ranges(1) = prev_range;
clusters = msg.copy;
isObj = 0;
rangeMax = msg.RangeMax;
count = 0;
for i = 2:1081
    msg_curr.Ranges(i) = msg.Ranges(i);
    if msg_curr.Ranges(i) <= rangeMax
        inRange = 1;
    end
    if abs(msg.Ranges(i) - prev_range) > 0.25
        if count > 10
            clusters = [clusters, msg_curr.copy];
            if count < 50
                isObj = [isObj, 1];
            else
                isObj = [isObj, 0];
            end
        end
        msg_curr = msg_base.copy;
        count = 0;
    else
        count = count + 1;
    end
    prev_range = msg.Ranges(i);
end
clusters = [clusters, msg_curr];
if count < 200
    isObj = [isObj, 1];
else
    isObj = [isObj, 0];
end

