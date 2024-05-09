class_name unit

extends Node3D

var unit_goal
var min_dist

func _init(goal, dist):
	var unit_instance = preload("res://import models/unit models/mushUnit.glb").instantiate()
	add_child(unit_instance)
	unit_goal = goal
	min_dist = dist

func _process(delta):
	pass
