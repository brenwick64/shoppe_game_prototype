class_name SaveLoadComponent
extends Node

@export var save_filename: String
@export var save_data_type: RSaveData

func save_data(arr: Array) -> void:
	var save_data_arr: Array[RSaveData] = []
	for element in arr:
		var save_data: RSaveData = save_data_type.pack_save_data(element)
		save_data_arr.append(save_data)
	if save_data_arr.size() > 0:
		GlobalSaveLoadManager.save_resource_data(save_filename, save_data_arr)

func check_save_data() -> bool:
	return GlobalSaveLoadManager.does_save_file_exist(save_filename)

func load_data() -> Array:
	var save_data_arr: Array[RSaveData] = GlobalSaveLoadManager.load_resource_data(save_filename)
	var unpacked_arr: Array = []
	for save_data: RSaveData in save_data_arr:
		var data = save_data_type.unpack_save_data(save_data)
		unpacked_arr.append(data)
	return unpacked_arr
