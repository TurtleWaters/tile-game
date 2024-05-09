extends CharacterBody3D


@export var walk_speed = 1
@export var speed = walk_speed
@export var sprint_speed = 2
const sens = 0.01
const ray_length = 1000

var free = true

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D
@onready var board = $"../board"

var unit_group = preload("res://scenes/unit_group.tscn").get_script()

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion && free == true:
		pivot.rotate_y(-event.relative.x * sens)
		camera.rotate_x(-event.relative.y * sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func _physics_process(delta):
	
	#raycast for moving!!!
	if Input.is_action_just_pressed("click") && (free == false):
		var space_state = get_world_3d().direct_space_state
		var mouse_pos = get_viewport().get_mouse_position()
		
		var origin = camera.project_ray_origin(mouse_pos)
		var end = origin + camera.project_ray_normal(mouse_pos) * ray_length
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		
		var ray_result = space_state.intersect_ray(query)
		
		print(ray_result)
		
		if ray_result.size() > 0 && ray_result.collider is unit_group:
			print("WE FOUND THAT SHIT!!!!")
		
	if Input.is_action_just_pressed("free_cam"):
		if free == true:
			free = false
			speed = 0
			self.position.x = (board.width / 2) * board.tileDims
			self.position.z = (board.length * board.tileDims) / 1.5
			self.position.y = 2.2
			pivot.rotation.y = 0
			
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			camera.rotation.x = -deg_to_rad(75)
		elif free == false:
			free = true
			speed = walk_speed
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var y_dir = 0
	
	if Input.is_action_pressed("up"):
		y_dir += 1
	if Input.is_action_pressed("down"):
		y_dir -= 1
	
	
	var direction = (pivot.transform.basis * Vector3(input_dir.x, y_dir, input_dir.y)).normalized()
	
	if Input.is_action_pressed("sprint") && free == true:
		speed = sprint_speed
	if Input.is_action_just_released("sprint") && free == true:
		speed = walk_speed
		
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		velocity.y = direction.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	
	move_and_slide()
