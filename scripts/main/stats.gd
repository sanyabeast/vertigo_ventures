class_name VStatsManager

var stats_lib = config.stats_lib
var values := {}

signal exhausted(name: String, new_value: float, old_value: float)
signal restored(name: String, new_value: float, old_value: float)
signal incremented(name: String, new_value: float, old_value: float)
signal decremented(name: String, new_value: float, old_value: float)


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
	declare_stat(name)
	var prev_value: float = values[name]
	value = clamp(value, 0, INF)
	values[name] = value
	if prev_value != value:
		if value == 0:
			exhausted.emit(name, value, prev_value)
		if value != 0 and prev_value == 0:
			restored.emit(name, value, prev_value)
		if value > prev_value:
			incremented.emit(name, value, prev_value)
		if value < prev_value:
			decremented.emit(name, value, prev_value)
	print("setting stat '%s' value to '%s'" % [name, str(value)])
	
func get_stat(name: String) -> float:
	declare_stat(name)
	return values[name]
	
func alter_stat(name: String, value: float) -> float:
	declare_stat(name)
	set_stat(name, values[name] + value)
	return values[name]
