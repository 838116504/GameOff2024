extends FightCellItem

var damage_type:SkillConst.DamageType
var damage:int

func _unit_entered(p_unit:Unit):
	p_unit.hit(null, damage_type, damage)
	fight_scene.erase_cell_item(self)
