extends Node3D

const width = 7
const length = 7
const tileDims = .5
const post_process = 2

var tile_set = []
const TileType = preload("res://scripts/TileType.gd").TileType
const tile = preload("res://scripts/tile.gd")
const Direction = preload("res://scripts/Direction.gd").Direction
var rng = RandomNumberGenerator.new()

func _init():
	
	make_tile()
	
	for i in range (1, (width * length)):
		
		if (i == width / 2) || i == (width * (length - 1)) + (width / 2):
			var force_tile = tile.new(TileType.values()[1], [i % width, i / width])
			tile_set.append(force_tile)
			
			add_child(force_tile)
			
			force_tile.position = Vector3((i % width) * tileDims, 0, (i / width) * tileDims)
			force_tile.scale = Vector3(tileDims/2, tileDims, tileDims/2)
			
			continue
		
		var choices = []
		for j in TileType.size():
			var rot_scores = []
			var current_dirs = tile.type_dict[TileType.values()[j]][0]
			
			# rotation :(
			for k in 4:
				var rot_score = 1.0
				var rot_dirs = []
				var new_dirs = 0
				for l in current_dirs.size():
					new_dirs = (current_dirs[l] + k) % 4
					rot_dirs.append(new_dirs)
				
				# connections check
				# north
				if((i - width) >= 0 && (i - width) < tile_set.size() && tile_set[i - width].open_dirs.find(Direction.SOUTH) != -1 && rot_dirs.find(Direction.NORTH) != -1):
					rot_score += 1.0
				#west
				if((i - 1) >= 0 && (i - 1) < tile_set.size() && tile_set[i - 1].open_dirs.find(Direction.EAST) != -1 && rot_dirs.find(Direction.WEST) != -1):
					rot_score += 1.0
				
				if j == 1 || j == 4:
					rot_score = rot_score / 2.0
				
				rot_scores.append(rot_score)
			
			var score_divisor = 0.0
			for k in rot_scores.size():
				score_divisor += rot_scores[k]
			var rot_probs = []
			
			for k in rot_scores.size():
				rot_probs.append(rot_scores[k]/score_divisor)
			
			rng.randomize()
			var random_rot = rng.randf() 
			
			var rand_floor = 0
			
			
			for k in rot_probs.size():
				if random_rot < rot_probs[k] + rand_floor :
					choices.append([j, k, rot_scores[k]])
					break
				rand_floor += rot_probs[k]   
		
		var tot_score = 0.0
		for j in choices.size():
			tot_score += choices[j][2]
		
		var tile_probs = []
		for j in choices.size():
			tile_probs.append(choices[j][2]/tot_score)
		
		rng.randomize()
		var random_tile = rng.randf()
		var rand_tile_floor = 0
		
		for j in tile_probs.size():
			if random_tile < tile_probs[j] + rand_tile_floor:
				var tile_instance = tile.new(TileType.values()[choices[j][0]], [i % width, i / width])
				tile_set.append(tile_instance)
				
				add_child(tile_instance)
				
				tile_instance.position = Vector3((i % width) * tileDims, 0, (i / width) * tileDims)
				tile_instance.scale = Vector3(tileDims/2, tileDims, tileDims/2)
				tile_instance.rotate_tile(choices[j][1])
				
				break
			rand_tile_floor += tile_probs[j]
			
	# post process rotations
	for i in range (post_process):
		for h in (width * length):
			var current_dir = tile_set[h].open_dirs
			var con_score = [1.0,0]
			
			for j in range (4):
				var rot_score = 1.0
				var rot_dirs = []
				for k in current_dir.size():
					rot_dirs.append((current_dir[k] + j) % 4)
				
				
				# north
				if((h - width) >= 0 && (h - width) < tile_set.size() && tile_set[h - width].open_dirs.find(Direction.SOUTH) != -1 && rot_dirs.find(Direction.NORTH) != -1):
					rot_score += 1.0
					# east
				if((h + 1) % width != 0 && tile_set[h + 1].open_dirs.find(Direction.WEST) != -1 && rot_dirs.find(Direction.EAST) != -1):
					rot_score += 1.0
				# west
				if((h - 1) % width != width - 1 && (h - 1) >= 0 && (h - 1) < tile_set.size() && tile_set[h - 1].open_dirs.find(Direction.EAST) != -1 && rot_dirs.find(Direction.WEST) != -1):
					rot_score += 1.0
				# south
				if((h + width) < tile_set.size() && tile_set[h + width].open_dirs.find(Direction.NORTH) != -1 && rot_dirs.find(Direction.SOUTH) != -1):
					rot_score += 1.0
				
				if rot_score > con_score[0]:
					con_score = [rot_score, j]
			
			tile_set[h].rotate_tile(con_score[1])
			
func make_tile():
	rng.randomize()
	var randIndex = rng.randi_range(0, TileType.size()-1)
	
	var tile_instance = tile.new(TileType.values()[randIndex], [(tile_set.size()-1) % width, (tile_set.size()-1) / width])
	
	tile_set.append(tile_instance)
	
	add_child(tile_instance)
	
	tile_instance.position = Vector3(((tile_set.size()-1) % width) * tileDims, 0, ((tile_set.size()-1) / width) * tileDims)
	tile_instance.scale = Vector3(tileDims/2, tileDims, tileDims/2)

