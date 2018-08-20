% clc 
% clear
figure(1);

for i = 1:size(msgs)
    plot(msgs{i}, 'MaximumRange', 10);
    pause(0.02);
end