# meta-default: true
extends GoapGoal

## Returns the name of the goal.
func get_goal_name() -> String:
	return "_CLASS_"


## Called when this Goal is chosen to be acted on.
## Can be used to initialize settings for this goal.
func choose(_pawn: Pawn) -> void:
	pass


## This indicates if the goal should be considered or not.
## Useful for eliminating redundant actions, or if it is simply not currently possible.
## ex: Eating when the agent is still not hungry.
func is_valid(_pawn: Pawn) -> bool:
	return true


## Returns goals priority. Higher priority is favored over lower priorities.
## This priority can be dynamic.
func priority(_pawn: Pawn) -> int:
	return 1


## Plan's desired state. 
## Usually referred to as desired world state, but doesn't need to exactly match the raw world state.
func get_desired_state(_pawn: Pawn) -> Dictionary:
	return {}

