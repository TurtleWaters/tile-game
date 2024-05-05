class_name tile

extends Node3D
const type_dict = {
	"Straight": [[[0, -1], [0, 1]],
	preload("res://import models/tile models/straightTile.glb")],
	"Cross": [[[0, -1], [0, 1], [-1, 0], [1, 0]],
	preload("res://import models/tile models/crossTile.glb")],
	"Turn": [[[0, -1], [1, 0]],
	preload("res://import models/tile models/turnTile.glb")],
	"T-Section": [[[0, -1], [0, 1], [1, 0]],
	preload("res://import models/tile models/tSectionTile.glb")],
	"Stop": [[[0,-1]],
	preload("res://import models/tile models/stopTile.glb")]
}

var open_dirs = []
var tile_rot = 0
var tile_mod

func _init(tile_type: String):
	
	open_dirs = type_dict[tile_type][0]
	tile_mod = type_dict[tile_type][1]
	
	var tile_instance = tile_mod.instantiate()
	print(open_dirs)
	add_child(tile_instance)
	
func rotate_tile(degrees: int): 
	tile_rot = (tile_rot + (degrees * 90)) % 360
	
	print(tile_rot)
	
	var dirs_count = open_dirs.size()

	for i in dirs_count:
		for j in degrees:
			print(open_dirs[i])
			open_dirs[i] = [open_dirs[i][1] * -1, open_dirs[i][0]]

