extends TextureButton

export(int) var LevelNumber = 1
export(bool) var Bloqueado = true

func _process(_delta):
	$Label.text = String(LevelNumber)
	if Bloqueado:
		$Sprite.visible = true
	else:
		$Sprite.visible = false
