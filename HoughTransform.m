if not(exist('msgs', 'Var'))
    msgs = loaddata('large1.bag');
end
for i=1:10:1000
    msg = msgs{i};
	msg.Ranges(msg.Ranges > 10) = NaN;
    houghAccumulator = zeros(180, 2000, 'uint8');
    theta = -1/4*pi:3/2*pi/1080:5/4*pi;
    x = msg.Ranges .* cos(theta)'*100;
    y = msg.Ranges .* sin(theta)'*100;

    scatter(x, y, '.');
    grid on;
    axis equal;
    hold on;

    th = 0:1:179;
    d = round(x.*cos(pi.*th/180) + y.*(pi.*th/180))+1000;
    maxSum = 0;
    for th=1:180
        for r=1:2000
            houghAccumulator(th,r) = sum(d(:,th) == r);
            if (houghAccumulator(th,r) > maxSum)
                maxSum = houghAccumulator(th,r);
                A = [th, int32(r)-1000, maxSum];
            end
        end
    end
    xHough = linspace(-500,500,1001);
    th = double(A(1))/180;
    r = double(A(2));
    yHough = (r-xHough*cos(th))/sin(th);
    scatter(xHough, yHough, '.');
    axis([-1000, 1000, -1000, 2000]);
    hold off;
    drawnow;
end