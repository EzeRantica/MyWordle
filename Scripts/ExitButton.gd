extends TextureButton

func _ready() -> void:
	self.set_global_position(Vector2(390,20))
	pass


func _on_ExitButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
