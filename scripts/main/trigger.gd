class_name VTrigger
extends Area3D

@export var enabled: bool = true
@export var max_activations: int = 0
@export var allowed_character_types: Array[config.ECharacterType] = [config.ECharacterType.Player]
@export var enter_action_type: config.ETriggerActionType = config.ETriggerActionType.None
@export var exit_action_type: config.ETriggerActionType = config.ETriggerActionType.None

@export_category("Buffs")
@export var buffs_on_enter: Dictionary = {}
@export var buffs_on_exit: Dictionary = {}

var activated_times: int = 0
var entered_characters: Array[VCharacter] = []

signal entered
signal exited

func _ready():
	for key in buffs_on_enter:
		assert(key in config.buffs_lib, "unknown buff '%s', create resource for it at 'res://resources/buffs/'" % [key])
	for key in buffs_on_exit:
		assert(key in config.buffs_lib, "unknown buff '%s', create resource for it at 'res://resources/buffs/'" % [key])

func _on_body_entered(body):
	if not enabled: return
	if max_activations > 0 and activated_times >= max_activations: return
	
	if body is VCharacter:
		body = body as VCharacter
		if body.character_type in allowed_character_types:
			print("body entered: %s" % [body.name])
			entered_characters.push_back(body)
			activated_times += 1
			entered.emit()
			apply_action(enter_action_type, body, buffs_on_enter)

func _on_body_exited(body):
	if body is VCharacter and body in entered_characters:
		entered_characters.erase(body)
		apply_action(exit_action_type, body, buffs_on_exit)
		print("body exited: %s" % [body.name])

func apply_action(action_type: config.ETriggerActionType, body: VCharacter, buffs: Dictionary):
	match action_type:
		config.ETriggerActionType.Buffs:
			tools.apply_buffs(body, buffs)
		_:
			pass
			

