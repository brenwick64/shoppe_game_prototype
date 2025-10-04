class_name Task
extends Node

signal completed

var adventurer: Adventurer

func init(p_adventurer: Adventurer) -> void:
	adventurer = p_adventurer
