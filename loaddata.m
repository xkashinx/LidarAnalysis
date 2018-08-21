function [msgs] = loaddata(filepath)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here
disp('loading...');
bagfile = rosbag(filepath);
scan = select(bagfile, 'Topic', '/scan');
msgs = readMessages(scan);
clc
end

