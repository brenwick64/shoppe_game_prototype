class_name BirdAreaSelector
extends Node

## -- methods --
func get_bird_area(bird: RBirdData) -> BirdArea:
	var global_areas: Array[BirdArea] = _get_all_bird_areas()
	var tagged_areas: Array[BirdArea] = _filter_areas_by_tag(bird.bird_area_tags, global_areas)
	var closest_area: BirdArea = _get_area_closest_to_player(tagged_areas)
	return closest_area if closest_area else null

## -- helper functions --
func _get_all_bird_areas() -> Array[BirdArea]:
	var areas: Array[BirdArea] = []
	var group_nodes: Array[Node] = get_tree().get_nodes_in_group("bird_area")
	for node: Node in group_nodes:
		if node is BirdArea:
			areas.append(node)
	return areas

func _filter_areas_by_tag(tags: Array[String], areas: Array[BirdArea]) -> Array[BirdArea]:
	var filtered_arr: Array[BirdArea] = areas.filter(func(a):
		return Utils.arrays_overlap(tags, a.tags)
	)
	return filtered_arr

func _get_area_closest_to_player(areas: Array[BirdArea]) -> BirdArea:
	var player: Node2D = get_tree().get_first_node_in_group("player")
	if player:
		var shortest_distance: float = INF
		var closest_area: BirdArea = null
		for area: BirdArea in areas:
			var current_distance: float = player.global_position.distance_to(area.global_position)
			if current_distance < shortest_distance:
				shortest_distance = current_distance
				closest_area = area
		return closest_area
	else:
		return areas[0] if areas else null
