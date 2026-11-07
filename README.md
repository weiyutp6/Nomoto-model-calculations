# Ship Steering Dynamics: System Identification and Reinforcement Learning (MATLAB / Simulink)

Models a ship's yaw response to rudder input with a Nomoto transfer function. It fits the model parameters from data by system identification, then trains a reinforcement-learning agent to steer over a grid.

## Parts

### 1. Second-order Nomoto model (`nomoto.m`)

The transfer function from rudder angle to yaw angle:

```
G(s) = K (T3 s + 1) / ( s (T1 T2 s^2 + (T1 + T2) s + 1) )
```

The script simulates it with `lsim` and integrates the yaw angle into x-y coordinates. Simulated U-turns and 90/180-degree turns are in `simresults/`.

### 2. System identification (`systemidentification.m`)

Fits a transfer function to yaw-rate data with `tfest` (2 poles, 1 zero), then solves symbolically for `T1`, `T2`, `T3` and `K`. The result is saved to `nomoto_coef.mat`.

### 3. Symbolic version (`nomotoSyms.m`)

Computes the response with the Symbolic Math Toolbox. It maps the input through a Tustin (bilinear) approximation and applies an inverse Laplace transform.

### 4. Reinforcement learning (`main.m`, `rlattempt1.slx`, `rewardCal.m`)

An experimental DQN agent in a Simulink environment.

| Item | Setting |
|---|---|
| State | (x, y) grid position |
| Actions | 16 discrete rudder angles, 0 to 15 degrees |
| Reward | +10 for a new cell, -5 for a revisit, -10 for leaving the map |
| Network | 2 inputs, fully connected layers (12 neurons each), 16 outputs |
| Goal | Cover the 10 x 10 grid |

Status: early attempt. The reward does not yet penalise turning cost (`turnCost` is set to 0 for now).

## Run

Requires MATLAB with Simulink, Control System Toolbox, System Identification Toolbox, Symbolic Math Toolbox and Reinforcement Learning Toolbox.

```matlab
nomoto          % simulate the model
systemidentification   % fit parameters from input.mat and derivative.mat
main            % train the RL agent
```

## Repository layout

```
*.m, rlattempt1.slx   scripts and the Simulink environment
nomoto_coef.mat       identified coefficients
simresults/           simulated turn trajectories and plots
```

## Skills demonstrated

Transfer-function modelling, parameter estimation, Laplace and Z-transform methods, discrete-time approximation, reinforcement learning (DQN), MATLAB and Simulink.
