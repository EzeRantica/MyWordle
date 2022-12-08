extends Node2D

func _ready():
	
	yield(get_tree().create_timer(3), "timeout")
	var _change = get_tree().change_scene("res://Scenes/Nivel1.tscn")
	pass
