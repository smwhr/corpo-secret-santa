extends Node3D

signal player_left_area

@onready var SetCam = $SetCam
@onready var Cam3D = $Camera3D

var current_player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_player(player_character):
	if not current_player:
		current_player = player_character
		add_child(player_character)
	current_player.position = get_node("EnterPosition").position
	SetCam.set_follow_target(current_player)
	#SetCam.set_follow_offset(Vector3(8, 3.1, 1))
	SetCam.set_follow_offset(Vector3(7, 6.5, -4))
	SetCam.set_follow_damping(true)
	SetCam.set_follow_damping_value(Vector3(0.25, 0, 0.25))
	
func zoom_in():
	Cam3D.size = max(3, Cam3D.size/1.2)
	print(Cam3D.size)
func zoom_out():
	Cam3D.size = min(16, Cam3D.size*1.2)
	print(Cam3D.size)
	

func _on_area_3d_body_exited(body: Node3D) -> void:
	print("BODY EXITED GAME AREA")
	player_left_area.emit()
