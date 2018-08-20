
figure(1);
for i = 1:10:size(msgs)
    clusters = scanCluster(msgs{i});
    plotClusters(clusters, msg);
    [a, num] = size(clusters);
    [i, "/", size(msgs), num]
    drawnow;
end