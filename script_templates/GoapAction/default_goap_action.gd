# meta-default: true
extends GoapAction



## Returns the name of the action.
func get_action_name() -> String:
	return "_CLASS_"


## Called when a Pawn gains this action.
## Can be used to initialize settings for this action.
func gain(_pawn: Pawn) -> void:
	pass


## This indicates if the action should be considered or not.
## Useful for eliminating redundant actions, or if it is simply not currently possible.
## ex: Eating food when the agent is still full.
func is_valid(_pawn: Pawn) -> bool:
	return true


## Action Cost. The higher the cost, the more expensive the overall plan and makes it harder to occur.
## Can be used to implement situational costs, when the world state is considered when calculating the cost.
##
## ex: Hunting an animal for food when armed with a weapon (lower cost) vs when unarmed (higher cost). 
func get_cost(_blackboard: Dictionary) -> int:
	return 1000


## Action requirements. What needs to be accomplished in order for this action to be done.
## Used to calculate plans.
## ex: If this were an action to eat, then a reasonable precondition is to have something to eat:
## {
##   "has_food": true
## }
func get_preconditions() -> Dictionary:
	return {}


## What conditions this action will satisfy when completed.
## ex: If this were an action to eat, then it should make you full
## Example:
## {
##   "is_hungry": false
## }
func get_effects() -> Dictionary:
	return {}


## Called on initially starting this action.
func start(_pawn: Pawn) -> void:
	pass


## Called to check if this action can still be performed.
## Used for verifying while performing the action plan.
func can_still_perform(_pawn: Pawn) -> bool:
	return true


## Action implementation called on every loop.
## "pawn" is the NPC using the AI
## "delta" is the time in seconds since last loop.
##
## Returns true when the task is complete, otherwise false while performing.
func perform(_pawn: Pawn, _delta: float) -> bool:
	return false


## Called to reset this action as well as pawn's states.
## Useful if this action has default values or variables it uses while performing.
## ex: Amount of time remaining before this action is completed
func reset(_pawn: Pawn) -> void:
	pass
