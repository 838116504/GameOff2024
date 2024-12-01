@tool
extends Resource

# 集合id
@export var id:int
# 戰斗地圖id
@export var fight_map_id:int
# 戰斗地圖格数
@export var fight_map_cell:int
# unit id數組
@export var unit_id_list:Array
# 追隨單位戰斗起始位置
@export var unit_fight_x_list:Array
# 追隨單位戰斗起始方向
# (1=右,其他左)
@export var unit_fight_dir_list:Array
