class_name NpcManager
extends Node

# List of NPCs currently managed by this manager.
var _npcs: Array = []

# This function is called when the node enters the scene tree for the first time.
func _ready():
	# Initialization code can be placed here.
	pass

# This function is called every frame. 
# It processes the behavior for each NPC managed by this manager.
func _process(delta):
	for npc in _npcs:
		process_npc_behaviour(delta, npc)

# This function adds an NPC to the manager's list and logs the total count.
func join(npc: VCharacter):
	_npcs.push_back(npc)
	print("npc join, total npc alive: %s" % str(_npcs.size()))

# This function removes an NPC from the manager's list and logs the total count.
func leave(npc: VCharacter):
	_npcs.erase(npc)
	print("npc left, total npc alive: %s" % str(_npcs.size()))

# Processes behavior for an NPC based on its character type.
func process_npc_behaviour(delta: float, npc: VCharacter):
	match npc.character_type:
		VCharacter.ECharacterType.Neutral:
			process_neutral_npc_behaviour(delta, npc)
		VCharacter.ECharacterType.Friend:
			process_friend_npc_behaviour(delta, npc)
		VCharacter.ECharacterType.Enemy:
			process_enemy_npc_behaviour(delta, npc)

# Behavior processing for neutral NPCs.
# Currently no specific behavior is implemented.
func process_neutral_npc_behaviour(delta: float, npc: VCharacter):
	pass

# Behavior processing for friend NPCs.
# Friends move toward the player to a specific desired distance.
func process_friend_npc_behaviour(delta: float, npc: VCharacter):
	move_npc_toward_player(delta, npc, config.FRIEND_DESIRED_DISTANCE_TO_PLAYER)

# Behavior processing for enemy NPCs.
# Enemies move toward the player to a specific desired distance (same as friends in this code).
func process_enemy_npc_behaviour(delta: float, npc: VCharacter):
	move_npc_toward_player(delta, npc, config.FRIEND_DESIRED_DISTANCE_TO_PLAYER)

# Determines and executes the movement for an NPC towards the player.
func move_npc_toward_player(delta: float, npc: VCharacter, desired_distance: float):
	if players_manager.player:
		var npc_position: Vector3 = npc.global_transform.origin
		var player_position: Vector3 = players_manager.player.global_transform.origin
		var distance: float = npc_position.distance_to(player_position)
		var direction: Vector3 = (player_position - npc_position).normalized()

		if distance > desired_distance:
			if npc.is_on_wall():
				npc.requesting_jump = true
			npc.move_direction = direction
		else:
			npc.move_direction = Vector3.ZERO
