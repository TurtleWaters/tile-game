extends Node3D

const width = 5
const length = 5
const tileDims = .5
var tile_set = []

func make_tile():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randIndex = rng.randi_range(0, 4)
	var epicList = ["Straight", "Cross", "T-Section", "Turn", "Stop"]
	
	var tile_instance = tile.new(epicList[randIndex], [(tile_set.size()-1) % width, (tile_set.size()-1) / width])
	
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
		print(tile_set.size())
	if Input.is_action_just_pressed("down"):
		tile_set[(tile_set.size())-1].queue_free()
		tile_set.pop_back()
		
