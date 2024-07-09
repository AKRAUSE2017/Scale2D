WINDOW_WIDTH = 1280 -- 960
WINDOW_HEIGHT = 720 -- 540

VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

PLAYER_SPEED = 200
PLAYER_JUMP_HEIGHT = PLAYER_SPEED * 1.5
PLAYER_SPRITE_SCALE = 2
PLAYER_WIDTH = 32*PLAYER_SPRITE_SCALE
PLAYER_HEIGHT = 32*PLAYER_SPRITE_SCALE
PLAYER_PLATFORM_HEIGHT = 35

PLAYER_COLLISION_OFFSETS = {}

PLAYER_COLLISION_OFFSETS[1] = {}
PLAYER_COLLISION_OFFSETS[1]["X"] = 8
PLAYER_COLLISION_OFFSETS[1]["Y"] = 16
PLAYER_COLLISION_OFFSETS[1]["W"] = -18
PLAYER_COLLISION_OFFSETS[1]["H"]= -32

PLAYER_COLLISION_OFFSETS[2] = {}
PLAYER_COLLISION_OFFSETS[2]["X"] = 24
PLAYER_COLLISION_OFFSETS[2]["Y"] = 48
PLAYER_COLLISION_OFFSETS[2]["W"] = -46
PLAYER_COLLISION_OFFSETS[2]["H"]= -48

PLATFORM_SPEED = 100
SCALE_FACTOR = 300

GRAVITY = 4

DEBUG_MODE = false

MIN_PLATFORM_WIDTH = 20
MIN_PLATFORM_HEIGHT = 20

MAX_PLATFORM_WIDTH = 800
MAX_PLATFORM_HEIGHT = 300

COLLECTED_ITEMS_X = VIRTUAL_WIDTH - 80
COLLECTED_ITEMS_Y = 10
COLLECTED_ITEMS_W = 70
COLLECTED_ITEMS_H = 40

GAME_STATE = "play"