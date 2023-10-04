class_name VConfig
extends Node

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

enum EAbilityType {
	Property,
	Item
}
