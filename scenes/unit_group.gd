extends Node3D

const min_dist = 0.2
const max_dist = 1
@export var group_size = 5
const unit = preload("res://scenes/unit.gd")

const direction_dict = preload("res://scripts/Direction.gd").direction_dict

var board
var unit_set = []
const unit_scale = .25

var tile_coords = [0, 0]
var tile_dims
var raycast_col

var walk_areas = []

var goal

func _ready():
	goal = $goal
	
	board = $"../board"
	raycast_col = $StaticBody3D
	
	tile_dims = board.tileDims/2
	self.position = Vector3(tile_coords[0] * tile_dims, 0.1, tile_coords[1] * tile_dims)
	raycast_col.scale = Vector3(tile_dims * 2, tile_dims, tile_dims * 2)
	
	get_tile_area()
	
	for i in group_size:
		create_unit()
	disperse_units()

func get_tile_area():
	var tile_dirs = board.tile_set[(tile_coords[1] * board.width) + tile_coords[0]].open_dirs
	
	walk_areas = [[1, 1]]
	
	for i in range (tile_dirs.size()):
		walk_areas.append(direction_dict[tile_dirs[i]])

func disperse_units():
	
	var rng = RandomNumberGenerator.new()
	
	var sub_dims = tile_dims * 0.33
	
	print(walk_areas)
	
	for i in group_size:
		rng.randomize()
		var rand_x = randf() * sub_dims
		
		rng.randomize()
		var rand_y = randf() * sub_dims
		
		print("Unit walk area: " + str(walk_areas[i % walk_areas.size()]))
		
		unit_set[i].global_position = Vector3(tile_coords[0] * tile_dims + ((walk_areas[i % walk_areas.size()][0] - 1.5) * sub_dims) + rand_x, 0.05, tile_coords[1] * tile_dims * board.width + ((walk_areas[i % walk_areas.size()][1] - 1.5) * sub_dims) + rand_y)
		unit_set[i].scale = Vector3(unit_scale,unit_scale,unit_scale)
		unit_set[i].rotation = Vector3(0, randi_range(0, 90), 0)

func create_unit():
	var new_unit = unit.new(goal, min_dist)
	unit_set.append(new_unit)
	add_child(new_unit)


func destroy_unit(dead_unit):
	var unit_loc = unit_set.find(dead_unit)
	dead_unit.queue_free()
	unit_set.remove_at(unit_loc)
