@tool
extends BTCondition

@export var node_path:String
@export var method_name:StringName
@export var include_delta:bool = false
@export var arg_list:Array[BBVariant]

func _generate_name() -> String:
	var meth:String
	var args:String = ""
	if method_name.is_empty():
		meth = "???"
	else:
		meth = method_name
	
	if include_delta:
		args += "delta"
	
	for i in arg_list:
		if !args.is_empty():
			args += ", "
		args += str(i)
	
	args = "(%s)" % args
	
	return "CallMethod " + meth + args + " node:" + str(node_path)

func _tick(p_delta):
	var obj = null
	if node_path.is_empty():
		obj = get_scene_root()
	else:
		var root = get_scene_root()
		if root:
			var res = root.get_node_and_resource(node_path)
			if res[1] != null:
				obj = res[1]
			else:
				obj = res[0]
	
	if obj == null:
		print_debug("CheckMethod: obj == null, node_path = ", node_path, " root = ", get_scene_root())
		return Status.FAILURE
	
	var args = []
	if include_delta:
		args.append(p_delta)
	
	for i in arg_list:
		args.append(i.get_value(get_scene_root(), get_blackboard()))
	
	obj.callv(method_name, args)
	return Status.SUCCESS