extends Node
class_name EventBus

# 先在event_const.gd里加事件，用listen來監听事件，unlisten取消監听。用emit_signal触发事件
signal event_triggered(p_event)

var event_triggered_list = [
	_on_0_param_event_triggered,
	_on_1_param_event_triggered,
	_on_2_param_event_triggered,
	_on_3_param_event_triggered
]

func _init():
	for i in EventConst.INFO_LIST:
		add_user_signal(i[0], i[1])
		var paramCount = i[1].size()
		connect(i[0], event_triggered_list[paramCount].bind(i[0]))

func listen(p_event:StringName, p_call:Callable, p_flag = 0):
	assert(!is_connected(p_event, p_call))
	
	connect(p_event, p_call, p_flag)

func unlisten(p_event:StringName, p_call:Callable):
	assert(is_connected(p_event, p_call))
	
	disconnect(p_event, p_call)


func _on_0_param_event_triggered(p_event):
	event_triggered.emit(p_event)

func _on_1_param_event_triggered(_param1, p_event):
	event_triggered.emit(p_event)

func _on_2_param_event_triggered(_param1, _param2, p_event):
	event_triggered.emit(p_event)

func _on_3_param_event_triggered(_param1, _param2, _param3, p_event):
	event_triggered.emit(p_event)
