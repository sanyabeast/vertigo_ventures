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

func dir_contents(path):
	var dir = DirAccess.open(path)
	var result: Array[String] = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				result.push_back(file_name)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return result

func get_resources_in_directory(directory_path: String) -> Dictionary:
	var resources = {}
	var dir = DirAccess.open(directory_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and (file_name.ends_with(".tres") or file_name.ends_with(".res")):
				var resource_path = directory_path + "/" + file_name
				var resource = load(resource_path)
				if resource is Resource:
					var key_name = file_name.get_basename()  # Get name without extension
					resources[key_name] = resource
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
	
	return resources
