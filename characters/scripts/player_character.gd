class_name VPlayerCharacter
extends VCharacter


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)
	pass

func process_behaviour(delta: float)-> void:
	if Input.is_action_just_pressed("jump"):
		requesting_jump = true
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	move_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
