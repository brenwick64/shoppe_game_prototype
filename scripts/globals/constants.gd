extends Node

## -- enums --
enum CHAT_MESSAGE_TYPE { QUESTION, ANSWER, CLOSURE, STATEMENT }
enum ITEM_RARITY { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

## -- audio--
const MIN_DB: float = -80


## -- colors --
const CONSOLE_TEXT_DEFAULT: Color = Color.BLACK
const CONSOLE_TEXT_INFO: Color = Color.BLACK
const CONSOLE_TEXT_DEBUG: Color = Color.DIM_GRAY
const CONSOLE_TEXT_CHAT_SENDER: Color = Color.ROYAL_BLUE
const CONSOLE_TEXT_CHAT: Color = Color.CORNFLOWER_BLUE


## -- chat --
const GLOBAL_CHAT_REPLY_CHANCE: float = 0.5
const GLOBAL_CHAT_STATEMENT_CHANCE: float = 0.1
const GLOBAL_CHAT_CONVERSATION_CHANCE: float = 0.1
const CHAT_MESSAGE_Y_OFFSET: float = -50.0
const CHAT_MESSAGE_ALIVE_TIME_SEC: float = 3.0


## -- other --
const MAX_INT_VALUE: int = 9223372036854775807
