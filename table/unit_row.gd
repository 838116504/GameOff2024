@tool
extends Resource

# 物品id
@export var id:int
# 血量
@export var hp:int
# 打防
@export var strike_def:int
# 突防
@export var thrust_def :int
# 斬防
@export var slash_def :int
# 速度
@export var spd:int
# 技能id數組
@export var skill_id_list:Array
# 戰斗起始位置
@export var fight_x:int
# 戰斗起始方向
# (1=右,其他左)
@export var fight_dir:int
# 追隨unit id數組
@export var follow_unit_id_list:Array
# 追隨單位戰斗起始位置
@export var follow_unit_fight_x_list:Array
# 追隨單位戰斗起始方向
# (1=右,其他左)
@export var follow_unit_fight_dir_list:Array
# 戰斗地圖id
@export var fight_map_id:int
# 戰斗地圖格数
@export var fight_map_cell:int
# 正面圖片
@export var image:String
# 向右圖片
@export var right_image:String
