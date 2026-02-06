extends Node

class_name PlayerLogic

signal movement_computed(velocity: Vector3)

enum State {
	DISABLED,
	ENABLED
}

var current_state: State = State.DISABLED
var player: CharacterBody3D = null
var game_repo = null

func set_player(_player):
	player = _player

func set_game_repo(_repo):
	game_repo = _repo

func start():
	current_state = State.DISABLED
	# Connect to game_repo signals if needed
	if game_repo:
		game_repo.connect("walking_started", Callable(self, "_on_walking_start"))
		game_repo.connect("reading_started", Callable(self, "_on_reading_start"))
		game_repo.connect("conversation_started", Callable(self, "_on_reading_start"))

func stop():
	# Disconnect signals if needed
	if game_repo:
		game_repo.disconnect("walking_started", Callable(self, "_on_walking_start"))
		game_repo.disconnect("reading_started", Callable(self, "_on_reading_start"))
		game_repo.disconnect("conversation_started", Callable(self, "_on_reading_start"))

func input_enable():
	if current_state == State.DISABLED:
		current_state = State.ENABLED

func input_disable():
	if current_state == State.ENABLED:
		emit_signal("movement_computed", Vector3.ZERO)
		current_state = State.DISABLED

func input_moved(direction: Vector3):
	if current_state == State.ENABLED and player:
		var velocity = direction * player.speed * (2 if player.running else 1)
		emit_signal("movement_computed", velocity)

func _on_walking_start():
	input_enable()

func _on_reading_start():
	input_disable()
