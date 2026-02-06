extends Node3D

class_name Game

const INITIAL_SET_PATH := "res://sets/office_set.tscn"
const PLAYER_SCENE_PATH := "res://characters/player.tscn"

var narration_provider
var game_logic
var game_binding
var story_binding
var instantiator
var player_character
var story_stage
#@onready var pcam: PhantomCamera3D = $PhantomCamera3D
@onready var story = $InkPlayer

func _ready():
	game_logic = GameLogic.new()
	
	story.connect("loaded", self._story_loaded)
	story.loads_in_background = false
	story.create_story()
	
	story_stage = load(INITIAL_SET_PATH).instantiate()
	story_stage.connect("player_left_area", respawn_player)
	$StoryStage.add_child(story_stage)
	on_nodes_resolved()
	

func _story_loaded(successfully: bool):
	if !successfully:
		print("Story failed to load")
		return
	
	narration_provider = NarrationProvider.new(story)
	StoryLogic.set_narration_provider(narration_provider)
	on_story_resolved()


func clean_story_content():
	var container = $StoryScreen
	container.clean()

func on_nodes_resolved():
	game_logic.connect("started", self._on_game_started)
	game_logic.connect("state_changed", self._on_game_state_changed)

func on_story_resolved():
	StoryLogic.connect("displayable_text", self._on_displayable_text)
	StoryLogic.connect("available_blocking_choices", self._on_available_blocking_choices)
	StoryLogic.connect("available_interaction_choices", self._on_available_interaction_choices)
	StoryLogic.connect("cut_scene", self._on_cut_scene)
	StoryLogic.connect("dialog_line", self._on_dialog_line)
	StoryLogic.connect("text_line", self._on_text_line)
	
func respawn_player():
	story_stage.set_player(player_character)

func _on_game_started():
	player_character = load(PLAYER_SCENE_PATH).instantiate()
	story_stage.set_player(player_character)
	$StoryStage.show()
	$StartScreen.hide()
	StoryLogic.input_start()

func _on_game_state_changed(state):
	print("game state changed to: ", state)
	match state:
		GameLogic.State.WALKING:
			if player_character:
				player_character.player_logic.input_enable()
			$StoryScreen.hide()
			$StoryScreen.clean()
			$DialogueScreen.hide()
			$DialogueScreen.clean()
		GameLogic.State.READING:
			if player_character:
				player_character.player_logic.input_disable()
			$StoryScreen.show()
			$DialogueScreen.clean()
			$DialogueScreen.hide()
		GameLogic.State.DIALOGUING:
			player_character.player_logic.input_disable()
			#$DialogueScreen.clean()
			$StoryScreen.clean()
			#var protagonists = narration_provider.current_protagonists().filter(func(t): return t != "RENARD")
			#var cam1 = player_character.get_node("%RENARDCam")
			#var cam2 = story_stage.get_camera_for(protagonists[0] if protagonists.size() > 0 else "NOONE")
			#$DialogueScreen.setup_cameras(cam1, cam2)
			$DialogueScreen.show()

func _on_displayable_text(text):
	if game_logic.current_state == GameLogic.State.DIALOGUING :
		$DialogueScreen.display_current_text(text)
	else:
		$StoryScreen.display_text(text)

func _on_available_blocking_choices(choices):
	$StoryScreen.display_choices(choices)
	$StoryScreen.show()
	game_logic.display_story.emit()

func _on_available_interaction_choices(_choices):
	$StoryScreen.hide()
	game_logic.hide_story.emit()

func _on_cut_scene(node_name, method_name):
	var node = story_stage.get_node(node_name)
	node.call(method_name)
	node.connect("ended", _on_code_end)

func _on_dialog_line(char_name, _text):
	game_logic.start_conversation.emit()
	print("Char ", char_name, " will say ", _text)
	$DialogueScreen.next_dialog(char_name)

func _on_text_line(_text):
	print("JustText ", " will say ", _text)
	game_logic.display_story.emit()

func _on_code_end():
	StoryLogic.input_end_of_code()

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		StoryLogic.input_ack()
	if Input.is_action_just_pressed("zoom_in"):
		print("zoom in")
		story_stage.zoom_in()
	if Input.is_action_just_pressed("zoom_out"):
		print("zoom out")
		story_stage.zoom_out()

func on_start_the_game():
	game_logic.start_the_game.emit()

func _physics_process(_delta):
	if Input.is_action_pressed("respawn"):
		respawn_player()
