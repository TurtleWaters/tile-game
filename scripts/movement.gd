extends CharacterBody3D


@export var walk_speed = 1
@export var speed = walk_speed
@export var sprint_speed = 2
const sens = 0.01

@onready var pivot = $Pivot
@onready var camera = $Pivot/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		pivot.rotate_y(-event.relative.x * sens)
		camera.rotate_x(-event.relative.y * sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func _physics_process(delta):

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var y_dir = 0
	
	if Input.is_action_pressed("up"):
		y_dir += 1
	if Input.is_action_pressed("down"):
		y_dir -= 1
	
	
	var direction = (pivot.transform.basis * Vector3(input_dir.x, y_dir, input_dir.y)).normalized()
	
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	if Input.is_action_just_released("sprint"):
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
