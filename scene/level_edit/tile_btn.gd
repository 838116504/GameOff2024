extends TextureButton

var tile_id:int : set = set_tile_id

func set_tile_id(p_value):
	if tile_id == p_value:
		return
	
	tile_id = p_value
	var tile = TileConst.TILE_LIST[tile_id]
	if tile:
		var tileSource = TileConst.TILE_SET.get_source(tile_id)
		assert(tileSource is TileSetAtlasSource)
		texture_normal = tileSource.texture
