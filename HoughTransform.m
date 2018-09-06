isSim = 1;
if not(exist('msgs', 'Var'))
    if isSim
        msgs = loaddata('lidar-straight-sim.bag', '/catvehicle/front_laser_points');
    else
        msgs = loaddata('lidar-camera.bag', '/scan');
    end
end
for i=1:10:size(msgs)
    % read 1 iteration of scan
    msg = msgs{i}.copy;
    if isSim
        msg.Ranges = msg.Ranges./7;
    end
	msg.Ranges(msg.Ranges > 10) = NaN;
    houghAccumulator = zeros(180, 2000, 'uint8');
    
    % calculate scan in cartesian coordinates
    theta = 0:pi/720:pi;
    xOrigScale = msg.Ranges(180:900) .* cos(theta)';
    yOrigScale = msg.Ranges(180:900) .* sin(theta)';

    % plot original lidar scan
    figure(1);
    subplot(2,2,1);
    scatter(xOrigScale, yOrigScale, '.');
    grid on;
    axis equal;
    hold on;

    % scale up x and y for hough transform calculation
    x = xOrigScale*100;
    y = yOrigScale*100;
    
    th = 0:1:179;
    d = round(x.*cos(pi.*th/180) + y.*(pi.*th/180))+1000;
    
    % obtain houghAccumulator matrix and hough transform lines
    rightMax = 0;
    leftMax = 0;
    horizonMax = 0;
    A = zeros(2, 3);
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
    xHough = linspace(-5,5,1001);
    th = double(A(:,1))/180*pi;
    r = double(A(:,2))/100;
    yHough = (r-xHough.*cos(th))./sin(th);
    scatter(xHough, yHough(1,:), '.');
    scatter(xHough, yHough(2,:), '.');
    axis([-10, 10, 0, 20]);
    hold off;
    subplot(2,2,[2,4]);
    mesh(houghAccumulator);
    hold on
    scatter(A(1,2)+1000, A(1,1), 'r');
    scatter(A(2,2)+1000, A(2,1), 'g');
    view([0,90]);
    xlabel('r(cm)');
    ylabel('th(deg)');
    hold off
    subplot(2,2,3);
    [xOnLine, yOnLine, xNotOnLine, yNotOnLine] = classifypoints(xOrigScale, yOrigScale, r, th);
    scatter(xOnLine, yOnLine, '.r');
    grid on
    axis equal;
    axis([-10, 10, 0, 20]);
    hold on
    scatter(xNotOnLine, yNotOnLine, '.g');
    scatter(xHough, yHough(1,:), '.b');
    scatter(xHough, yHough(2,:), '.b');
    % legend('on line', 'not on line');
    
    hold off;
    drawnow;
end