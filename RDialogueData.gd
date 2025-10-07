class_name RDialogueData
extends Resource

@export var conversation_starters: Array[RMessageData]
@export var replies: Array[RMessageData]


func get_conversation_starter(message_ctx: RMessageContext) -> RMessageData:
	# TODO: more advanced matching
	return conversation_starters.pick_random()

func get_reply(message_context: RMessageContext) -> RMessageData:
	var correct_types: Array[RMessageData] = replies.filter(
		func(reply: RMessageData): return reply.context.type == _get_correct_reply_type(message_context.type)
	)
	# TODO: more advanced matching
	return correct_types.pick_random() if correct_types else null

func _get_correct_reply_type(type: Constants.CHAT_MESSAGE_TYPE) -> Constants.CHAT_MESSAGE_TYPE:
	match type:
		Constants.CHAT_MESSAGE_TYPE.QUESTION: return Constants.CHAT_MESSAGE_TYPE.ANSWER
		Constants.CHAT_MESSAGE_TYPE.ANSWER: return Constants.CHAT_MESSAGE_TYPE.CLOSURE
		#TODO: more cases
		_: return Constants.CHAT_MESSAGE_TYPE.SPAM
