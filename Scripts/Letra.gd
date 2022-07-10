extends CenterContainer

export(String, "NULL", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "Ñ", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z") var CURRENT_LETTER
export(String, "White", "Grey", "Yellow", "Green") var CURRENT_STATE
export(float) var Size = 80

func _process(_delta):
	$TextNode.text = CURRENT_LETTER
	
	if CURRENT_LETTER == "NULL":
		$TextNode.text = ""
	else:
		$TextNode.text = String(CURRENT_LETTER)

func SetSize(size):
	var value = size / 80
	$BackgroundNode.scale = Vector2(value, value)
	$BoxNode.scale = Vector2(value, value)

func updateLetter():
	$AnimationPlayer.play("UpdateLetter")

func flipLetter():
	$AnimationPlayer.play("FlipLetter1")
	yield($AnimationPlayer, "animation_finished")
	match CURRENT_STATE:
		"Grey":
			$BackgroundNode.texture = load("res://Letras/cuadro_fondo_gris2.png")
		"Yellow":
			$BackgroundNode.texture = load("res://Letras/cuadro_fondo_amarillo2.png")
		"Green":
			$BackgroundNode.texture = load("res://Letras/cuadro_fondo_verde2.png")
	$AnimationPlayer.play("FlipLetter2")
