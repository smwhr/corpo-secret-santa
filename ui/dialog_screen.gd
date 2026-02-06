extends Control

@onready var bubble_container: VBoxContainer = $BubbleContainer
#@onready var viewport1: SubViewport = $Viewports/ViewportContainer1/SubViewport
#@onready var viewport2: SubViewport = $Viewports/ViewportContainer2/SubViewport

var pointed_dialog: Bubble = null
var current_character: String = "NULL"

func clean():
	for child in bubble_container.get_children():
		child.queue_free()
	pointed_dialog = null

func update_container():
	pointed_dialog.custom_minimum_size = Vector2(pointed_dialog.size.x, pointed_dialog.character_name_label.size.y + pointed_dialog.bubble_text_label.size.y + 5)
	pointed_dialog.update_minimum_size()


func display_current_text(text: String):
	current_dialog().display_text(text)
	update_container()

func current_dialog() -> Bubble:
	return pointed_dialog

func next_dialog(char_name: String) -> Bubble:
	if pointed_dialog:
		update_container()
	var bubble = load("res://ui/bubble.tscn").instantiate()
	bubble.hide()
	bubble_container.add_child(bubble)
	bubble.character_name = char_name
	bubble.dialog_text = ""
	bubble.display_arrow("left" if (char_name == "PLAYER") else "right")
	bubble.show()
	pointed_dialog = bubble
	return pointed_dialog

func setup_cameras(cam1: Camera3D, cam2: Camera3D):
	return
	# Clean cameras
	#for child in viewport1.get_children():
		#child.queue_free()
	#for child in viewport2.get_children():
		#child.queue_free()
	#var global_cam = get_viewport().get_camera_3d()
	#var dup_cam1 = cam1.duplicate()
	#dup_cam1.position = cam1.global_position
	#dup_cam1.attributes = cam1.attributes.duplicate()
	#dup_cam1.environment = global_cam.environment
	#viewport1.add_child(dup_cam1)
	#if cam2 != null:
		#var dup_cam2 = cam2.duplicate()
		#dup_cam2.position = cam2.global_position
		#dup_cam2.attributes = cam2.attributes.duplicate()
		#dup_cam2.rotation = cam2.global_rotation
		#dup_cam2.environment = global_cam.environment
		#viewport2.add_child(dup_cam2)
