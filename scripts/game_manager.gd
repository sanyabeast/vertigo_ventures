class_name GameManager
extends Node

# Reference to the VFollowCamera used in the game.
var camera: VFollowCamera = null

# This function is called when the node enters the scene tree for the first time.
func _ready():
	# Initialization code can be placed here.
	pass

# This function is called every frame.
# 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Game logic that needs to run every frame can be placed here.
	pass

# This function handles when a character is created and joins the game.
# It assigns the character to the appropriate manager and sets up related properties.
func join(character: VCharacter):
	match character.character_type:
		VCharacter.ECharacterType.Player:
			# If the character is a player, set it as the primary player.
			players_manager.set_player(character)
			# Set the camera's target to the new player.
			camera.target = character
		_:
			# If the character is not a player, add it to the NPCs manager.
			npc_manager.join(character)

# This function handles when a character is destroyed and leaves the game.
# It removes the character from the appropriate manager and cleans up related properties.
func leave(character: VCharacter):
	match character.character_type:
		VCharacter.ECharacterType.Player:
			# If the character is a player, unset it as the primary player.
			players_manager.unset_player(character)
			# Remove the camera's target since the player is leaving.
			camera.target = null
		_:
			# If the character is not a player, remove it from the NPCs manager.
			npc_manager.leave(character)
