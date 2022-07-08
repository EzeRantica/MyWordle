extends TextureButton

export(String, "Blank", "Green", "Yellow", "Grey") var CURRENT_STATE : String

signal teclaPressed(LETTER)
signal DelPressed
signal EnterPressed

var LETTER : String

func _ready():
	$LetterLabel.rect_min_size = self.rect_size
	$LetterLabel.rect_size = self.rect_size
	CURRENT_STATE = "Blank"

func _on_Tecla_pressed():
	if LETTER != "Del" and LETTER != "Enter":
		emit_signal("teclaPressed", LETTER)
	else:
		if LETTER == "Del":
			emit_signal("DelPressed")
		elif LETTER == "Enter":
			emit_signal("EnterPressed")


func SetLetter(letter : String):
	$LetterLabel.text = letter
	LETTER = letter

func SetColor(color : String):
	match color:
		"Green":
			CURRENT_STATE = "Green"
			self.texture_normal = load("res://Letras/blank_letter_box_green.png")
		"Yellow":
			CURRENT_STATE = "Yellow"
			self.texture_normal = load("res://Letras/blank_letter_box_yellow.png")
		"Grey":
			CURRENT_STATE = "Grey"
			self.texture_normal = load("res://Letras/blank_letter_box_grey.png")
		_:
			CURRENT_STATE = "Blank"
			self.texture_normal = load("res://Letras/blank_letter_box.png")
