function visualizer(x,y,mapSize,angle)
    ax = gca;
    ax.FontSize = 12;
    ax.TickDir = 'out';
    ax.XLim = [1 mapSize];
    ax.YLim = [1 mapSize];
    grid on;
    hold on;
    plot(x,y,'Marker','.')
    hold on;
    title('path')
    drawnow
    file = load('path.mat');
    xmat = [file.x x];
    ymat = [file.y y];
    x = xmat;
    y = ymat;
    save('path.mat','x','y');
    file = load("angle.mat");
    anglePrevious = [file.anglePrevious angle];
    save("angle.mat", "anglePrevious");
end