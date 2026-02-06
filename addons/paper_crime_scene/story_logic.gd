extends Node

# Signals for outputs
signal chosen(choice)
signal displayable_text(text)
signal text_line(text)
signal dialog_line(char_name, text)
signal cut_scene(node_name, method_name)
signal spawn_at(target, vessel)
signal line_of_code(byte_code)
signal line_of_code_with_callback(code)
signal available_blocking_choices(choices)
signal available_interaction_choices(choices)

# States
enum State {
	INITIAL,
	TEXT_DISPLAYING,
	TEXT_DISPLAYED,
	AWAITING_CODE,
	AWAITING_BLOCKING_CHOICE,
	AWAITING_INTERACTION_CHOICE,
	DONE
}

var narration_provider
var current_state = State.INITIAL

func set_narration_provider(provider):
	narration_provider = provider

func start():
	_transition_to(State.INITIAL)

func input_start():
	if current_state == State.INITIAL:
		_next()

func input_chose(choice):
	if current_state in [State.AWAITING_BLOCKING_CHOICE, State.AWAITING_INTERACTION_CHOICE]:
		narration_provider.choose_choice_index(choice.index)
		print("Chose choice ", choice.text, " with index ", choice.index)
		emit_signal("chosen", choice)
		_next()

func input_advance(delta):
	if current_state == State.TEXT_DISPLAYING:
		var can_still_advance = narration_provider.advance(delta)
		emit_signal("displayable_text", narration_provider.current_displayed_text)
		if not can_still_advance:
			input_end_of_line()

func input_ack():
	if current_state == State.TEXT_DISPLAYING:
		narration_provider.skip()
		emit_signal("displayable_text", narration_provider.current_displayed_text)
		input_end_of_line()
	elif current_state == State.TEXT_DISPLAYED:
		_next()

func input_end_of_line():
	if current_state == State.TEXT_DISPLAYING:
		var previous_is_dialog = narration_provider.current_line() is NarrationProvider.Dialog
		if narration_provider.next_line():
			print("ON A UNE NEXT LINE")
			var line = narration_provider.current_line()
			if line is NarrationProvider.Dialog:
				if narration_provider.current_displayed_text != "":
					print("C'EST UN DIALOG !")
					_transition_to(State.TEXT_DISPLAYED)
				else:
					_next()
			elif previous_is_dialog and line is NarrationProvider.Text:
				print("C'EST UN TEXT (le précédent était un dialog) !")
				_transition_to(State.TEXT_DISPLAYED)
			else:
				print("C'EST UN WHAT ??")
				_next()
		else:
			print("ON N'A PAS DE NEXT LINE")
			if narration_provider.current_displayed_text != "":
				print("BAM DONE")
				_transition_to(State.TEXT_DISPLAYED)
			else:
				print("LET'S NEXT IT")
				_next()

func input_end_of_code():
	if current_state == State.AWAITING_CODE:
		input_end_of_line()

func _next():
	narration_provider.continue_story()
	if narration_provider.game_has_ended():
		_transition_to(State.DONE)
		return

	if narration_provider.ready_for_choices():
		_to_choices()
		return

	var line = narration_provider.current_line()
	if line is NarrationProvider.Code:
		var byte_code = line.content.substr(3).strip_edges()
		var match_spawn = narration_provider.spawn_at_regex.search(byte_code)
		var match_cutscene = narration_provider.cutscene_regex.search(byte_code)
		if match_spawn:
			var target_name = match_spawn.get_string(1)
			var vessel_name = match_spawn.get_string(3)
			emit_signal("spawn_at", target_name, vessel_name)
		elif match_cutscene:
			var node_name = match_cutscene.get_string(1)
			var method_name = match_cutscene.get_string(3)
			if line.content.begins_with(">>>"):
				emit_signal("cut_scene", node_name, method_name)
				_transition_to(State.TEXT_DISPLAYING)
				input_end_of_line()
			else:
				emit_signal("cut_scene", node_name, method_name)
				_transition_to(State.AWAITING_CODE)
		else:
			if line.content.begins_with(">>>"):
				emit_signal("line_of_code", line.content)
				input_end_of_line()
				_transition_to(State.TEXT_DISPLAYING)
			else:
				emit_signal("line_of_code_with_callback", line.content)
				_transition_to(State.AWAITING_CODE)
		return

	if line is NarrationProvider.Dialog:
		emit_signal("dialog_line", line.char_name, line.content)
	if line is NarrationProvider.Text:
		text_line.emit(line.content)

	_transition_to(State.TEXT_DISPLAYING)

func _to_choices():
	if narration_provider.blocking_choices().size() > 0:
		available_blocking_choices.emit(narration_provider.blocking_choices())
		_transition_to(State.AWAITING_BLOCKING_CHOICE)
	elif narration_provider.interaction_choices().size() > 0:
		emit_signal("available_interaction_choices", narration_provider.interaction_choices())
		_transition_to(State.AWAITING_INTERACTION_CHOICE)
	else:
		# No choices, stay in current state
		pass

func _transition_to(new_state):
	current_state = new_state
