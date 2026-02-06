extends Control

signal click

@onready var marker_text_label: Button = $Label
@onready var marker_button: Button = $Label/Button

var text: String:
	get:
		return marker_text_label.text
	set(value):
		marker_text_label.text = value + "  "

func _ready():
	marker_text_label.pressed.connect(func():
		emit_signal("click")
	)
