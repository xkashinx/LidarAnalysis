msgs = loaddata('large1.bag');
figure(1);
for i = 1:10:size(msgs)
    clusters = generatecluster(msgs{i});
    plotcluster(clusters, msgs{i}.copy);
    drawnow;
end