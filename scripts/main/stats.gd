class_name VStatsManager

var stats_lib: Dictionary = tools.get_resources_in_directory("res://resources/stats/")
var values := {}

func _init(initial_stats: Dictionary):
	print("StatsManager initialising, initial stats count: %s" % [initial_stats.size()])
#	print("ASDASD %s" % [tools.dir_contents("res://resources/stats/")])
	print("ASDASD %s" % [stats_lib])
	for name in initial_stats:
		var value = initial_stats[name]
		assert(name is String, "stat name must be 'String'")
		assert(value is float, "stat '%s' value must be 'float'" % [name])
		assert(stats_lib.has(name), "stat with name '%s' does not described, create resource in 'res://resources/stats/'" % [name])
		set_stat(name, value)

func declare_stat(name: String)->void:
	if not values.has(name):
		values[name] = 0

func set_stat(name: String, value: float):
	values[name] = value
	print("setting stat '%s' value to '%s'" % [name, str(value)])
	
func get_stat(name: String) -> float:
	declare_stat(name)
	return values[name]
	
func alter_stat(name: String, value: float) -> float:
	declare_stat(name)
	values[name] += value
	if (values[name] <= 0):
		print("stat %s reached %s" % [name, str(value)])
		values[name] = 0
		
	return values[name]

