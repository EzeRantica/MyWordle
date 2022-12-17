extends Node2D

func _ready() -> void:
	$Main/StartGame.connect("pressed", self, "_on_StartGame_pressed")
	$Main/SelectLevel.connect("pressed", self, "_on_SelectLevel_pressed")
	$Main/Options.connect("pressed", self, "_on_Options_pressed")
	
	####### CONEXIÓN CON LOS BOTONES DE NIVELES
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/Nivel1-Button".connect("pressed", self, "Nivel1Pressed")
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/Nivel2-Button".connect("pressed", self, "Nivel2Pressed")
	pass


func _on_StartGame_pressed() -> void:
	var _change = get_tree().change_scene("res://Scenes/Nivel1.tscn")


func _on_SelectLevel_pressed() -> void:
	MoveToSelectLevel()


func _on_Options_pressed() -> void:
	pass

func NivelPressed(year : int, month : int, day : int, level : String):
	var fechaActual = Time.get_date_string_from_system(false)
	print("Año = " + fechaActual.substr(0, 4) + " // Mes = " + fechaActual.substr(5, 2) + " // Día = " + fechaActual.substr(8, 2))
	
	if (fechaActual.substr(0, 4)).to_int() < year:
		return
	if (fechaActual.substr(5, 2)).to_int() < month:
		return
	if (fechaActual.substr(8, 2)).to_int() < day:
		return
	
	### Si pasa todos los bloqueos se cambia al nivel presionado
	var _change = get_tree().change_scene("res://Scripts/Nivel1.gd")
	
func MoveToSelectLevel():
	$AnimationPlayer.play("FromMainToSelectLevel")
	pass
