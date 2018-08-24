if not(exist('msgs', 'Var'))
    msgs = loaddata('lidar-camera.bag');
end
for i=1:10:size(msgs)
    msg = msgs{i}.copy;
	msg.Ranges(msg.Ranges > 10) = NaN;
    houghAccumulator = zeros(180, 2000, 'uint8');
    
    % calculate scan in cartesian coordinates
    theta = 0:pi/720:pi;
    x = msg.Ranges(180:900) .* cos(theta)'*100;
    y = msg.Ranges(180:900) .* sin(theta)'*100;

    % plot original lidar scan
    subplot(1,2,1);
    scatter(x, y, '.');
    grid on;
    axis equal;
    hold on;

    th = 0:1:179;
    d = round(x.*cos(pi.*th/180) + y.*(pi.*th/180))+1000;
    
    % obtain houghAccumulator matrix and hough transform lines
    rightMax = 0;
    leftMax = 0;
    horizonMax = 0;
    A = zeros(3, 3);
    for th=1:180
        for theta=1:721
            r = d(theta, th);
            if r > 2000 || isnan(r)
                continue;
            end
            houghAccumulator(th, r) = houghAccumulator(th, r) + 1;
            if th < 60
                if r > 1000 && houghAccumulator(th,r) > rightMax
                    rightMax = houghAccumulator(th,r);
                    A(1, :) = [th, int32(r)-1000, rightMax];
                elseif r < 1000 && houghAccumulator(th,r) > leftMax
                    leftMax = houghAccumulator(th, r);
                    A(2, :) = [th, int32(r)-1000, leftMax];
                end
            end
        end
    end
    
    % calculate line in cartesian and plot
    xHough = linspace(-500,500,1001);
    th = double(A(:,1))/180;
    r = double(A(:,2));
    yHough = (r-xHough.*cos(th))./sin(th);
    scatter(xHough, yHough(1,:), '.');
    scatter(xHough, yHough(2,:), '.');
    axis([-1000, 1000, 0, 2000]);
    hold off;
    subplot(1,2,2);
    mesh(houghAccumulator);
    hold on
    scatter(A(1,2)+1000, A(1,1), 'r');
    scatter(A(2,2)+1000, A(2,1), 'g');
    view([0,90]);
    xlabel('r(cm)');
    ylabel('th(deg)');
    hold off
    drawnow;
end