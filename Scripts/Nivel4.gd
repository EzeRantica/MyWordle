extends Node2D

## VALORES A CAMBIAR POR CADA NIVEL ################################################################
export(String) var CURRENT_WORD = "PARQUE"
var CURRENT_WORD_ARRAY = {}
var CURRENT_WORD_POSITIONS = {}
var LETTER_COUNT : int
export(int) var ROWS = 6
var NextLevel = preload("res://Scenes/Nivel5.tscn")
####################################################################################################

var blankLetterContainer = preload("res://Letras/CuadroVacio_transparente.png")
var LetterScene = preload("res://Scenes/Letter.tscn")
var WinMessageScene = preload("res://Scenes/WinMessage.tscn")
var LoseMessage = preload("res://Scenes/LoseMessage.tscn")
var teclaScene = preload("res://Scenes/Tecla.tscn")

var teclas1 =  {"0": "Q", "1": "W","2": "E","3": "R","4": "T",
				"5": "Y","6": "U","7": "I","8": "O","9": "P"}
var teclas2 =  {"0": "A","1": "S","2": "D","3": "F","4": "G",
				"5": "H","6": "J","7": "K","8": "L","9": "Ñ"}
var teclas3 =  {"0": "Enter","1": "Z","2": "X","3": "C","4": "V",
				"5": "B","6": "N","7": "M","8": "Del"}
var row1
var row2
var row3


#$$$$$$$$ VARIABLES DE POSICION DEL "CURSOR" (EN QUE CUADRADO SE ESTÁ ACTUALMENTE) $$$$$$$$$$$$$$$$$
var current_col = 0 #Se actualiza cuando se escribe o borra una letra o se cambia de fila
var current_row = 0 #La fila sólo se cambia cuando se envía una palabra válida
var nodoColumActual
#var nodoColumSiguiente
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


var boxWidth 
var boxHeight
var tempWordArray
var isErrorActive : bool = false
var GAME_WON : bool = false
var TEMP_WORD_ARRAY
var palabrasFiltradas
var arrayEstados = []
onready var HealthTexture = $Main/HCenterContainer/VBoxContainer/HBoxContainer/HealthTexture

var arrayKeySounds = [load("res://Audio/mechanical_keyboard_1.wav"), 
					  load("res://Audio/mechanical_keyboard_2.wav"), 
					  load("res://Audio/mechanical_keyboard_3.wav"), 
					  load("res://Audio/mechanical_keyboard_4.wav"), 
					  load("res://Audio/mechanical_keyboard_5.wav"), 
					  load("res://Audio/mechanical_keyboard_6.wav"), 
					  load("res://Audio/mechanical_keyboard_7.wav"), 
					  load("res://Audio/mechanical_keyboard_8.wav")]

func SetupWordSettings():
	#Set LETTER_COUNT
	LETTER_COUNT = CURRENT_WORD.length()
	
	#Set CURRENT_WORD_ARRAY
	var letra : String
	var cantidadEnPalabra : int
	for i in LETTER_COUNT:
		letra = CURRENT_WORD.substr(i, 1)
		cantidadEnPalabra = CURRENT_WORD.count(letra)
		CURRENT_WORD_POSITIONS[String(i)] = letra
		if !CURRENT_WORD_ARRAY.has(letra):
			CURRENT_WORD_ARRAY[letra] = cantidadEnPalabra

func _ready():
	SetupWordSettings()
	
# warning-ignore:integer_division
	boxWidth = 640 / LETTER_COUNT
	boxHeight = boxWidth
	
	#Creación de las filas del juego
	for i in ROWS:
		var row = HBoxContainer.new()
		var rowWidth = $Main/HCenterContainer/CenterContent/RowsContainer.rect_size.x
		var rowHeight = ($Main/HCenterContainer/CenterContent/RowsContainer.rect_size.y / 6)
		row.alignment = BoxContainer.ALIGN_CENTER
		row.rect_min_size = Vector2(426,50)
		#Creación de cada CAJA de Caracteres (Escena de Letter.tscn)
		for x in LETTER_COUNT:
			var letter = LetterScene.instance()
			letter.CURRENT_STATE = "White"
			letter.CURRENT_LETTER = "NULL"
			row.add_child(letter, true)
		row.rect_min_size = Vector2(rowWidth, rowHeight)
		row.rect_size.y = rowHeight
		$Main/HCenterContainer/CenterContent/RowsContainer.add_child(row, true)
	
	#Creación del teclado virtual
	var tecladoContainer = VBoxContainer.new()
	tecladoContainer.name = "TecladoContainer"
	var teclado = VBoxContainer.new()
	teclado.name = "Teclado"
	teclado.alignment = BoxContainer.ALIGN_END
	tecladoContainer.alignment = BoxContainer.ALIGN_END
	
	teclado.rect_min_size = Vector2($Main/HCenterContainer/CenterContent.rect_size.x , 150)
	teclado.rect_size = Vector2($Main/HCenterContainer/CenterContent.rect_size.x, 150)
	
	tecladoContainer.rect_min_size = Vector2($Main/HCenterContainer/CenterContent.rect_size.x , 215)
	tecladoContainer.rect_size = Vector2($Main/HCenterContainer/CenterContent.rect_size.x, 215)
	for i in 3:
		var tecladoRow = HBoxContainer.new()
		tecladoRow.alignment = BoxContainer.ALIGN_CENTER
		var rowWidth = teclado.rect_size.x
		var rowHeight = teclado.rect_size.y / 3
		match i:
			0:
				for x in teclas1:
					var tecla = teclaScene.instance()
#					tecla.texture_normal = load("res://Letras/tecla_" + teclas1[x] + ".png")
					tecla.texture_normal = load("res://Letras/blank_letter_box.png")
					tecla.name = teclas1[x]
					tecla.SetLetter(teclas1[x])
					tecla.expand = true
					tecla.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
					tecla.rect_min_size = Vector2(rowWidth / 10, rowHeight)
					tecla.rect_size = Vector2(rowWidth / 10, rowHeight)
					tecla.connect("teclaPressed", self, "letter_button_pressed")
					tecla.connect("DelPressed", self, "Del_button_pressed")
					tecla.connect("EnterPressed", self, "Enter_button_pressed")
					tecladoRow.add_child(tecla, true)
					row1 = tecladoRow
			1:
				for x in teclas2:
					var tecla = teclaScene.instance()
#					tecla.texture_normal = load("res://Letras/tecla_" + teclas2[x] + ".png")
					tecla.texture_normal = load("res://Letras/blank_letter_box.png")
					tecla.name = teclas2[x]
					tecla.SetLetter(teclas2[x])
					tecla.expand = true
					tecla.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
					tecla.rect_min_size = Vector2(rowWidth / 10, rowHeight)
					tecla.rect_size = Vector2(rowWidth / 10, rowHeight)
					tecla.connect("teclaPressed", self, "letter_button_pressed")
					tecla.connect("DelPressed", self, "Del_button_pressed")
					tecla.connect("EnterPressed", self, "Enter_button_pressed")
					tecladoRow.add_child(tecla, true)
					row2 = tecladoRow
			2:
				for x in teclas3:
					var tecla = teclaScene.instance()
#					tecla.texture_normal = load("res://Letras/tecla_" + teclas3[x] + ".png")
					tecla.texture_normal = load("res://Letras/blank_letter_box.png")
					tecla.name = teclas3[x]
					tecla.SetLetter(teclas3[x])
					tecla.expand = true
					tecla.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
					if teclas3[x] == "Enter" or teclas3[x] == "Del":
						tecla.rect_min_size = Vector2(rowWidth / 6.6, rowHeight)
						tecla.rect_size = Vector2(rowWidth / 6.6, rowHeight)
						tecla.stretch_mode = TextureButton.STRETCH_SCALE
					else:
						tecla.rect_min_size = Vector2(rowWidth / 9.7, rowHeight)
						tecla.rect_size = Vector2(rowWidth / 9.7, rowHeight)
					tecla.connect("teclaPressed", self, "letter_button_pressed")
					tecla.connect("DelPressed", self, "Del_button_pressed")
					tecla.connect("EnterPressed", self, "Enter_button_pressed")
					tecladoRow.add_child(tecla, true)
					row3 = tecladoRow
			
		teclado.add_child(tecladoRow, true)
	tecladoContainer.add_child(teclado, true)
	$Main/HCenterContainer/CenterContent.add_child(tecladoContainer)
	
	#Antes de terminar el setup, busco el nodo de la fila y columna actual
#	FindCurrentColNode()
	
	#PALABRAS FILTRADAAAAAAAAAAAAAAHHHHHH!
	palabrasFiltradas = []
	for x in PalabrasValidas.Palabras:
		if x.length() == LETTER_COUNT or x.length() == LETTER_COUNT - 1:
			palabrasFiltradas.append(x)
	
	for x in LETTER_COUNT:
		arrayEstados.append("Grey")
	
	
	HealthManager.ResetHealth()
	var _conn = HealthManager.connect("HealthUpdated", self, "updateHealthTexture")
	var _conn2 = HealthManager.connect("HealthEmpty", self, "HealthEmpty")

func _process(_delta):
	$Main/HCenterContainer/VBoxContainer/CurrentCol.text = "COL: " + String(current_col) + "\n" + "ROW: " + String(current_row)
	FindCurrentColNode()

func FindCurrentColNode():
	if current_row < ROWS:
		var strNodoFilaActual = "Main/HCenterContainer/CenterContent/RowsContainer/HBoxContainer"
		if current_row > 0:
			strNodoFilaActual += String(current_row + 1)
		var _nodoFilaActual = get_node(strNodoFilaActual)
		
		var strNodoColumActual = strNodoFilaActual + "/Letra"
		if current_col > 0 and current_col <= LETTER_COUNT - 1:
			strNodoColumActual += String(current_col + 1)
		nodoColumActual = get_node(strNodoColumActual)


func FindColumNode(letterNumber : int):
	var strNodoFilaActual = "Main/HCenterContainer/CenterContent/RowsContainer/HBoxContainer"
	if current_row > 0:
		strNodoFilaActual += String(current_row + 1)
#	var nodoFilaActual = get_node(strNodoFilaActual)

	var strNodoColumActual = strNodoFilaActual + "/Letra"
	if letterNumber > 0:
		strNodoColumActual += String(letterNumber + 1)
	
	return get_node(strNodoColumActual)

func VerificarPalabraExistente(word) -> bool:
	for item in palabrasFiltradas:
		if item.length() == LETTER_COUNT:
			if item.to_upper().match(word.to_upper()):
				return true
			else:
				if item.to_upper().substr(item.length() - 1, 1) == "A" or item.to_upper().substr(item.length() - 1, 1) == "E" or item.to_upper().substr(item.length() - 1, 1) == "I" or item.to_upper().substr(item.length() - 1, 1) == "O" or item.to_upper().substr(item.length() - 1, 1) == "U":
					var itemS = item.to_upper() + "S"
					if itemS.to_upper().match(word.to_upper()):
						return true
			#END if item match word
		#END if item.length()
	#END for palabrasFiltradas
	
	for item in palabrasFiltradas:
		#Termina con VOCAL
		if item.to_upper().substr(item.length() - 1, 1) == "A" or item.to_upper().substr(item.length() - 1, 1) == "E" or item.to_upper().substr(item.length() - 1, 1) == "I" or item.to_upper().substr(item.length() - 1, 1) == "O" or item.to_upper().substr(item.length() - 1, 1) == "U":
			if item.length() == LETTER_COUNT - 1:
				var itemS = item.to_upper() + "S"
				if itemS.to_upper().match(word.to_upper()):
					return true
		else: #No termina con VOCAL
			if item.length() == LETTER_COUNT:
				if item.to_upper().match(word.to_upper()):
					return true
	if !isErrorActive:
		$Main/HCenterContainer/HBoxContainer/ErrorAnimationPlayer.play("Error")
		isErrorActive = true
	else:
		$Main/HCenterContainer/HBoxContainer/ErrorAnimationPlayer.play("ERRORR")
		isErrorActive = true
	#END if isErrorActive
	
	return false
#END VerificarPalabraExistente()

func CalcularEstados(palabra):
	var LetraIndex : int
	
	var filas = $Main/HCenterContainer/CenterContent/RowsContainer.get_children()
	var filaActual = filas[current_row].get_children()
	
	#PRIMER BUCLE - SOLO SE REVISAN LETRAS VERDES
	LetraIndex = 0
	for nodo in filaActual:
		var letra = nodo.CURRENT_LETTER
		
		if palabra.has(letra):
			if CURRENT_WORD_POSITIONS[String(LetraIndex)] == letra:
				arrayEstados[LetraIndex] = "Green"
				palabra[letra] -= 1
			#END if posicion
		#END if letra existe en palabra
		LetraIndex += 1
	#END for NODO in FILA ACTUAL
	
	#SEGUNDO BUBLE - SE REVISAN LETRAS AMARILLAS - LAS QUE NO SE CONVIERTEN EN AMARILLO QUEDAN GRISES
	LetraIndex = 0
	for x in filaActual:
		var letra = x.CURRENT_LETTER
		
		if palabra.has(letra):
			if palabra[letra] > 0 and CURRENT_WORD_POSITIONS[String(LetraIndex)] != letra:
				arrayEstados[LetraIndex] = "Yellow"
				palabra[letra] -= 1
		
		LetraIndex += 1
	#END for NODO IN FILA ACTUAL
#END funcion

func ShowWinMessage():
	var WinMessage = WinMessageScene.instance()
	var posX = get_viewport().get_visible_rect().size.x / 6
	var posY = get_viewport().get_visible_rect().size.y / 2
	WinMessage.position = Vector2(posX, posY)
	WinMessage.connect("SiguienPalabraPressed", self, "_on_WinMessage_SiguientePalabraPressed")
	
	WinMessage.ChangeWinningWord(CURRENT_WORD)
	WinMessage.SetDescriptionLabelTo("Después del primer encuentro, pensar en el parque\nme pone contento, pero de forma diferente\na como era antes")
	
	yield(get_tree().create_timer(1), "timeout")
	self.add_child(WinMessage)
	get_tree().paused = true


func SetEstadoTecla(colorEstado, letraTecla):
	match letraTecla:
		"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P":
			var teclaSel = row1.get_node(String(letraTecla))
			if teclaSel.has_method("SetColor") and ValidarCambio(teclaSel, colorEstado):
				teclaSel.SetColor(colorEstado)
		"A", "S", "D", "F", "G", "H", "J", "K", "L", "Ñ":
			var teclaSel = row2.get_node(String(letraTecla))
			if teclaSel.has_method("SetColor") and ValidarCambio(teclaSel, colorEstado):
				teclaSel.SetColor(colorEstado)
		"Z", "X", "C", "V", "B", "N", "M":
			var teclaSel = row3.get_node(String(letraTecla))
			if teclaSel.has_method("SetColor") and ValidarCambio(teclaSel, colorEstado):
				teclaSel.SetColor(colorEstado)


func ValidarCambio(nodoTecla, colorEstado) -> bool:
	var boolResultado : bool = false
	
	match colorEstado:
		"Blank":
			boolResultado = true
		"Grey":
			if nodoTecla.CURRENT_STATE == "Blank":
				boolResultado = true
		"Yellow":
			if nodoTecla.CURRENT_STATE == "Blank" or nodoTecla.CURRENT_STATE == "Grey":
				boolResultado = true
		"Green":
			if nodoTecla.CURRENT_STATE == "Blank" or nodoTecla.CURRENT_STATE == "Grey" or nodoTecla.CURRENT_STATE == "Yellow":
				boolResultado = true
	
	return boolResultado




# ........................................ INPUTS ..... ...........................................................#
# INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS  #
#..................................................................................................................#


func _input(event):
	if event.is_action_pressed("ENTER"):
		if GAME_WON:
			return
			
		if current_col == LETTER_COUNT:
			#SE COMPARAN BUSCA LA PALABRA EN LA LISTA DE PALABRAS VÁLIDAS
			var submitedWord = ""
			
			for letterIndex in LETTER_COUNT:
				var letterNode = FindColumNode(letterIndex)
				var character = letterNode.CURRENT_LETTER
				submitedWord += String(character)
			#END for LETTER COUNT
			
			if VerificarPalabraExistente(submitedWord): #SI LA PALABRA NO ESTÁ EN LA LISTA DE EXISTENTES NO SE SIGUE
				#VERIFICAR ESTADOS DE TODAS LAS LETRAS
				#PRIMERO RESETEO EL ARRAY PARA QUE TODAS QUEDEN GRISES
				arrayEstados = []
				for x in LETTER_COUNT:
					arrayEstados.append("Grey")
					
				#SEGUNDO RECALCULO LOS ESTADOS
				TEMP_WORD_ARRAY = CURRENT_WORD_ARRAY.duplicate()
				CalcularEstados(TEMP_WORD_ARRAY)
				
				#BUSCAR NODOS DE FILAS Y LETRAS
				var filas = $Main/HCenterContainer/CenterContent/RowsContainer.get_children()
				var filaActual = filas[current_row].get_children()
				
				#POR CADA LETRA, LE APLICO EL ESTADO CORRESPONDIENTE A SU POSICION Y LA ACTUALIZO
				var x = 0
				for letraActual in filaActual:
					letraActual.CURRENT_STATE = arrayEstados[x]
					letraActual.flipLetter()
					yield(get_tree().create_timer(0.2), "timeout")
					SetEstadoTecla(arrayEstados[x], letraActual.CURRENT_LETTER)
					x += 1
					
				#END for letras in filaActual
				
				if submitedWord == CURRENT_WORD:
					GAME_WON = true
					ShowWinMessage()
					return
				
				#AL FINAL - CAMBIAR DE FILA
				current_col = 0
				current_row += 1
				if current_row == ROWS:
					HealthManager.TakeHit()
					ResetLevel()
				#END if row == ROWS
			#END if VerificarPalabraExistente()
		#END if col == LETTER COUNT
	#END if ENTER pressed
	
	if event.is_action_pressed("DELETE"):
		if GAME_WON:
			return
		
		if current_row <= ROWS - 1:
			current_col -= 1
			if current_col < 0:
				current_col = 0
			FindCurrentColNode()
			nodoColumActual.CURRENT_LETTER = "NULL"
			
			var y : int = randi() % 3
			match y:
				0:
					play_sound($Main/SFXPlayer_Delete, load("res://Audio/mechanical_keyboard_1.wav"))
				1:
					play_sound($Main/SFXPlayer_Delete, load("res://Audio/mechanical_keyboard_5.wav"))
				2:
					play_sound($Main/SFXPlayer_Delete, load("res://Audio/mechanical_keyboard_6.wav"))
	
	
	if current_row <= ROWS - 1 and current_col <= LETTER_COUNT - 1:
		if event.is_action_pressed("A"):
			TypeLetter("A", nodoColumActual)
		
		if event.is_action_pressed("B"):
			TypeLetter("B", nodoColumActual)
		
		if event.is_action_pressed("C"):
			TypeLetter("C", nodoColumActual)
		
		if event.is_action_pressed("D"):
			TypeLetter("D", nodoColumActual)
		
		if event.is_action_pressed("E"):
			TypeLetter("E", nodoColumActual)
		
		if event.is_action_pressed("F"):
			TypeLetter("F", nodoColumActual)
		
		if event.is_action_pressed("G"):
			TypeLetter("G", nodoColumActual)
		
		if event.is_action_pressed("H"):
			TypeLetter("H", nodoColumActual)
		
		if event.is_action_pressed("I"):
			TypeLetter("I", nodoColumActual)
		
		if event.is_action_pressed("J"):
			TypeLetter("J", nodoColumActual)
		
		if event.is_action_pressed("K"):
			TypeLetter("K", nodoColumActual)
		
		if event.is_action_pressed("L"):
			TypeLetter("L", nodoColumActual)
		
		if event.is_action_pressed("M"):
			TypeLetter("M", nodoColumActual)
		
		if event.is_action_pressed("N"):
			TypeLetter("N", nodoColumActual)
		
		if event.is_action_pressed("Ñ"):
			TypeLetter("Ñ", nodoColumActual)
		
		if event.is_action_pressed("O"):
			TypeLetter("O", nodoColumActual)
		
		if event.is_action_pressed("P"):
			TypeLetter("P", nodoColumActual)
		
		if event.is_action_pressed("Q"):
			TypeLetter("Q", nodoColumActual)
		
		if event.is_action_pressed("R"):
			TypeLetter("R", nodoColumActual)
		
		if event.is_action_pressed("S"):
			TypeLetter("S", nodoColumActual)
		
		if event.is_action_pressed("T"):
			TypeLetter("T", nodoColumActual)
		
		if event.is_action_pressed("U"):
			TypeLetter("U", nodoColumActual)
		
		if event.is_action_pressed("V"):
			TypeLetter("V", nodoColumActual)
		
		if event.is_action_pressed("W"):
			TypeLetter("W", nodoColumActual)
		
		if event.is_action_pressed("X"):
			TypeLetter("X", nodoColumActual)
		
		if event.is_action_pressed("Y"):
			TypeLetter("Y", nodoColumActual)
		
		if event.is_action_pressed("Z"):
			TypeLetter("Z", nodoColumActual)
		
		if event.is_action_pressed("LetterKey"):
			nodoColumActual.updateLetter()
#			play_sound($Main/SFXPlayer, load("res://Audio/Laptop_Keystroke_82.wav"))
			playRandomKeySound($Main/SFXPlayer)
		
		#Luego de cambiar de Columna, chequeo que no se haya pasado de INDEX
		if current_col > LETTER_COUNT:
			current_col = LETTER_COUNT

func TypeLetter(letter : String, node):
	current_col += 1
	if current_col > LETTER_COUNT:
		current_col = LETTER_COUNT
	node.CURRENT_LETTER = letter


func letter_button_pressed(letter):
	if letter != "Del" and letter != "Enter":
		TypeLetter(letter, nodoColumActual)
		playRandomKeySound($Main/SFXPlayer)

func Del_button_pressed():
	if GAME_WON:
		return
	
	if current_row <= ROWS - 1:
		current_col -= 1
		if current_col < 0:
			current_col = 0
		FindCurrentColNode()
		nodoColumActual.CURRENT_LETTER = "NULL"
		
		var y : int = randi() % 3
		match y:
			0:
				play_sound($Main/SFXPlayer_Delete, load("res://Audio/mechanical_keyboard_1.wav"))
			1:
				play_sound($Main/SFXPlayer_Delete, load("res://Audio/mechanical_keyboard_5.wav"))
			2:
				play_sound($Main/SFXPlayer_Delete, load("res://Audio/mechanical_keyboard_6.wav"))


func Enter_button_pressed():
	if GAME_WON:
		return
		
	if current_col == LETTER_COUNT:
		#SE COMPARAN BUSCA LA PALABRA EN LA LISTA DE PALABRAS VÁLIDAS
		var submitedWord = ""
		
		for letterIndex in LETTER_COUNT:
			var letterNode = FindColumNode(letterIndex)
			var character = letterNode.CURRENT_LETTER
			submitedWord += String(character)
		#END for LETTER COUNT
		
		if VerificarPalabraExistente(submitedWord): #SI LA PALABRA NO ESTÁ EN LA LISTA DE EXISTENTES NO SE SIGUE
			#VERIFICAR ESTADOS DE TODAS LAS LETRAS
			#PRIMERO RESETEO EL ARRAY PARA QUE TODAS QUEDEN GRISES
			arrayEstados = []
			for x in LETTER_COUNT:
				arrayEstados.append("Grey")
				
			#SEGUNDO RECALCULO LOS ESTADOS
			TEMP_WORD_ARRAY = CURRENT_WORD_ARRAY.duplicate()
			CalcularEstados(TEMP_WORD_ARRAY)
			
			#BUSCAR NODOS DE FILAS Y LETRAS
			var filas = $Main/HCenterContainer/CenterContent/RowsContainer.get_children()
			var filaActual = filas[current_row].get_children()
			
			#POR CADA LETRA, LE APLICO EL ESTADO CORRESPONDIENTE A SU POSICION Y LA ACTUALIZO
			var x = 0
			for letraActual in filaActual:
				letraActual.CURRENT_STATE = arrayEstados[x]
				letraActual.flipLetter()
				yield(get_tree().create_timer(0.2), "timeout")
				x += 1
			#END for letras in filaActual
			
			if submitedWord == CURRENT_WORD:
				GAME_WON = true
				ShowWinMessage()
				return
			
			#AL FINAL - CAMBIAR DE FILA
			current_col = 0
			current_row += 1
			if current_row == ROWS:
				print("YOU'RE OUT OF GUESSES :(")
				HealthManager.TakeHit()
			#END if row == ROWS
		#END if VerificarPalabraExistente()
	#END if col == LETTER COUNT

func play_sound(player : AudioStreamPlayer, sfx : AudioStream):
	player.stream = sfx
	player.play()


func playRandomKeySound(player : AudioStreamPlayer):
	var x : int = randi() % 8
	player.stream = arrayKeySounds[x]
	player.play()


func updateHealthTexture():
	match HealthManager.CURRENT_HEALTH:
		0:
			HealthTexture.texture = load("res://UI/HealthMinus3.png")
		1:
			HealthTexture.texture = load("res://UI/HealthMinus2.png")
		2:
			HealthTexture.texture = load("res://UI/HealthMinus1.png")
		3:
			HealthTexture.texture = load("res://UI/HealthFull.png")
	
	play_sound($Main/SFXPlayer, load("res://Audio/oof.wav"))

func HealthEmpty():
	var LoseMessageInstance = LoseMessage.instance()
	var posX = get_viewport().get_visible_rect().size.x / 6
	var posY = get_viewport().get_visible_rect().size.y / 2
	LoseMessageInstance.position = Vector2(posX, posY)
	LoseMessageInstance.connect("ReiniciarPressed", self, "_on_LoseMessage_ReiniciarPressed")
	
	LoseMessageInstance.ChangeWinningWord(CURRENT_WORD)
	
	self.add_child(LoseMessageInstance)
	yield(get_tree().create_timer(1), "timeout")
	get_tree().paused = true

func _on_ErrorAnimationPlayer_animation_finished(anim_name):
	if anim_name == "Error" or anim_name == "FadeOut":
		isErrorActive = false
	elif anim_name == "ERRORR":
		$Main/HCenterContainer/HBoxContainer/ErrorAnimationPlayer.play("FadeOut")

func _on_WinMessage_SiguientePalabraPressed():
	ResetLevel()
	get_tree().paused = false
	var response = get_tree().change_scene_to(NextLevel)
	if response == ERR_CANT_CREATE:
		print("Unable to change to " + String(NextLevel) + ", check Nivel1 '_on_WinMessage_SiguientePalabraPressed()'")


func _on_LoseMessage_ReiniciarPressed():
	var _change = get_tree().change_scene("res://Scenes/Main.tscn")


func ResetLevel():
	var filas = $Main/HCenterContainer/CenterContent/RowsContainer.get_children()
	for x in 6:
		var filaActual = filas[x].get_children()
		for letraActual in filaActual:
			TypeLetter("NULL", letraActual)
			letraActual.CURRENT_STATE = "White"
			letraActual.flipLetter()
	
	current_col = 0
	current_row = 0








