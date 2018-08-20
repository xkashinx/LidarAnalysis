function [msgs] = getScanData(filepath)
%GETSCANDATA Summary of this function goes here
%   Detailed explanation goes here
bagfile = rosbag(filepath);
scan = select(bagfile, 'Topic', '/scan');
msgs = readMessages(scan);
end

