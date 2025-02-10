#
# Goal contract
#
class_name GoapGoal extends RefCounted


func get_goal_name() -> String:
	return "GoapGoal"


#
# Called when this Goal is chosen to be acted on.
#
func choose(_pawn: Pawn) -> void:
	pass


# This indicates if the goal should be considered or not.
# Sometimes instead of changing the priority, it is easier to
# not even consider the goal. i.e. Ignore combat related goals
# when there are not enemies nearby.
#
func is_valid(_pawn: Pawn) -> bool:
	return true

#
# Returns goals priority. Higher priority is favored.
# This priority can be dynamic. Check `./goals/keep_fed.gd` for an example of dynamic priority.
#
func priority(_pawn: Pawn) -> int:
	return 1

#
# Plan's desired state. This is usually referred as desired world
# state, but it doesn't need to match the raw world state.
#
# For example, in your world state you may store "hunger" as a number, but inside your
# goap you can deal with it as "is_hungry".
func get_desired_state(_pawn: Pawn) -> Dictionary:
	return {}
