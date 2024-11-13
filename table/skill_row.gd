@tool
extends Resource

# 技能id
@export var id:int
# 名字
@export var name:String
# 描述
@export var description:String
# 图标
@export var icon:String
# 先手
@export var action_first:int
# cd
@export var cd:int
# 打击伤害
@export var strike_damage:int
# 突击伤害
@export var thrust_damage:int
# 斬击伤害
@export var slash_damage:int
# 是否隨机傷害类型
# (非0 = 是)
@export var random_damage_type:int
# 放置不消耗回合
# (非0 = 是)
@export var free_put:int
# 打击伤害增加倍率
@export var strike_damage_rate:float
# 突击伤害增加倍率
@export var thrust_damage_rate:float
# 斬击伤害增加倍率
@export var slash_damage_rate:float
# 效果id
@export var effect_id:int
# 充能次数
@export var charge_count:int
