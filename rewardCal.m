function [r, isdone] = rewardCal(x,y,mapSize,angle)
    file = load("passedPositions.mat");
    passed = file.passed;
    map = 10*ones(mapSize,mapSize);
%     turnCost = angle*180/pi;
    turnCost = 0;
    if ismember(x*mapSize+y, passed)
        r = -5-turnCost;
    else
        try
            r = map(x,y)-turnCost;
        catch
            r = -10-turnCost;
        end
    end
    passed = [passed x*mapSize+y];
    save('passedPositions.mat','passed');
    isdone = length(passed) >= length(map)^2;
end