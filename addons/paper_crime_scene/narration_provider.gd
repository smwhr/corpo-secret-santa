extends Object

class_name NarrationProvider

const SPEED := 20.0 # chars per sec

var story : InkPlayer
var current_lines : Array = []
var current_line_pointer : int = -1
var current_display_time : float = 0.0
var current_displayed_text : String = ""
var current_choices : Array = []

# Helper structs
class Code:
	var content : String
	func _init(_content): content = _content

class Text:
	var content : String
	func _init(_content): content = _content

class Dialog:
	var char_name : String
	var content : String
	func _init(_char_name, _content):
		char_name = _char_name
		content = _content

func _init(_story: InkPlayer):
	story = _story
	compile_regex()

func is_code(line : String) -> bool:
	return line.begins_with(">>>") or line.begins_with("<<<")

var dialog_regex := RegEx.new()
var cutscene_regex := RegEx.new()
var spawn_at_regex := RegEx.new()
var text_regex := RegEx.new()

func n(d):
	return "ok" if d == 0 else "no"

func compile_regex():
	var d = dialog_regex.compile(r'^\s*([A-Z]*):\s*(.*)\s*$')
	var c = cutscene_regex.compile(r'CUTSCENE\(([^),\s]*)([\s]*,[\s]*([^)]+))*\)')
	var s = spawn_at_regex.compile(r'SPAWN_AT\(([^),\s]*)([\s]*,[\s]*([^)]+))*\)')
	var t = text_regex.compile(r'[^\w]')

func is_dialog(line : String) -> bool:
	return dialog_regex.search(line) != null

func is_pure_text(line : String) -> bool:
	return not is_code(line) and not is_dialog(line)

func is_text(line : String) -> bool:
	return not is_code(line)

func current_line():
	if current_line_pointer >= 0 and current_line_pointer < current_lines.size():
		return current_lines[current_line_pointer]
	return null

func blocking_choices() -> Array:
	return current_choices.filter(func(c): return not c.text.begins_with("tag: "))

func interaction_choices() -> Array:
	return current_choices.filter(func(c): return c.text.begins_with("tag: "))

func current_protagonists() -> Array:
	var result = []
	for item in current_lines:
		if item is Dialog:
			result.append(item.char_name)
	return result

func continue_story():
	if story.can_continue:
		print("Continuing story")
		current_lines.clear()
		current_choices.clear()
		current_line_pointer = 0
		current_display_time = 0
		current_displayed_text = ""
		var raw_lines = story.continue_story_maximally().split("\n")
		print(raw_lines)
		for line in raw_lines:
			line = line.strip_edges()
			if line == "":
				continue
			if is_code(line):
				print(line, " is ", "Code")
				current_lines.append(Code.new(line))
			elif is_dialog(line):
				print(line, " is ", "Dialog")
				var match = dialog_regex.search(line)
				var character_name = match.get_string(1)
				var dialog_text = match.get_string(2)
				current_lines.append(Dialog.new(character_name, dialog_text))
			else:
				print(line, " is ", "JustText")
				current_lines.append(Text.new(line))
		current_choices = story.current_choices if story.current_choices.size() > 0 else []

func text_length(text : String) -> int:
	var t = text_regex.sub(text, "", true)
	return text_regex.sub(text, "", true).length()

func advance(delta : float) -> bool:
	var line = current_line()
	if line is Text:
		var base_text = ""
		for i in range(current_line_pointer):
			var l = current_lines[i]
			if l is Text:
				base_text += l.content + "\n"
		current_display_time += delta
		var total_time = float(text_length(line.content)) / SPEED
		var advance_at = int(ceil(line.content.length() * (current_display_time / total_time)))
		advance_at = clamp(advance_at, 0, line.content.length())
		current_displayed_text = base_text.strip_edges() + ( "\n" if base_text != "" else "") + line.content.substr(0, advance_at)
		return current_display_time <= total_time
	elif line is Dialog:
		var dialog_text = line.content
		current_display_time += delta
		var total_time = float(text_length(dialog_text)) / SPEED
		var advance_at = int(ceil(dialog_text.length() * (current_display_time / total_time)))
		advance_at = clamp(advance_at, 0, dialog_text.length())
		current_displayed_text = dialog_text.substr(0, advance_at)
		return current_display_time <= total_time
	return false

func next_line() -> bool:
	if current_line_pointer < current_lines.size():
		current_line_pointer += 1
		current_display_time = 0
	return current_line_pointer < current_lines.size()

func skip():
	var line = current_line()
	if line is Text:
		var base_text = ""
		for i in range(current_line_pointer):
			var l = current_lines[i]
			if l is Text:
				base_text += l.content + "\n"
		current_displayed_text = base_text.strip_edges() + ("\n" if base_text != "" else "") + line.content
	elif line is Dialog:
		current_displayed_text = line.content

func ready_for_choices() -> bool:
	return current_line_pointer == current_lines.size() and current_choices.size() > 0

func game_has_ended() -> bool:
	return not story.can_continue and current_lines.size() == 0 and current_choices.size() == 0

func choose_choice_index(choice_index : int):
	story.choose_choice_index(choice_index)
