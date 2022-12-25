extends Node2D

func _ready() -> void:
	$Main/StartGame.connect("pressed", self, "_on_StartGame_pressed")
	$Main/SelectLevel.connect("pressed", self, "_on_SelectLevel_pressed")
	$Main/Options.connect("pressed", self, "_on_Options_pressed")
	$Options/BackButton.connect("pressed", self, "_on_BackFromOptions_pressed")
	$SelectLevel/BackButton.connect("pressed", self, "_on_BackFromSelectLevel_pressed")
	
	####### CONEXIÓN CON LOS BOTONES DE NIVELES
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow1/Nivel1-Button".connect("pressed", self, "NivelPressed", [2023, 02, 01, "res://Scenes/Nivel1.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow1/Nivel2-Button".connect("pressed", self, "NivelPressed", [2023, 02, 02, "res://Scenes/Nivel2.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow1/Nivel3-Button".connect("pressed", self, "NivelPressed", [2023, 02, 03, "res://Scenes/Nivel3.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow1/Nivel4-Button".connect("pressed", self, "NivelPressed", [2023, 02, 04, "res://Scenes/Nivel4.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow2/Nivel5-Button".connect("pressed", self, "NivelPressed", [2023, 02, 05, "res://Scenes/Nivel5.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow2/Nivel6-Button".connect("pressed", self, "NivelPressed", [2023, 02, 06, "res://Scenes/Nivel6.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow2/Nivel7-Button".connect("pressed", self, "NivelPressed", [2023, 02, 07, "res://Scenes/Nivel7.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow2/Nivel8-Button".connect("pressed", self, "NivelPressed", [2023, 02, 08, "res://Scenes/Nivel8.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow3/Nivel9-Button".connect("pressed", self, "NivelPressed", [2023, 02, 09, "res://Scenes/Nivel9.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow3/Nivel10-Button".connect("pressed", self, "NivelPressed", [2023, 02, 10, "res://Scenes/Nivel10.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow3/Nivel11-Button".connect("pressed", self, "NivelPressed", [2023, 02, 11, "res://Scenes/Nivel11.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow3/Nivel12-Button".connect("pressed", self, "NivelPressed", [2023, 02, 12, "res://Scenes/Nivel1.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow4/Nivel13-Button".connect("pressed", self, "NivelPressed", [2023, 02, 13, "res://Scenes/Nivel1.tscn"])
	$"SelectLevel/CenterHorizontalLevels/CenterVerticalLevels/LevelsRow4/Nivel14-Button".connect("pressed", self, "NivelPressed", [2023, 02, 14, "res://Scenes/Nivel1.tscn"])
	pass

func _process(_delta):
	var niveles = get_tree().get_nodes_in_group("Level-Select-Button")
	var dia = 1
	for nivel in niveles:
		ChangeLockedState(dia, nivel)
		dia += 1

func ChangeLockedState(dia : int, nivel) -> void:
	var fechaActual = Time.get_date_string_from_system(false)
	
	if (fechaActual.substr(0, 4)).to_int() < 2023:
		nivel.Bloqueado = true
		return
	if (fechaActual.substr(5, 2)).to_int() < 02:
		nivel.Bloqueado = true
		return
	if (fechaActual.substr(8, 2)).to_int() < dia:
		nivel.Bloqueado = true
		return
	
	#Si pasa todas las validaciones de fecha, se cambia el estado a NO bloqueado
	nivel.Bloqueado = false

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
