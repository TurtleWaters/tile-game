extends Node3D

const width = 1
const length = 1
const tileDims = .5
var tile_set = []

func _init():
	var rng = RandomNumberGenerator.new()
	
	for i in range (width * length):
		rng.randomize()
		var randIndex = rng.randi_range(0, 4)
		var epicList = ["Straight", "Cross", "T-Section", "Turn", "Stop"]
		
		var tile_instance = tile.new(epicList[randIndex])
		
		tile_set.append(tile_instance)
		
		print(epicList[randIndex])
		
		add_child(tile_instance)
		
		tile_instance.position = Vector3((i % width) * tileDims, 0, (i / width) * tileDims)
		tile_instance.scale = Vector3(tileDims/2, tileDims, tileDims/2)
		tile_instance.rotate_tile(1)
