extends Sprite

signal SiguienPalabraPressed

func _input(event):
	if event.is_action_pressed("ENTER") or event.is_action_pressed("ESPACIO"):
		EmitButtonPressed()

func ChangeWinningWord(word):
	$CorrectWordNode.text = word.to_upper()

func _on_SiguientePalabraButton_pressed():
#	emit_signal("SiguienPalabraPressed")  --Se comentó para usar la función proxy EmitButtonPressed()
	EmitButtonPressed()
	pass

#Se creó esta función para hacer un proxy de funciones --Si se emite la señal 
#directamente cambiar de palabra no funciona correctamente
func EmitButtonPressed():
	emit_signal("SiguienPalabraPressed")
	pass


func SetDescriptionLabelTo(desc):
	$DescriptionNode.text = desc
