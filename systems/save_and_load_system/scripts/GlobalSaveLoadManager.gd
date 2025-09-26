extends Node

# required import for engine to reference resource on autoload
const savedata_arr_init = preload("res://systems/save_and_load_system/scripts/RSaveDataArr.gd")

func save_resource_data(filename: String, array: Array[RSaveData]) -> void:
	var path: String = "user://" + filename + ".tres"
	var save_data_arr: RSaveDataArr = RSaveDataArr.new()
	save_data_arr.array = array
	var response_code: int = ResourceSaver.save(save_data_arr, path)
	if response_code != 0:
		push_error("SaveManager error: could not save data for: " + path)

func load_resource_data(filename: String) -> Array[RSaveData]:
	var path: String = "user://" + filename + ".tres"
	if not FileAccess.file_exists(path): return [] # file not found
	var array: Array[RSaveData]
	var save_data_arr: RSaveDataArr = ResourceLoader.load(path) as RSaveDataArr
	for save_data: RSaveData in save_data_arr.array:
		array.append(save_data)
	return array

func does_save_file_exist(filename: String) -> bool:
	var path: String = "user://" + filename + ".tres"
	return FileAccess.file_exists(path)
