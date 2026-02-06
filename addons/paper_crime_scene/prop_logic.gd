extends Node

class_name PropLogic

signal associated(choice)
signal entered_zone()
signal exited_zone()
signal interacted_with(choice)
signal cleared()

enum State {
	DISABLED = 0,
	ENABLED,
	INTERACTABLE,
	INTERACTING
}

var current_state: State = State.DISABLED
var choice = null

func start():
	current_state = State.DISABLED

func input_associate_choice(_choice):
	choice = _choice
	if current_state == State.DISABLED:
		associated.emit(choice)
		print("Set Prop State to ENABLED")
		current_state = State.ENABLED

func input_clear():
	choice = null
	print("CLEARED HERE 1")
	cleared.emit()
	print("Set Prop State to DISABLED")
	current_state = State.DISABLED

func input_enter_zone():
	if current_state == State.ENABLED and choice != null:
		entered_zone.emit()
		print("Set Prop State to INTERACTABLE")
		current_state = State.INTERACTABLE

func input_exit_zone():
	if current_state == State.INTERACTABLE:
		exited_zone.emit()
		print("Set Prop State to ENABLED")
		current_state = State.ENABLED

func input_interact():
	if current_state == State.INTERACTABLE and choice != null:
		print("Set Prop State to INTERACTING")
		current_state = State.INTERACTING
		interacted_with.emit(choice)
		
