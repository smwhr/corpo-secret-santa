extends Control

class_name Bubble

@onready var character_name_label: Label = $Wrapper/InnerWrapper/CharacterName
@onready var bubble_text_label: Label = $Wrapper/InnerWrapper/Text
@onready var left_arrow: Control = $Wrapper/LeftArrow
@onready var right_arrow: Control = $Wrapper/RightArrow

var dialog_text: String:
	get:
		return bubble_text_label.text
	set(value):
		bubble_text_label.text = value + "  "

var character_name: String:
	get:
		return character_name_label.text
	set(value):
		character_name_label.text = value + "  "

func display_text(text: String):
	dialog_text = text
	
func display_arrow(side: String):
	if side == "left":
		left_arrow.show()
		right_arrow.hide()
	else:
		right_arrow.show()
		left_arrow.hide()
