if not(exist('msgs', 'Var'))
    msgs = loaddata('large1.bag');
end
figure(1);
for i = 1:10:size(msgs)
    [clusters, isObj] = generatecluster(msgs{i});
    plotcluster(clusters, isObj);
    drawnow;
end