extends Area3D

@onready var marker: Node3D = $Marker
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var prop_logic: PropLogic
var prop_binding
var story_binding
var choice:InkChoice = null
var marker_label
var tag = ""
var body_in_zone = false

func _ready():
	set_collision_mask_value(1,false)
	set_collision_mask_value(2,true)
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, true)

	prop_logic = PropLogic.new()
	prop_logic_setup()
	prop_logic.start()
	marker.hide()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	StoryLogic.connect("available_interaction_choices", _on_available_interaction_choices)
	StoryLogic.connect("chosen", _choose_and_clear)
	

func create_marker_label(text: String):
	var marker_label_scene = load("res://addons/paper_crime_scene/marker_label.tscn")
	marker_label = marker_label_scene.instantiate()
	marker_label.hide()
	add_child(marker_label)
	marker_label.text = text
	return marker_label

func choose():
	if choice:
		StoryLogic.input_chose(choice)
		print("Chosen ", choice.text, " ", choice.index)

func prop_logic_setup():
	prop_logic.connect("associated", Callable(self, "_on_associated"))
	prop_logic.connect("entered_zone", Callable(self, "_on_entered_zone"))
	prop_logic.connect("exited_zone", Callable(self, "_on_exited_zone"))
	prop_logic.connect("interacted_with", Callable(self, "_on_interacted_with"))
	prop_logic.connect("cleared", Callable(self, "_on_cleared"))
	prop_logic.start()


# STORY TRIGGERS

func _on_available_interaction_choices(choices: Array):
	print("Received available_interaction_choices")
	if has_meta("tag"):
		tag = get_meta("tag") 
		for c:InkChoice in choices:
			if c.text.begins_with("tag: " + tag):
				prop_logic.input_associate_choice(c)
				if body_in_zone:
					prop_logic.input_enter_zone()
				return
	prop_logic.input_clear()

func _choose_and_clear(_choice): # callback from StoryLogic
	prop_logic.input_clear()

# USER TRIGGERS
func _on_body_entered(body):
	tag = get_meta("tag") if has_meta("tag") else ""
	print("BODY ENTERED THE ", tag)
	body_in_zone = true
	prop_logic.input_enter_zone()

func _on_body_exited(body):
	tag = get_meta("tag") if has_meta("tag") else ""
	print("BODY EXITED THE ", tag)
	body_in_zone = false
	prop_logic.input_exit_zone()


# LOGIC TRIGGERS
func _on_associated(_choice):
	
	choice = _choice
	tag = get_meta("tag") if has_meta("tag") else ""
	var label_text = ""
	if _choice.text.length() == tag.length() + 5:
		label_text = _choice.text.substr(5).capitalize()
	else:
		label_text = _choice.text.substr(tag.length() + 5)
	marker_label = create_marker_label(label_text)

func _on_entered_zone():
	marker.show()
	marker_label.show()
	marker_label.get_node("Label").connect("pressed", Callable(self, "choose"))

func _on_exited_zone():
	marker.hide()
	marker_label.hide()
	marker_label.get_node("Label").disconnect("pressed", Callable(self, "choose"))

func _on_interacted_with(_choice): # locally interacted, transmit to story
	marker.hide()
	prop_logic.input_clear()
	StoryLogic.input_chose(_choice)
	
func _on_cleared():
	marker.hide()
	if marker_label: #just in case
		print("Clearing the marker label")
		marker_label.queue_free()

func _input(event):
	if event.is_action_pressed("interact"):
		prop_logic.input_interact()

func _process(delta):
	if marker_label and marker.visible:
		var camera = get_viewport().get_camera_3d()
		marker_label.position = camera.unproject_position(marker.global_position)
