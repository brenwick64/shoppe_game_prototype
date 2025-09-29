extends Node

func random_sign() -> int:
	return [-1, 1].pick_random()

func roll_percentage(chance: float) -> bool:
	var rng: float = randf_range(0, 1)
	return chance >= rng

func arrays_overlap(a: Array, b:Array) -> bool:
	for element in a:
		if element in b:
			return true
	return false

func closest_distance_gp(node: Node2D, targets: Array[Node2D]) -> float:
	var min_dist: float = INF
	for t in targets:
		var dist: float = node.global_position.distance_to(t.global_position)
		if dist < min_dist:
			min_dist = dist
	return min_dist

## matrix operations
func create_transformation_matrix(dimensions: Vector2i)  -> Array[Vector2i]:
	var transformation_matrix: Array[Vector2i] = [Vector2i(0, 0)]
	for i: int in range(dimensions.x - 1):
		transformation_matrix.append(Vector2i(i + 1,0))
	for j: int in range(dimensions.y - 1):
		transformation_matrix.append(Vector2i(0, j + 1))
	return transformation_matrix
