class_name VCharacter
extends CharacterBody3D

# Variables for the body node and character parameters.
@onready var body: Node3D = $Body
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var ray: RayCast3D = $RayCast3D
@onready var coll: CollisionShape3D = $CollisionShape3D

@export var walk_fade_speed: float = 15.0
@export var jump_velocity: float = 5
@export var gravity: float = 9.8
@export var direction_step = 45

# Internal state variables for movement and body orientation.
var move_direction: Vector3
var body_direction: Vector3
var body_angle: float = 0
@export var body_rotation_speed_min = 2.0
@export var body_rotation_speed_max = 32.0
var requesting_jump: bool = false

@export var character_type: config.ECharacterType = config.ECharacterType.Neutral

@export_category("Stats & Items")
@export var initial_stats: Dictionary
@export var initial_items: Dictionary
@onready var stats: VStatsManager = VStatsManager.new(initial_stats)
@onready var items: VItemsManager = VItemsManager.new(initial_items)

@export_category("NPC Behaviour")
@export var npc_target_follow_strategy: config.ETargetFollowStrategy = config.ETargetFollowStrategy.Path

signal dead()

func _ready():
	ray.add_exception(self)
	stats.exhausted.connect(_on_stat_exhausted)
	game_manager.join(self)

func _exit_tree():
	game_manager.leave(self)

func _on_stat_exhausted(name: String, value: float, old_value: float):
	print("state %s exhauseted" % name)
	match name:
		"health":
			die()
	pass

func die():
	dead.emit()
	queue_free()

func _physics_process(delta):
	
	process_behaviour(delta)
	
	# Apply gravity if the character isn't on the ground.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Process jump action.
	if requesting_jump and is_on_floor():
		velocity.y = jump_velocity

	# Align the move direction to specified rotation steps.
	move_direction = tools.align_direction_vector_to_rotation_step(move_direction, direction_step)

	# Process the body's orientation and direction.
	process_body(delta)
	
	# Update the character's horizontal movement based on the move direction.
	if move_direction.length() > 0:
		velocity.x = move_direction.x * stats.get_stat("walking")
		velocity.z = move_direction.z * stats.get_stat("walking")
	else:
		# Ensure body angle is between 0 and 2*PI.
		body_angle = fmod(body_angle, PI * 2)
		
		# Gradually reduce the character's horizontal velocity to a stop.
		velocity.x = move_toward(velocity.x, 0, walk_fade_speed * delta)
		velocity.z = move_toward(velocity.z, 0, walk_fade_speed * delta)


	nav_agent.velocity = velocity

	# Apply the calculated velocity.
	move_and_slide()
	
	# Reset jump request state.
	requesting_jump = false

func process_body(delta: float) -> void:
	# Get the angle corresponding to the current move direction.
	var target_body_angle = tools.direction_vector_to_direction_angle(move_direction)

	# Adjust the target angle to make the rotation as short as possible.
	if abs(body_angle - target_body_angle) > abs(body_angle - (target_body_angle + PI * 2)):
		target_body_angle += PI * 2
	elif abs(body_angle - target_body_angle) > abs(body_angle - (target_body_angle - PI * 2)):
		target_body_angle -= PI * 2
		
	# Print the target and current body angles if they're different and the character is moving.
#	if target_body_angle != body_angle and move_direction.length() > 0:
#		print("new: %s, current: %s" % [target_body_angle, body_angle])

	# Determine the speed of rotation based on the difference between the current and target angles.
	var rotation_speed = lerp(body_rotation_speed_min, body_rotation_speed_max, abs(body_angle - target_body_angle) / (PI))

	# Gradually rotate the body towards the target angle.
	body_angle = move_toward(body_angle, target_body_angle, rotation_speed * delta * move_direction.length())

	# Convert the angle back to a direction vector.
	body_direction = tools.direction_angle_to_direction_vector(body_angle)
	
	# Make the body node face the calculated direction.
	body.look_at(body.global_transform.origin + body_direction, Vector3.UP)
	
	

func process_behaviour(delta: float) -> void:
	# Placeholder for character-specific behaviors.
	pass
