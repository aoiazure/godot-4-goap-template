## Integrates pawn (NPC) with goap.
##
## As good practice, I suggest leaving it isolated so it doesn't get tied
## to unrelated implementation details (movement, collisions, etc).
class_name GoapAgent extends Node

var goap: Goap

var _goals: Array[GoapGoal] = []
var _current_goal: GoapGoal
var _current_plan: Array[GoapAction] = []
var _current_plan_step: int = 0

var _pawn: Pawn
var _blackboard: Dictionary = { }

var _update_timer:= 0.5


## Set initial references and goals.
func init(pawn: Pawn, goals: Array[GoapGoal]) -> void:
	_pawn = pawn
	_goals = goals


## Add additional available goals.
func add_goals(goals: Array[GoapGoal]) -> void:
	var temp_goals:= _goals.duplicate(true)
	for goal: GoapGoal in goals:
		for _goal: GoapGoal in temp_goals:
			if _goal.get_goal_name() == goal.get_goal_name():
				continue
		_goals.append(goal)
	temp_goals.clear()

## Immediately halt current plan and redecide what to do.
func interrupt() -> void:
	_current_goal = null
	_current_plan_step = 0
	_current_plan.clear()


#region Memory functions
## Set the value of the key.
func memorize(key, value) -> void:
	_blackboard[key] = value

## Returns the value of the key. Can be any value.
func recall(key, default = null):
	if not _blackboard.has(key):
		return default
	
	return _blackboard[key]
#endregion



## On every loop this script checks if the current goal is still
## the highest priority. if it's not, it requests the action planner a new plan
## for the new high priority goal.
func _process(delta: float) -> void:
	if _goals.is_empty() or (not _pawn):
		return
	
	_update_timer += delta
	if _update_timer >= 0.25:
		_update_timer = 0.0
		_update_blackboard()
	
	var goal: GoapGoal = _get_best_goal()
	if _current_goal == null or goal != _current_goal:
		_current_goal = goal
		_current_goal.choose(_pawn)
		_current_plan = goap.get_action_planner().get_plan(_pawn, _current_goal, _blackboard)
		_current_plan_step = 0
		if not _current_plan.is_empty():
			_current_plan.front().start(_pawn)
	else:
		_follow_plan(_current_plan, delta)


## You can set in the blackboard any relevant information you want to use
## when calculating action costs and status.
func _update_blackboard() -> void:
	_blackboard.position = _pawn.global_position
	
	for key in WorldState.get_state_entries():
		_blackboard[key] = WorldState.get_state(key)



#
# Returns the highest priority goal available.
#
func _get_best_goal() -> GoapGoal:
	var highest_priority: GoapGoal = null
	
	for goal: GoapGoal in _goals:
		if goal.is_valid(_pawn) and (highest_priority == null \
						or goal.priority(_pawn) > highest_priority.priority(_pawn)):
			highest_priority = goal
	
	return highest_priority


#
# Executes plan. This function is called on every game loop.
# "plan" is the current list of actions, and delta is the time since last loop.
#
# Every action exposes a function called perform, which will return true when
# the job is complete, so the agent can jump to the next action in the list.
#
func _follow_plan(plan: Array[GoapAction], delta: float):
	if plan.is_empty():
		return
	
	var current_action: GoapAction = (plan[_current_plan_step] as GoapAction)
	# Always maintain that this action is valid. If it isn't, we need to reevaluate.
	if (not current_action.is_valid(_pawn)) or (not current_action.can_still_perform(_pawn)):
		current_action.reset(_pawn)
		_current_goal = null
		return
	
	var is_step_complete = current_action.perform(_pawn, delta)
	if is_step_complete:
		# Continue along plan
		if _current_plan_step < plan.size() - 1:
			_current_plan_step += 1
		# End of plan, reset
		elif _current_plan_step >= (plan.size() - 1):
			_current_goal = null
			return


