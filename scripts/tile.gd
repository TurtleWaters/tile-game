class_name tile

extends Node3D

const TileType = preload("res://scripts/TileType.gd").TileType
const Direction = preload("res://scripts/Direction.gd").Direction

const type_dict = {
	TileType.STRAIGHT: [[Direction.NORTH, Direction.SOUTH],
	preload("res://import models/tile models/straightTile.glb")],
	TileType.CROSS: [[Direction.WEST, Direction.EAST, Direction.SOUTH, Direction.NORTH],
	preload("res://import models/tile models/crossTile.glb")],
	TileType.TURN: [[Direction.EAST, Direction.SOUTH],
	preload("res://import models/tile models/turnTile.glb")],
	TileType.T: [[Direction.SOUTH, Direction.EAST, Direction.NORTH],
	preload("res://import models/tile models/tSectionTile.glb")],
	TileType.STOP: [[Direction.SOUTH],
	preload("res://import models/tile models/stopTile.glb")]
}


var open_dirs = []
var tile_rot = 0
var tile_mod
var coords = []

func _init(tile_type: TileType, inst_loc: Array):
	
	coords = inst_loc
	
	open_dirs = type_dict[tile_type][0]
	tile_mod = type_dict[tile_type][1]
	
	var tile_instance = tile_mod.instantiate()
	add_child(tile_instance)
	
func rotate_tile(degrees: int): 
	tile_rot = (tile_rot + (degrees * 90)) % 360
	
	var new_dirs = []
	
	for i in (open_dirs.size()):
		new_dirs.append(Direction.values()[(open_dirs[i] + 1) % 4])
	
	open_dirs = new_dirs
	
	print(open_dirs)
	
	self.rotation = Vector3(0, tile_rot * (PI/180), 0)
