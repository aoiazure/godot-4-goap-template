## Base Pawn class that is used for GOAP processing.
## You can extend this class to point to a specific node type to use its functions.
class_name Pawn extends Node

@export var agent: GoapAgent

#region Goal oriented action planning
## Establish the pawn's initial goals and actions.
func init(goals: Array[GoapGoal], actions: Array[GoapAction]) -> void:
	agent.init(self, goals)
	agent.goap.set_actions(self, actions)

## Stop the current plan.
func interrupt_plan() -> void:
	agent.interrupt()

## Begin processing.
func start() -> void:
	set_process(true)
	agent.set_process(true)

## Cease processing.
func stop() -> void:
	set_process(false)
	agent.set_process(false)

#endregion

#region Memory functions
## Memory
func memorize(key, value) -> void:
	if not is_node_ready():
		await ready
	agent.memorize(key, value)

func recall(key, default = null):
	if not is_instance_valid(agent): return default
	return agent.recall(key, default)

#endregion
