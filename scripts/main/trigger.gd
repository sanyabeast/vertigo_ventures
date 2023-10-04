class_name VTrigger
extends Area3D

@export var enabled: bool = true
@export var max_activations: int = 0
@export var allowed_character_types: Array[config.ECharacterType] = [config.ECharacterType.Player]
@export var apply_debuffs_on_exit := false;
@export var buffs: Dictionary = {}

var activated_times: int = 0
var entered_characters: Array[VCharacter] = []

signal entered
signal exited

func _ready():
	if buffs != null:
		for stat_name in buffs:
			assert(stat_name in config.stats_lib, "Buff error: unknown stat '%s'" % [stat_name])

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
			apply_actions(body)

func _on_body_exited(body):
	if body is VCharacter and body in entered_characters:
		entered_characters.erase(body)
		apply_exit_actions(body)
		print("body exited: %s" % [body.name])

func apply_actions(body: VCharacter):
	if buffs != null:
		for stat_name in buffs:
			var delta = buffs[stat_name]
			body.stats.alter_stat(stat_name, delta)
			
func apply_exit_actions(body: VCharacter):
	if apply_debuffs_on_exit and buffs != null:
		for stat_name in buffs:
			var delta = buffs[stat_name]
			body.stats.alter_stat(stat_name, -delta)
