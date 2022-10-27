import gym_examples
import gym

env = gym.make('gym_examples/GridWorld-v0',render_mode = 'human', size = 10)

env.action_space.seed(42)

observation, info = env.reset(seed=42)

for _ in range(1000):
    observation, reward, terminated, truncated, info = env.step(env.action_space.sample())

    if terminated or truncated:
        observation, info = env.reset()

env.close()

