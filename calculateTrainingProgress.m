load("savedAgents\Agent5000.mat", "savedAgentResult");
rewards = savedAgentResult.EpisodeReward;
counter = 0;
set = [];
average = [];
stddev = [];
rewards(2)
for i=1:length(rewards)
    counter=counter + 1;
    if counter == 12
        counter = 0;
        average = [average mean(set)];
        stddev = [stddev std(set)];
        set = [];
    end
    set = [set rewards(i)];
end
if ~isempty(set)
    average = [average mean(set)];
    stddev = [stddev std(set)];
    set = [];
end
lengthv = idivide(int16(length(rewards)),12,'ceil');
subplot(1,2,1);
plot(1:lengthv, average);
title("average per set of weights")
subplot(1,2,2);
plot(1:lengthv, stddev);
title("std per set of weights")
    