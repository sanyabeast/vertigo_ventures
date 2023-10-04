class_name VEquipmentManager
extends Node3D

@onready var root_node: Node3D = $Root
@onready var ray: RayCast3D = $RayCast3D

var current_equipped: VItem

# Called when the node enters the scene tree for the first time.
func _ready():
	print("equipment-manager initialising at '%s'" % [owner.name])
	ray.add_exception(self.owner)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_use():
	print("equipment: start using")
	if current_equipped != null:
		current_equipped.start_use()
	
func stop_use():
	print("equipment: stop using")
	if current_equipped != null:
		current_equipped.stop_use()
