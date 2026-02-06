extends CharacterBody3D

@export_range(0, 10, 0.1)
var speed: float = 6.0
var running: bool = false

var player_logic
var player_binding

#@onready var animation_player: AnimationPlayer = $TimmyWalking/AnimationPlayer
#@onready var camera: Camera3D = %PLAYERCam
var base_cam_position: Vector3

func _ready():
	setup()
	on_ready()

func setup():
	player_logic = PlayerLogic.new()
	player_logic.set_player(self)
	#base_cam_position = camera.position

func on_ready():
	set_physics_process(true)
	bind_player_logic()
	_on_movement_computed(Vector3.DOWN)

func bind_player_logic():
	player_logic.connect("movement_computed", self._on_movement_computed)

var going = "left"
func _on_movement_computed(computed_velocity):
	var cam = get_viewport().get_camera_3d()
	var cam_direction = cam.get_global_transform().basis.y.normalized()
	var cam_left = cam_direction.cross(Vector3.UP)

	var normal_velocity = computed_velocity.dot(cam_left)
	if normal_velocity > 0.02:
		going = "right"
	elif normal_velocity < -0.02:
		going = "left"
	
	if going == "left":
		rotation = Vector3(0, PI/2, 0)
	else:
		rotation = Vector3(0, -PI/2, 0)
		
	rotation.x = 0
	rotation.z = 0
	velocity = computed_velocity

func _physics_process(_delta):
	var input_direction = Vector3.ZERO
	var cam_direction = get_viewport().get_camera_3d().get_global_transform().basis.z.normalized()
	var cam_left = cam_direction.cross(Vector3.UP)
	if Input.is_action_pressed("move_east"):
		input_direction.z -= 1.0
		#input_direction -= cam_left
	elif Input.is_action_pressed("move_west"):
		input_direction.z += 1.0
		#input_direction += cam_left

	if Input.is_action_pressed("move_north"):
		input_direction.x -= 1.0
		#input_direction -= cam_direction
	elif Input.is_action_pressed("move_south"):
		input_direction.x += 1.0
		#input_direction += cam_direction
	
	input_direction.y = -0.2
	if Input.is_action_pressed("move_up"):
		input_direction.y += 0.5
	elif Input.is_action_pressed("move_down"):
		input_direction.y -= 1.0

	running = Input.is_action_pressed("move_run")

	if input_direction != Vector3.ZERO:
		player_logic.input_moved(input_direction.normalized())
	if velocity != Vector3.ZERO and input_direction == Vector3.ZERO:
		player_logic.input_moved(input_direction)

	#if input_direction.length() > 0.4:
		#animation_player.speed_scale = velocity.length() * 0.4
		##animation_player.speed_scale = 1
		#animation_player.play("mixamo_com")
	#else:
		#if animation_player .is_playing():
			#animation_player.pause()
			#animation_player.seek(0.6, true)
	move_and_slide()

func _exit_tree():
	player_logic.stop()
