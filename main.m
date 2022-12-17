%% model parameters
Ts = 1;
mapSize = 10;

%% map creation and load simulink model
mdl = 'rlattempt1';
open_system(mdl)
% mapMatrix = map_creator();
mapMatrix = 50*ones(mapSize,mapSize);
% set_param(mdl, 'AlgebraicLoopSolver', 'Auto');
totalReward = sum(mapMatrix,"all");
save('originalMap','mapMatrix');
mapReset();

%% define agent input and output
observationInfo = rlNumericSpec([2 1],'LowerLimit',ones(2,1),...
    'UpperLimit',mapSize*ones(2,1));
observationInfo.Name = 'observations';
actionInfo = rlFiniteSetSpec((0:15)*pi/180);
actionInfo.Name = "rudder angle";

%% create matlab training environment
env = rlSimulinkEnv(mdl,[mdl '/reinforcement learning'],observationInfo,...
    actionInfo);
env.ResetFcn = @(in)localResetFcn(in);

%% define DQN
nI = observationInfo.Dimension(1);  % number of inputs (2)
nL = 12;                           % number of neurons
nO = numel(actionInfo.Elements);    % number of outputs (16)

dnn = [
    featureInputLayer(nI,'Normalization','none','Name','state')
    fullyConnectedLayer(nL,'Name','fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(nL,'Name','fc2')
    reluLayer('Name','relu2')
    fullyConnectedLayer(nO,'Name','fc3')];
dnn = dlnetwork(dnn);

%% define training parameters
W0 = ones();
criticOptions = rlOptimizerOptions('LearnRate',1e-4,...
    'GradientThreshold',1,'L2RegularizationFactor',1e-4);
critic = rlVectorQValueFunction(dnn,observationInfo,actionInfo,...
    'UseDevice','gpu');
agentOpts = rlDQNAgentOptions(...
    'SampleTime',Ts,...
    'UseDoubleDQN',true,...
    'CriticOptimizerOptions',criticOptions,...
    'ExperienceBufferLength',1e4,...
    'MiniBatchSize',64);

% agentOpts.EpsilonGreedyExploration.EpsilonDecay = 1e-4;
agent = rlDQNAgent(critic, agentOpts);

trainOpts = rlTrainingOptions(...
    'MaxEpisodes', 200, ...
    'MaxStepsPerEpisode', 800, ...
    'Verbose', true, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','EpisodeReward',...
    'ScoreAveragingWindowLength',100,...
    'StopTrainingValue',totalReward-500,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',totalReward-1000);
%     'UseParallel',true);
% trainOpts.ParallelizationOptions.Mode = 'sync';

%% training
doTraining = true;
if doTraining
    trainingStats = train(agent,env,trainOpts);
    save("trainingResult.mat",'trainingStats')
else
    load('trainingResult.mat','agent');
end
simOptions = rlSimulationOptions('MaxSteps',800);
experience = sim(env,agent,simOptions);

totalReward = sum(experience.Reward)