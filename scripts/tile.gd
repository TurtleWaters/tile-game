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
var coords = []

func _init(tile_type: String, inst_loc: Array):
	
	coords = inst_loc
	
	open_dirs = type_dict[tile_type][0]
	tile_mod = type_dict[tile_type][1]
	
	var tile_instance = tile_mod.instantiate()
	add_child(tile_instance)
	
func rotate_tile(degrees: int): 
	tile_rot = (tile_rot + (degrees * 90)) % 360
	
	var new_dirs = []
	
	var dirs_count = open_dirs.size()

	for i in dirs_count:
		for j in degrees:
			new_dirs.append([open_dirs[i][1] * -1, open_dirs[i][0]])
	open_dirs = new_dirs
	
	self.rotation = Vector3(0, tile_rot * (PI/180), 0)
