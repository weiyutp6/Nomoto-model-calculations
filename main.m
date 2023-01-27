%% model parameters
Ts = 1;
mapSize = 10;

%% map creation and load simulink model
mdl = 'rlattempt1';
open_system(mdl)
% mapMatrix = map_creator();
mapMatrix = 10*ones(mapSize,mapSize);   % temp map
% set_param(mdl, 'AlgebraicLoopSolver', 'Auto');
% totalReward = sum(mapMatrix,"all");
save('originalMap','mapMatrix');
mapReset();

%% define agent input and output
observationInfo = rlNumericSpec([2 1],'LowerLimit',ones(2,1),...
    'UpperLimit',mapSize*ones(2,1));            % coordinates
observationInfo.Name = 'observations';
actionInfo = rlFiniteSetSpec((0:15)*pi/180);    % possible rudder angles
actionInfo.Name = "rudder angle";

%% create matlab training environment
env = rlSimulinkEnv(mdl,[mdl '/reinforcement learning'],observationInfo,...
    actionInfo);
env.ResetFcn = @(in)localResetFcn(in);

%% define DQN
nI = observationInfo.Dimension(1);  % number of inputs (2)
nL = 12;                            % number of neurons for each layer
nO = numel(actionInfo.Elements);    % number of outputs (16)

dnn = [
    featureInputLayer(nI,'Normalization','none','Name','state')
    fullyConnectedLayer(nL,'Name','fc1')
    reluLayer('Name','relu1')
    fullyConnectedLayer(nL,'Name','fc2')
    reluLayer('Name','relu2')
%     fullyConnectedLayer(nL,'Name','fc3')
%     reluLayer('Name','relu2')
    fullyConnectedLayer(nO,'Name','fc4')];
dnn = dlnetwork(dnn);

%% define training parameters
% W0 = ones();
criticOptions = rlOptimizerOptions('LearnRate',1e-4,...
    'GradientThreshold',1,'L2RegularizationFactor',1e-4);
critic = rlVectorQValueFunction(dnn,observationInfo,actionInfo,...
    'UseDevice','gpu');
agentOpts = rlDQNAgentOptions(...
    'SampleTime',Ts,...
    'UseDoubleDQN',true,...
    'CriticOptimizerOptions',criticOptions,...
    'ExperienceBufferLength',1e5,...
    'MiniBatchSize',128);

% agentOpts.EpsilonGreedyExploration.EpsilonDecay = 1e-4;
agent = rlDQNAgent(critic, agentOpts);

trainOpts = rlTrainingOptions(...
    'MaxEpisodes', 5000, ...
    'MaxStepsPerEpisode', 10, ...
    'Verbose', true, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','EpisodeReward',...
    'ScoreAveragingWindowLength',100,...
    'StopTrainingValue',600,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',-600,...
    'UseParallel',true);
trainOpts.ParallelizationOptions.Mode = 'sync';

%% training
doTraining = false;
if doTraining
    delete("savedAgents\*.mat")
    trainingStats = train(agent,env,trainOpts);
    save("trainingResult.mat",'trainingStats')
else
    load('savedAgents\Agent5000.mat','savedAgentResult');
%     load("savedAgents\Agent5000.mat",'saved_agent')
%     load('trainingResult.mat','trainingStats');
    inspectTrainingResult(savedAgentResult)
end
simOptions = rlSimulationOptions('MaxSteps',60);
experience = sim(env,agent,simOptions);

totalReward = sum(experience.Reward)