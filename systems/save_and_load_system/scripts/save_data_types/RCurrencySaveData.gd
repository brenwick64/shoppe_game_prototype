class_name RCurrencySaveData
extends RSaveData

@export var type: String
@export var amount: int

static func pack_save_data(currency_dict: Dictionary) -> RCurrencySaveData:
	var save_data: RCurrencySaveData = RCurrencySaveData.new()
	save_data.type = currency_dict["type"]
	save_data.amount = currency_dict["amount"]
	return save_data

static func unpack_save_data(save_data: RCurrencySaveData) -> Dictionary:
	var currency_dict: Dictionary = {}
	currency_dict["type"] = save_data.type
	currency_dict["amount"] = save_data.amount
	return currency_dict
