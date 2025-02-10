## This class is used to create and manage GoapActionPlanners for agents.
## 
## If desired, you could have multiple Goaps and ActionPlanners per agent, switching as needed.
class_name Goap extends RefCounted

var _action_planner:= GoapActionPlanner.new()



func set_actions(pawn: Pawn, actions: Array[GoapAction]) -> void:
	_action_planner.set_actions(pawn, actions)

func add_actions(pawn: Pawn, actions: Array[GoapAction]) -> void:
	_action_planner.add_actions(pawn, actions)


func get_action_planner() -> GoapActionPlanner:
	return _action_planner








