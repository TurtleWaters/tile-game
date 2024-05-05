extends Node3D

const width = 7
const length = 7
const tileDims = .5
var tile_set = []
const TileType = preload("res://scripts/TileType.gd").TileType
const tile = preload("res://scripts/tile.gd")

func _init():
	make_tile()
	
	for i in (width * length):
		var choices = []
		for j in TileType.size():
			var rot_scores = []
			var current_dirs = tile.type_dict[TileType.values()[j]]
			# rotation :(
			for k in 4:
				var rot_score = 0
				var rot_dirs = []
				var new_dirs
				var dirs_count = current_dirs.size()
			
				
				
				
				
func make_tile():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randIndex = rng.randi_range(0, TileType.size()-1)
	
	var tile_instance = tile.new(TileType.values()[randIndex], [(tile_set.size()-1) % width, (tile_set.size()-1) / width])
	
	tile_set.append(tile_instance)
	
	add_child(tile_instance)
	
	tile_instance.position = Vector3(((tile_set.size()-1) % width) * tileDims, 0, ((tile_set.size()-1) / width) * tileDims)
	tile_instance.scale = Vector3(tileDims/2, tileDims, tileDims/2)

func _input(event):
	if Input.is_action_just_pressed("right"):
		tile_set[(tile_set.size())-1].rotate_tile(3)
	if Input.is_action_just_pressed("left"):
		tile_set[(tile_set.size())-1].rotate_tile(1)
	if Input.is_action_just_pressed("up"):
		make_tile()
	if Input.is_action_just_pressed("down"):
		tile_set[(tile_set.size())-1].queue_free()
		tile_set.pop_back()
		
