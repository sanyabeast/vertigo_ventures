class_name Tools
extends Node

func nearest_multiple(num: float, divider: float) -> float:
	return round(num / divider) * divider

func direction_vector_to_direction_angle(direction: Vector3)-> float:
	return atan2(direction.x, direction.z)

func direction_angle_to_direction_vector(angle: float)-> Vector3: 
	return Vector3(sin(angle), 0., cos(angle))

func align_direction_vector_to_rotation_step(direction: Vector3, step: float)->Vector3:
	var angle = direction_vector_to_direction_angle(direction)
	angle = nearest_multiple(angle, deg_to_rad(step))
	return Vector3.ZERO.lerp(direction_angle_to_direction_vector(angle), direction.length())
	
func get_current_scene() -> Node3D:
	# The root is always the viewport
	var root = get_tree().get_root()
	
	# The current scene should be the last added child of the root
	return root.get_child(root.get_child_count() - 1)

# Generates a random Vector3 with each component in the range [from, to].
func random_point_xz(from: float, to: float) -> Vector3:
	return Vector3(
		randf_range(from, to), 
		0, 
		randf_range(from, to)
	)
