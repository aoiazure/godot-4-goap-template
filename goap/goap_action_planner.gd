## Action planner for GOAP. 	
class_name GoapActionPlanner extends RefCounted



var _actions: Array[GoapAction]



## Set actions available for planning.
## this can be changed in runtime for more dynamic options.
func set_actions(pawn: Pawn, actions: Array[GoapAction]) -> void:
	for action: GoapAction in actions:
		_actions.append(action)
		action.gain(pawn)

## Add additional actions.
func add_actions(pawn: Pawn, actions: Array[GoapAction]) -> void:
	var cur_actions:= _actions.duplicate()
	for action: GoapAction in actions:
		for _action in cur_actions:
			if action.get_action_name() == _action.get_action_name():
				continue
		
		_actions.append(action)
		action.gain(pawn)


## Receives a Goal and an optional blackboard.
## Returns a list of actions to be executed.
func get_plan(pawn: Pawn, goal: GoapGoal, blackboard: Dictionary = {}) -> Array[GoapAction]:
	print("Goal: %s" % goal.get_goal_name())
	#WorldState.console_message("Goal: %s" % goal.get_goal_name())
	var desired_state: Dictionary = goal.get_desired_state(pawn).duplicate()
	
	if desired_state.is_empty():
		return []
	
	return _find_best_plan(pawn, goal, desired_state, blackboard)



func _find_best_plan(pawn: Pawn, goal: GoapGoal, 
		desired_state: Dictionary, blackboard: Dictionary) -> Array[GoapAction]:
  # goal is set as root action. It does feel weird
  # but the code is simpler this way.
	var root: Dictionary = {
		"action": goal,
		"state": desired_state,
		"children": []
	}
	
	# Build plans will populate root with children.
	# In case it doesn't find a valid path, it will return false.
	if _build_plans(pawn, root, blackboard.duplicate()):
		var plans: Array[Dictionary] = _transform_tree_into_array(root, blackboard)
		return _get_cheapest_plan(plans)
	
	return []


#
# Compares plan's cost and returns actions included in the cheapest one.
#
func _get_cheapest_plan(plans: Array[Dictionary]) -> Array[GoapAction]:
	var best_plan: Dictionary
	for p: Dictionary in plans:
		#_print_plan(p)
		if best_plan.is_empty() or p.cost < best_plan.cost:
			best_plan = p
	_print_plan(best_plan)
	return best_plan.actions


#
# Builds graph with actions. Only includes valid plans (plans
# that achieve the goal).
#
# Returns true if the path has a solution.
#
# This function uses recursion to build the graph. This is
# necessary because any new action included in the graph may
# add pre-conditions to the desired state that can be satisfied
# by previously considered actions, meaning, on every step we
# need to iterate from the beginning to find all solutions.
#
# Be aware that for simplicity, the current implementation is not protected from
# circular dependencies. This is easy to implement though.
func _build_plans(pawn: Pawn, step: Dictionary, blackboard: Dictionary) -> bool:
	var has_followup: bool = false
	# each node in the graph has its own desired state.
	var state: Dictionary = step.state.duplicate()
	
	# checks if the blackboard contains data that can
	# satisfy the current state.
	for s in step.state:
		if state[s] == blackboard.get(s):
			state.erase(s)
	
	# if the state is empty, it means this branch already
	# found the solution, so it doesn't need to look for
	# more actions
	if state.is_empty():
		return true
	
	for action: GoapAction in _actions:
		if not action.is_valid(pawn):
			continue
		
		var should_use_action:= false
		var effects: Dictionary = action.get_effects()
		var desired_state = state.duplicate()
		
		# check if action should be used, i.e. it
		# satisfies at least one condition from the
		# desired state
		for s in desired_state:
			if desired_state[s] == effects.get(s):
				desired_state.erase(s)
				should_use_action = true
		
		if should_use_action:
			# adds actions pre-conditions to the desired state
			var preconditions = action.get_preconditions()
			for p in preconditions:
				desired_state[p] = preconditions[p]
			
			var s: Dictionary = {
				"action": action,
				"state": desired_state,
				"children": []
			}
			
			# if desired state is empty, it means this action
			# can be included in the graph.
			# if it's not empty, _build_plans is called again (recursively) so
			# it can try to find actions to satisfy this current state. In case
			# it can't find anything, this action won't be included in the graph.
			if desired_state.is_empty() or _build_plans(pawn, s, blackboard.duplicate()):
				step.children.push_back(s)
				has_followup = true
	
	return has_followup


#
# Transforms graph with actions into list of actions and calculates the cost by summing actions' cost
#
# Returns list of plans.
#
func _transform_tree_into_array(p: Dictionary, blackboard: Dictionary) -> Array[Dictionary]:
	var plans: Array[Dictionary] = []
	
	if p.children.size() == 0:
		var actions: Array[GoapAction] = [p.action]
		plans.push_back({ "actions": actions, "cost": p.action.get_cost(blackboard) })
		return plans
	
	for c in p.children:
		for child_plan: Dictionary in _transform_tree_into_array(c, blackboard):
			if p.action.has_method("get_cost"):
				child_plan.actions.push_back(p.action)
				child_plan.cost += p.action.get_cost(blackboard)
			
			plans.push_back(child_plan)
	
	return plans


#
# Prints plan. Used for Debugging only.
#
func _print_plan(plan: Dictionary) -> void:
	var actions: Array[String] = []
	for a: GoapAction in plan.actions:
		actions.push_back(a.get_action_name())
	
	print({"cost": plan.cost, "actions": actions})
	#WorldState.console_message({"cost": plan.cost, "actions": actions})
