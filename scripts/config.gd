class_name VConfig
extends Node

@onready var stats_lib: Dictionary = tools.get_resources_in_directory("res://resources/stats/")
@onready var items_lib: Dictionary = tools.get_resources_in_directory("res://resources/items/")

var FRIEND_DESIRED_DISTANCE_TO_PLAYER: float = 3
var NPC_PATH_DIRECTION_CHANGE_SPEED: float = 16
var NPC_PATH_TARGET_POSITION_INACCURACY: float = 1

enum ETargetFollowStrategy {
	Path,
	Direction
}

enum ECharacterType {
	Player,
	Friend,
	Neutral,
	Enemy
}
