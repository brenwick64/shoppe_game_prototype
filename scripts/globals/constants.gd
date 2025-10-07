extends Node


## -- audio--
const MIN_DB: float = -80


## -- colors --
const CONSOLE_TEXT_DEFAULT: Color = Color.BLACK
const CONSOLE_TEXT_INFO: Color = Color.BLACK
const CONSOLE_TEXT_DEBUG: Color = Color.DIM_GRAY
const CONSOLE_TEXT_CHAT_SENDER: Color = Color.ROYAL_BLUE
const CONSOLE_TEXT_CHAT: Color = Color.CORNFLOWER_BLUE


## -- chat --
enum CHAT_MESSAGE_TYPE { QUESTION, ANSWER, CLOSURE, SPAM }
const CHAT_MESSAGE_Y_OFFSET: float = -50.0
const CHAT_MESSAGE_ALIVE_TIME_SEC: float = 3.0
