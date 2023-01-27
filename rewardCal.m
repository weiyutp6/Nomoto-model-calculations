function [r, isdone] = rewardCal(x,y,mapSize)
    file = load("passedPositions.mat");
    passed = file.passed;
    map = 10*ones(mapSize,mapSize);
    if ismember(x*mapSize+y, passed)
        r = -5;
    else
        try
            r = map(x,y);
        catch
            r = -10;
        end
    end
    passed = [passed x*mapSize+y];
    save('passedPositions.mat','passed');
    isdone = length(passed) >= length(map)^2;
end