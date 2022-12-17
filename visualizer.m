function visualizer(x,y)
    ax = gca;
    ax.FontSize = 12;
    ax.TickDir = 'out';
    ax.XLim = [1 60];
    ax.YLim = [1 60];
    grid on;
    hold on;
    plot(x,y,'Marker','.')
    hold on;
    title('path')
    drawnow
end