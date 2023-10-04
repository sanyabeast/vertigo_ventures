class_name VItemsManager

var items_lib: Dictionary = tools.get_resources_in_directory("res://resources/items/")
var content := {}

func _init(initial_items: Dictionary):
	print("ItemsManager initialising, initial items count: %s" % [initial_items.size()])
