extends RichTextLabel

func _input(event):
	if event.is_action_pressed("DEBUG_WORD_GRID_POSITION"):
		visible = !visible
