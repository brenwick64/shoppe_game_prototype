extends Node

func random_sign() -> int:
	return [-1, 1].pick_random()

func roll_percentage(chance: float) -> bool:
	var rng: float = randf_range(0, 1)
	return chance >= rng

func get_closest_target_node(source_node: Node2D, target_nodes: Array[Node2D]) -> Node2D:
	var closest_target: Node2D = null
	var min_dist: float = INF
	for t: Node2D in target_nodes:
		var dist: float = source_node.global_position.distance_to(t.global_position)
		if dist < min_dist:
			min_dist = dist
			closest_target = t
	return closest_target

## string operations
func int_to_comma_string(value: int) -> String:
	var str_val: String = str(abs(value))
	var result: String = ""
	
	while str_val.length() > 3:
		result = "," + str_val.substr(str_val.length() - 3, 3) + result
		str_val = str_val.substr(0, str_val.length() - 3)
	
	result = str_val + result
	if value < 0:
		result = "-" + result
	return result


## array operations
func arrays_overlap(a: Array, b:Array) -> bool:
	for element in a:
		if element in b:
			return true
	return false
	
func is_subset(subset: Array, superset: Array) -> bool:
	for element in subset:
		if not superset.has(element):
			return false
	return true

## matrix operations
func create_transformation_matrix(dimensions: Vector2i)  -> Array[Vector2i]:
	var transformation_matrix: Array[Vector2i] = [Vector2i(0, 0)]
	for i: int in range(dimensions.x - 1):
		transformation_matrix.append(Vector2i(i + 1,0))
	for j: int in range(dimensions.y - 1):
		transformation_matrix.append(Vector2i(0, j + 1))
	return transformation_matrix
