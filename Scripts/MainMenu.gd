extends Node2D

func _ready() -> void:
	$Main/StartGame.connect("pressed", self, "_on_StartGame_pressed")
	$Main/SelectLevel.connect("pressed", self, "_on_SelectLevel_pressed")
	$Main/Options.connect("pressed", self, "_on_Options_pressed")
	$Options/BackButton.connect("pressed", self, "_on_BackFromOptions_pressed")
	$SelectLevel/BackButton.connect("pressed", self, "_on_BackFromSelectLevel_pressed")
	
	####### CONEXIÓN CON LOS BOTONES DE NIVELES
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow1/Nivel1-Button".connect("pressed", self, "NivelPressed", [2022, 12, 20, "res://Scenes/Nivel1.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow1/Nivel2-Button".connect("pressed", self, "NivelPressed", [2023, 02, 02, "res://Scenes/Nivel2.tscn"])
	pass


func _on_StartGame_pressed() -> void:
	$AnimationPlayer.play("FromMainToStartGame")
	yield($AnimationPlayer, "animation_finished")
	var _change = get_tree().change_scene("res://Scenes/Nivel1.tscn")


func _on_SelectLevel_pressed() -> void:
	$AnimationPlayer.play("FromMainToSelectLevel")

func _on_Options_pressed() -> void:
	$AnimationPlayer.play("FromMainToOptions")

func _on_BackFromOptions_pressed() -> void:
	$AnimationPlayer.play("FromOptionsToMain")

func _on_BackFromSelectLevel_pressed() -> void:
	$AnimationPlayer.play("FromSelectLevelToMain")

func NivelPressed(year : int, month : int, day : int, level : String):
	var fechaActual = Time.get_date_string_from_system(false)
	print("Año = " + fechaActual.substr(0, 4) + " // Mes = " + fechaActual.substr(5, 2) + " // Día = " + fechaActual.substr(8, 2))
	
	if (fechaActual.substr(0, 4)).to_int() < year:
		print("No es " + String(year))
		return
	if (fechaActual.substr(5, 2)).to_int() < month:
		print("No es Febrero")
		return
	if (fechaActual.substr(8, 2)).to_int() < day:
		print("No es " + String(day) + " de Febrero")
		return
	
	### Si pasa todos los bloqueos se cambia al nivel presionado
	print("Changing scene to '" + level + "'")
	var _change = get_tree().change_scene(level)
