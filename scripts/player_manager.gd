class_name PlayerManager
extends Node

# Reference to the main player character.
var player: VCharacter = null

# This function is called when the node enters the scene tree for the first time.
func _ready():
	# Initialization code can be placed here.
	pass

# This function is called every frame. 
# Game logic that needs to run every frame can be placed here.
func _process(delta):
	pass

# This function is called every physics frame.
# It processes player input if a player is currently set.
func _physics_process(delta):
	if player:
		process_player_input(delta, player)

# Sets the main player character and logs the action.
func set_player(_player: VCharacter) -> void:
	player = _player
	print("player set: %s" % player.name)

# Unsets the main player character (if it matches the provided player) and logs the action.
func unset_player(_player: VCharacter) -> void:
	if _player == player:
		print("player unset: %s" % player.name)
		player = null

# Processes input for the player character, handling movement and actions.
func process_player_input(delta: float, player: VCharacter):
	# Handle jump requests.
	if Input.is_action_just_pressed("jump"):
		player.requesting_jump = true

	player.requesting_action = Input.is_action_pressed("act_left") or Input.is_action_pressed("act_right") or Input.is_action_pressed("act_forward") or Input.is_action_pressed("act_backward")

	# Get the input direction and convert it to the player's local space.
	var move_dir = Input.get_vector("left", "right", "forward", "backward")
	var action_dir = Input.get_vector("act_left", "act_right", "act_forward", "act_backward")
	player.move_direction = (player.transform.basis * Vector3(move_dir.x, 0, move_dir.y)).normalized()
	player.action_direction = (player.transform.basis * Vector3(action_dir.x, 0, action_dir.y)).normalized()
