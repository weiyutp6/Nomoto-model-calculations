function map = map_creator()
    pd = makedist("Normal","mu", 50,"sigma",20);
    mapMatrix = round(random(pd,[60,60]));
    for i = 1:60
        for j  = 1:60
            if mapMatrix(i,j)<0
                mapMatrix(i,j)=0;
            end
        end
    end
%     mapMatrix
    mapScale = 1;
    
    fig = figure("Name","simpleMap");
    set(fig, "Visible","on");
    ax = axes(fig);
    
%     show(binaryOccupancyMap(mapMatrix),"Parent",ax);
    map = mapMatrix;
end