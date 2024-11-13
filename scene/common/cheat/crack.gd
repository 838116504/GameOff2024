extends Cheat

func get_id():
	return 1

func execute(p_owner:PlayerUnit):
	var map:Map = p_owner.map_view.map
	for i in map.tile_id_list[p_owner.layer].size():
		if map.tile_id_list[p_owner.layer][i] == TileConst.TileId.WALL:
			map.set_tile(p_owner.layer, map._to_cell_position(i), TileConst.TileId.CRASHED_WALL)
	
	p_owner.bug_count -= 1
