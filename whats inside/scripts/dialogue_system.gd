extends CanvasLayer

@onready var EnterIndicator: Sprite2D = $Panel/EnterIndicator
@onready var DialogueNameLabel: RichTextLabel = $Panel/NameLabel
@onready var DialogueLabel: RichTextLabel = $Panel/TextLabel
@onready var DialoguePanel: Panel = $Panel

var dialogue: Array[DE]
var current_dialogue_item: int = 0
var next_item: bool = true

var player_node: CharacterBody2D

func _ready() -> void:
	visible = false
	for i in get_tree().get_nodes_in_group("player"):
		player_node = i

func _process(_delta: float) -> void:
	if current_dialogue_item == dialogue.size():
		if !player_node:
			for i in get_tree().get_nodes_in_group("player"):
				player_node = i
			return
		player_node.can_move = true
		queue_free()
		return
	
	if next_item:
		next_item = false
		var i = dialogue[current_dialogue_item]
		
		if i is DialogueFunction:
			if i.hide_dialogue_box:
				visible = false
			else:
				visible = true
			_function_resource(i)
		elif i is DialogueText:
			visible = true
			if (current_dialogue_item == 0):
				DialoguePanel.size.x = 0
				DialoguePanel.position.x = 160
				DialoguePanel.modulate.a = 0
				EnterIndicator.modulate.a = 0
				DialogueNameLabel.modulate.a = 0
				var tween = create_tween()
				tween.set_parallel()
				tween.tween_property(DialoguePanel, "modulate:a", 1, 0.25).set_trans(tween.TRANS_QUAD)
				tween.tween_property(DialoguePanel, "size", Vector2(254, 54), 0.25).set_trans(tween.TRANS_QUAD)
				tween.tween_property(DialoguePanel, "position", Vector2(33, 110), 0.25).set_trans(tween.TRANS_QUAD)
				tween.tween_callback(
				func _garava():
					print("ga- ga- garava")
					var garava_tween = create_tween()
					garava_tween.set_parallel()
					garava_tween.set_ease(Tween.EASE_IN)
					garava_tween.tween_property(EnterIndicator, "modulate:a", 1, 0.15)
					garava_tween.tween_property(DialogueNameLabel, "modulate:a", 1, 0.15)
					_text_resource(i)
				).set_delay(0.25)
			else:
				_text_resource(i)
		else:
			printerr("You accidentaly added a DE resource!")
			current_dialogue_item += 1
			next_item = true

func _function_resource(i: DialogueFunction) -> void:
	var target_node = get_node(i.target_path)
	if target_node.has_method(i.function_name):
		if i.function_arguments.size() == 0:
			target_node.call(i.function_name)
		else:
			target_node.callv(i.function_name, i.function_arguments)
	
	if i.wait_for_signal_to_continue:
		var signal_name = i.wait_for_signal_to_continue
		if target_node.has_signal(signal_name):
			var signal_state = { "done": false }
			var callable = func(_args): signal_state.done = true
			target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
			while not signal_state.done:
				await get_tree().process_frame
	
	current_dialogue_item += 1
	next_item = true

func _text_resource(i: DialogueText) -> void:
	$AudioStreamPlayer.stream = i.text_sound
	$AudioStreamPlayer.volume_db = i.text_volume_db
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera and i.camera_position != Vector2(999.9, 999.9):
		var camera_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
		camera_tween.tween_property(camera, "global_position", i.camera_position, i.camera_transition_time)
	
	DialogueLabel.visible_characters = 0
	DialogueLabel.text = i.text
	var text_without_square_brackets: String = _text_without_square_brackets(i.text)
	var total_characters: int = text_without_square_brackets.length()
	var character_timer: float = 0.0
	
	while DialogueLabel.visible_characters < total_characters:
		if Input.is_action_just_released("skip_text") and character_timer > 0:
			DialogueLabel.visible_characters = total_characters
			break
		
		character_timer += get_process_delta_time()
		if text_without_square_brackets[DialogueLabel.visible_characters - 1] == "," or text_without_square_brackets[DialogueLabel.visible_characters - 1] == "." or\
		text_without_square_brackets[DialogueLabel.visible_characters - 1] == "!" or text_without_square_brackets[DialogueLabel.visible_characters - 1] == "?":
			if character_timer >= (4.0 / i.text_speed):
				var character: String = text_without_square_brackets[DialogueLabel.visible_characters]
				DialogueLabel.visible_characters += 1
				if character != " ":
					$AudioStreamPlayer.pitch_scale = randf_range(i.text_volume_pitch_min, i.text_volume_pitch_max)
					$AudioStreamPlayer.play()
				character_timer = 0.0
		else:
			if character_timer >= (1.0 / i.text_speed) or text_without_square_brackets[DialogueLabel.visible_characters] == " ":
				var character: String = text_without_square_brackets[DialogueLabel.visible_characters]
				DialogueLabel.visible_characters += 1
				if character != " ":
					$AudioStreamPlayer.pitch_scale = randf_range(i.text_volume_pitch_min, i.text_volume_pitch_max)
					$AudioStreamPlayer.play()
				character_timer = 0.0
		
		await get_tree().process_frame
	
	while true:
		await get_tree().process_frame
		if DialogueLabel.visible_characters == total_characters:
			if Input.is_action_just_released("skip_text"):
				current_dialogue_item += 1
				next_item = true

func _text_without_square_brackets(text: String) -> String:
	var result: String = ""
	var inside_bracket: bool = false
	
	for i in text:
		if i == "[":
			inside_bracket = true
			continue
		
		if i == "]":
			inside_bracket = false
			continue
		
		if !inside_bracket:
			result += i
	
	return result
