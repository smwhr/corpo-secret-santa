extends Control

@onready var text_container: VBoxContainer = $TextContainer

func _ready():
	# You may want to set story_logic here, e.g. via autoload or passed reference
	pass

func clean():
	for child in text_container.get_children():
		child.queue_free()

func display_text(text: String):
	clean()
	var content_label = Label.new()
	content_label.text = text
	content_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	content_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	text_container.add_child(content_label)

func display_choices(choices: Array):
	clean()
	for choice in choices:
		var button = Button.new()
		button.text = choice.text
		button.pressed.connect(func():
			StoryLogic.input_chose(choice)
			clean()
		)
		text_container.add_child(button)

func _process(delta):
	StoryLogic.input_advance(delta)
