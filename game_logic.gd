extends Node

class_name GameLogic

enum State {
	INITIAL, #0
	WALKING, #1
	READING, #2
	DIALOGUING, #3
	CUTSCENE #4
}

# Input signals
signal start_the_game
signal display_story
signal start_conversation
signal hide_story

# Output signals
signal started
signal state_changed(new_state)

var current_state : State = State.INITIAL

func _init():
	print("GAME LOGIC READY")
	# Connect input signals to handlers
	start_the_game.connect(self._on_start_the_game)
	display_story.connect(self._on_display_story)
	start_conversation.connect(self._on_start_conversation)
	hide_story.connect(self._on_hide_story)
	# Set initial state
	_set_state(State.INITIAL)

func _set_state(new_state : State):
	current_state = new_state
	state_changed.emit(new_state)

func _on_start_the_game():
	if current_state == State.INITIAL:
		_set_state(State.WALKING)
		emit_signal("started")

func _on_display_story():
	print("_on_display_story", current_state)
	if current_state in [State.WALKING, State.READING, State.DIALOGUING, State.CUTSCENE]:
		print("Set State to READING")
		_set_state(State.READING)

func _on_start_conversation():
	if current_state in [State.WALKING, State.READING, State.DIALOGUING, State.CUTSCENE]:
		print("Set State to DIALOGUING")
		_set_state(State.DIALOGUING)

func _on_hide_story():
	if current_state in [State.WALKING, State.READING, State.DIALOGUING, State.CUTSCENE]:
		print("Set State to WALKING")
		_set_state(State.WALKING)
