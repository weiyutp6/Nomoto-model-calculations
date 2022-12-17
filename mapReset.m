function mapReset()
    %% replace training map with original map
    file = load('originalMap.mat');
    savedMap = file.mapMatrix;
    mapMatrix = savedMap;
    save('map.mat','mapMatrix');
    %% reset Nomoto Model input
    newArray = [];
    save('signal.mat',"newArray");
end