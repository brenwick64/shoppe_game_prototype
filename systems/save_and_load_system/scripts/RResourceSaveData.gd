class_name RResourceSaveData
extends RSaveData

@export var resource: Resource

static func pack_save_data(element) -> RResourceSaveData:
	var save_data: RResourceSaveData = RResourceSaveData.new()
	save_data.resource = element
	return save_data

static func unpack_save_data(save_data: RResourceSaveData) -> Resource:
	var resource: Resource = save_data.resource
	return resource
