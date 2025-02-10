# Godot 4 GOAP template

A modified and somewhat expanded version of Vinicius Gerevini's [godot-goap](https://github.com/viniciusgerevini/godot-goap/) project. As such, it has similar asterisks: it is not heavily stress-tested and there may be some odd edge cases. Many thanks to him and his work.

This template expands on the original shifting to **typed functions** and **named classes**, allowing for better autocompletion and strictness to minimize errors.

To keep this template lean, there are no example files included; please refer to Vinicius's original project and video for examples. 

Feel free to modify as needed.
This template is licensed under the MIT license.

===

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

From here, the agent should now be able to act using its actions and goals, interacting with the WorldState.
