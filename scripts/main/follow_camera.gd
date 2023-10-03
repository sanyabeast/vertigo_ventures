class_name VFollowCamera
extends Node3D

# Mouse sensitivity for the camera controls
@export var mouse_sensitivity: float = 0.5;

# NodePath to the target (e.g., player) the camera should follow
@export var target_path: NodePath

# Offset for where the camera should focus relative to the target
@export var camera_direction_shift: Vector3 = Vector3(1, 1.5, 2)

# Speed at which the camera's focus point eases towards its desired position
@export var camera_direction_shift_ease_speed = 2

# Reference to the actual target node the camera should follow
var target: Node3D

# Camera's main root node
@onready var camera_root = $CameraRoot

# The actual 3D camera node
@onready var camera: Camera3D = $CameraRoot/Anchor/Camera3D

func _ready():
	game_manager.camera = self
	# Get the target node from the provided NodePath
	if target_path:
		target = get_node(target_path)
		if not target:
			print("Error: Target node not found!")
	else:
		print("Error: Target path not set!")
	print(players_manager.player)

func _exit_tree():
	if game_manager.camera == self:
		game_manager.camera = null

func _process(delta):
	# If the target is available, update the camera's position and orientation
	if target:
		# Calculate the desired position for the camera root based on the target's position
		var desired_position = Vector3(target.global_transform.origin.x, global_transform.origin.y, target.global_transform.origin.z)
		
		# Check if the target is of type VCharacter
#		if target is VCharacter:
#			# Get the target's move direction
#			var direction: Vector3 = target.move_direction
#
#			# Update the position of the camera_root based on the target's move direction
#			camera_root.position = camera_root.position.move_toward(Vector3(
#				# Lerp between the left and right offsets based on the target's X direction
#				lerp(camera_direction_shift.x, -camera_direction_shift.x, (direction.x + 1) / 2),
#
#				# Lerp the Y offset based on the target's move direction magnitude
#				lerp(0.0, camera_direction_shift.y, direction.length()),
#
#				# Lerp the Z offset based on the target's forward/backward direction
#				lerp(0.0, camera_direction_shift.z, abs(direction.z)),
#			), camera_direction_shift_ease_speed * delta)
		
		# Set the camera root's global position to the previously calculated desired position
		global_transform.origin = desired_position
		
		# Make the camera look at the target's global position
#		camera.look_at(target.global_position + Vector3(0, -0.25, 0));
