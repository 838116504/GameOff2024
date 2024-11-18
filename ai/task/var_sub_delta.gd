@tool
extends BTAction

@export var variable:StringName

func _generate_name() -> String:
	if variable.is_empty():
		return "VarSubDelta ??? -= delta"
	
	return "VarSubDelta $%s -= delta" % variable

func _tick(p_delta):
	if variable.is_empty():
		print_debug("variable.is_empty()")
		return Status.FAILURE
	
	var result = get_blackboard().get_var(variable, null)
	if !result is float:
		print_debug("!result is float")
		return Status.FAILURE
	
	get_blackboard().set_var(variable, result - p_delta)
	return Status.SUCCESS
