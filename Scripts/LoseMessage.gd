extends Sprite

signal ReiniciarPressed
var ListaDeMensajes : Array = ["Vamos, vos podés", "Seguí intentando, creo en vos", "No te rindas", "Intentalo de nuevo, vos podés", "Bueno, a ver, tampoco era tan difícil", "Las letras en gris no están en la palabra, vamos de nuevo", "Esa palabra no era, intentá otra", "La próxima la sacás", "Pensé que la ibas a sacar fácil a esta", "Probá de nuevo, pero esta vez intentá de verdad :)", "Si ves este mensaje es porque perdiste"]

func _ready():
	var numero : int = randi() % ListaDeMensajes.size()
	$Label1.text = ListaDeMensajes[numero]
	print(String(numero) + ":  " + ListaDeMensajes[numero])

func _input(event):
	if event.is_action_pressed("ENTER") or event.is_action_pressed("ESPACIO"):
		_on_SiguientePalabraButton_pressed()


func _on_SiguientePalabraButton_pressed():
	emit_signal("ReiniciarPressed")
