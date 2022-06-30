extends TextureButton

signal teclaPressed(LETTER)
signal DelPressed
signal EnterPressed

var LETTER : String


func _on_Tecla_pressed():
	if LETTER != "Del" and LETTER != "Enter":
		emit_signal("teclaPressed", LETTER)
	else:
		if LETTER == "Del":
			emit_signal("DelPressed")
		elif LETTER == "Enter":
			emit_signal("EnterPressed")
