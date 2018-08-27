function [msgs] = loaddata(filepath, topicname)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here
disp('loading...');
bagfile = rosbag(filepath);
scan = select(bagfile, 'Topic', topicname);
msgs = readMessages(scan);
clc
end

