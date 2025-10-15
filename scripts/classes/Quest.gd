class_name Quest
extends Node

@export var quest_name: String
@export var quest_owner: Adventurer
@export var quest_status: Constants.QUEST_STATUS
@export var quest_steps: Array[Task]
