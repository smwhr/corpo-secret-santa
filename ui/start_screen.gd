extends Control

signal start_the_game

@onready var start_button: Button = %StartButton
#@onready var continue_button: Button = %ContinueButton

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	start_the_game.emit()
