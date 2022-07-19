extends Sprite

signal ReiniciarPressed

func _input(event):
	if event.is_action_pressed("ENTER") or event.is_action_pressed("ESPACIO"):
		_on_SiguientePalabraButton_pressed()

func ChangeWinningWord(word):
	$CorrectWordNode.text = word.to_upper()

func _on_SiguientePalabraButton_pressed():
	emit_signal("ReiniciarPressed")
