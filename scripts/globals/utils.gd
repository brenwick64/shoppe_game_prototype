extends Node

func random_sign() -> int:
	return [-1, 1].pick_random()

func roll_percentage(chance: float) -> bool:
	var rng: float = randf_range(0, 1)
	return chance >= rng
