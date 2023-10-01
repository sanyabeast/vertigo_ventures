class_name VCharacter
extends CharacterBody3D

# Variables for the body node and character parameters.
@onready var body: Node3D = $Body
@export var walk_speed: float = 5.0
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

func _physics_process(delta):
	# Reset jump request state.
	requesting_jump = false
	
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
		velocity.x = move_direction.x * walk_speed
		velocity.z = move_direction.z * walk_speed
	else:
		# Ensure body angle is between 0 and 2*PI.
		body_angle = fmod(body_angle, PI * 2)
		
		# Gradually reduce the character's horizontal velocity to a stop.
		velocity.x = move_toward(velocity.x, 0, walk_fade_speed * delta)
		velocity.z = move_toward(velocity.z, 0, walk_fade_speed * delta)

	# Apply the calculated velocity.
	move_and_slide()

func process_body(delta: float) -> void:
	# Get the angle corresponding to the current move direction.
	var target_body_angle = tools.direction_vector_to_direction_angle(move_direction)

	# Adjust the target angle to make the rotation as short as possible.
	if abs(body_angle - target_body_angle) > abs(body_angle - (target_body_angle + PI * 2)):
		target_body_angle += PI * 2
	elif abs(body_angle - target_body_angle) > abs(body_angle - (target_body_angle - PI * 2)):
		target_body_angle -= PI * 2
		
	# Print the target and current body angles if they're different and the character is moving.
	if target_body_angle != body_angle and move_direction.length() > 0:
		print("new: %s, current: %s" % [target_body_angle, body_angle])

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
