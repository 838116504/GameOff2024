@tool
extends Resource

# 單位id
@export var id:int
# 名字
@export var name:String
# 血量
@export var hp:int
# 防禦
@export var def:int
# 被打擊傷害倍率
@export var strike_hit_rate:float
# 被突擊傷害倍率
@export var thrust_hit_rate:int
# 被斬擊傷害倍率
@export var slash_hit_rate:int
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
# 皮肤名字
@export var skin:String
# 行为树id
@export var bt_id:int
# 学习的技能id
@export var learn_skill_id:int
