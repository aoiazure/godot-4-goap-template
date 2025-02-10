# Godot 4 GOAP template

A modified and somewhat expanded version of Vinicius Gerevini's [godot-goap](https://github.com/viniciusgerevini/godot-goap/) project. As such, it has similar asterisks: it is not heavily stress-tested and there may be some odd edge cases. Many thanks to him and his work.

This template expands on the original shifting to **typed functions** and **named classes**, allowing for better autocompletion and strictness to minimize errors.

To keep this template lean, there are no example files included; please refer to Vinicius's original project and video for examples. 

Feel free to modify as needed.
This template is licensed under the MIT license.

---

## What is GOAP?
A very brief overview of GOAP, or Goal Oriented Action Planning, is a method of creating dynamic video game artificial intelligence, first used in the F.E.A.R. series.

By being supplied a list of goals (*a desired end state*) and a list of possible actions (*an effect with a specified effect on the current state*) the agent, or acting character, can dynamically choose a series of actions (a *plan*) to reach a desired goal based on its current needs.

### Notes
While lending itself very well to emergent gameplay, it can also be unpredictable and require a lot of fine-tuning. However, when done effectively, it can lead to very powerful and impressive decision making.

Additionally, years of use by the gamedev community have led to some suggestions. While GOAP is good for decision making, it is less well suited for performing the gritty details of taking actions. Instead, it is suggested to use GOAP to choose a task, and have another system (perhaps a state machine) act on it. This allows for finer control of the action while still getting the benefits of the decision making.

---

## Basic Usage
0. Create some `GoapAction`s and `GoapGoal`s to use. Again, please refer to Vinicius's original project and video for examples. 

1. Create a new scene with your agent's desired root node.
    - (optional) extend `goap_base_pawn` with a reference to your agent's node type for autocompletion.
    ex: A `GoapCharacterBody2DPawn` would have a reference to your agent's `CharacterBody2D` node, perhaps via an `@export`.
2. Add the desired `Pawn` node to your agent.
    (optional) set the reference if you did the custom Pawn type.
3. Add the `GoapAgent` node to this agent.
    1. Instantiate a `GoapAgent` in code. `agent = GoapAgent.new()`
    2. Set the GoapAgent's `goap` property to the Pawn's. `agent.goap = self.goap`
    3. Add the GoapAgent as a child. `add_child(agent)`
4. In the agent's script (or the custom `Pawn`'s script), call `init(goals: Array[GoapGoal], actions: Array[GoapAction])` to initialize and set up the Pawn and its goals and actions. This is typically done in the `_ready()` function.

From here, the agent should now be able to act using its actions and goals, interacting with the `WorldState`.

### Pawn
The default `Pawn` has 2 utility functions for its Blackboard, known as `memorize(key, value)` and `recall(key, default = null)`. 

This information can be used to store information about the Pawn's status to make more dynamic and complicated `GoapAction` and `GoapGoal` types.

### WorldState
`WorldState` is an autoload that can be used to track changes in the game world via `set_state` and `get_state`.
* (optional) for further specificity and control, you could create a `WorldStateManager` and create many different `WorldState`s, which Agents only have access to a specific set of.
