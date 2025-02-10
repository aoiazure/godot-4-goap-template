## Autoload that handles tracking the details about the game World.
## 
extends Node

static var _state: Dictionary = { }

## Set the value of the key `state_key`.
func set_state(state_key, value) -> void:
	_state[state_key] = value

## Return the value of the key `state_key`.
func get_state(state_key, default = null):
	return _state.get(state_key, default)

## Clear and reset the value of the state.
func clear_state() -> void:
	_state = {}

## Returns an array containing all keys in the state.
func get_state_entries() -> Array:
	return _state.keys()


#region Helpers
## Return an array of all the nodes in a node Group.
## Primarily serves as easy shorthand.
func get_all_elements_of_group(group_name: StringName) -> Array[Node]:
	return self.get_tree().get_nodes_in_group(group_name)

## Returns a Node2D that is the closest in a 2D plane.
func get_closest_element_of_group_2d(group_name: StringName, reference_position: Vector2) -> Node2D:
	var elements: Array[Node] = get_all_elements_of_group(group_name)
	var closest_distance: float = 10000000
	var closest_element: Node2D
	
	var distance: float
	for element in elements:
		if element is not Node2D:
			push_error("%s does not extend Node2D.")
			continue
		
		distance = reference_position.distance_to(element.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_element = element
	
	return closest_element

## Returns a Node3D that is the closest in 3D space.
func get_closest_element_of_group_3d(group_name: StringName, reference_position: Vector3) -> Node3D:
	var elements: Array[Node] = get_all_elements_of_group(group_name)
	var closest_distance: float = 10000000
	var closest_element: Node3D
	
	var distance: float
	for element in elements:
		if element is not Node3D:
			push_error("%s does not extend Node3D.")
			continue
		
		distance = reference_position.distance_to(element.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_element = element
	
	return closest_element
#endregion
