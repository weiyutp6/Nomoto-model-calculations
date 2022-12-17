function [r, map] = mapUpdate(x,y,mapSize)
    file = load("map.mat");
    mapMat = file.mapMatrix;
    mapMatrix = zeros(mapSize,mapSize);
    % change training map to remove oysters from a coord
    try
        r = int(mapMat(x,y));
        mapMat(x,y) = 0;
        mapMatrix = mapMat;
        save("map.mat","mapMatrix");
    catch
        r = 0;
    end
    map = mapMatrix;
end