extends Node2D

## VALORES A CAMBIAR POR CADA NIVEL ################################################################
export(String) var CURRENT_WORD = "SANTI"
const CURRENT_WORD_ARRAY = {"S": 1, "A": 1, "N": 1, "T": 1, "I": 1}
const CURRENT_WORD_POSITIONS = {"0": "S", "1": "A", "2": "N", "3": "T", "4": "I"}
export(int) var LETTER_COUNT = 5 #COMENZANDO DESDE EL 1
export(int) var ROWS = 6
var NextLevel = preload("res://Scenes/Nivel3.tscn")
####################################################################################################

var blankLetterContainer = preload("res://Letras/CuadroVacio_transparente.png")
var LetterScene = preload("res://Scenes/Letter.tscn")
var WinMessageScene = preload("res://Scenes/WinMessage.tscn")

var teclas1 =  {"0": "Q", "1": "W","2": "E","3": "R","4": "T",
				"5": "Y","6": "U","7": "I","8": "O","9": "P"}
var teclas2 =  {"0": "A","1": "S","2": "D","3": "F","4": "G",
				"5": "H","6": "J","7": "K","8": "L","9": "Ñ"}
var teclas3 =  {"0": "Enter","1": "Z","2": "X","3": "C","4": "V",
				"5": "B","6": "N","7": "M","8": "Del"}


#$$$$$$$$ VARIABLES DE POSICION DEL "CURSOR" (EN QUE CUADRADO SE ESTÁ ACTUALMENTE) $$$$$$$$$$$$$$$$$
var current_col = 0 #Se actualiza cuando se escribe o borra una letra o se cambia de fila
var current_row = 0 #La fila sólo se cambia cuando se envía una palabra válida
var nodoColumActual
#var nodoColumSiguiente
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


var boxWidth = 640 / LETTER_COUNT
var boxHeight = boxWidth
var tempWordArray
var isErrorActive : bool = false
var GAME_WON : bool = false
var TEMP_WORD_ARRAY
var palabrasFiltradas
var arrayEstados = []

func _ready():
	#Creación de las filas del juego
	for i in ROWS:
		var row = HBoxContainer.new()
		var rowWidth = $Main/HCenterContainer/CenterContent/RowsContainer.rect_size.x
		row.alignment = BoxContainer.ALIGN_CENTER
		row.rect_min_size = Vector2(426,50)
		#Creación de cada CAJA de Caracteres (Escena de Letter.tscn)
		for x in LETTER_COUNT:
			var letter = LetterScene.instance()
			letter.CURRENT_STATE = "White"
			letter.CURRENT_LETTER = "NULL"
			row.add_child(letter, true)
		row.rect_size.y = rowWidth / LETTER_COUNT
		$Main/HCenterContainer/CenterContent/RowsContainer.add_child(row, true)
	
	#Creación del teclado virtual
	var teclado = VBoxContainer.new()
	teclado.name = "Teclado"
	teclado.alignment = BoxContainer.ALIGN_END
	teclado.rect_min_size = Vector2($Main/HCenterContainer/CenterContent.rect_size.x , 150)
	teclado.rect_size = Vector2($Main/HCenterContainer/CenterContent.rect_size.x, 150)
	for i in 3:
		var tecladoRow = HBoxContainer.new()
		tecladoRow.alignment = BoxContainer.ALIGN_CENTER
		var rowWidth = teclado.rect_size.x
		var rowHeight = teclado.rect_size.y / 3
		match i:
			0:
				for x in teclas1:
					var tecla = TextureButton.new()
					tecla.texture_normal = load("res://Letras/tecla_" + teclas1[x] + ".png")
					tecla.expand = true
					tecla.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
					tecla.rect_min_size = Vector2(rowWidth / 10, rowHeight)
					tecla.rect_size = Vector2(rowWidth / 10, rowHeight)
					tecladoRow.add_child(tecla, true)
			1:
				for x in teclas2:
					var tecla = TextureButton.new()
#					tecla.texture_normal = LETTER_TEXTURES_2[teclas2[x]][0]
					tecla.texture_normal = load("res://Letras/tecla_" + teclas2[x] + ".png")
					tecla.expand = true
					tecla.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
					tecla.rect_min_size = Vector2(rowWidth / 10, rowHeight)
					tecla.rect_size = Vector2(rowWidth / 10, rowHeight)
					tecladoRow.add_child(tecla, true)
			2:
				for x in teclas3:
					var tecla = TextureButton.new()
#					tecla.texture_normal = LETTER_TEXTURES_3[teclas3[x]][0]
					tecla.texture_normal = load("res://Letras/tecla_" + teclas3[x] + ".png")
					tecla.expand = true
					tecla.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
					if teclas3[x] == "Enter" or teclas3[x] == "Del":
						tecla.rect_min_size = Vector2(rowWidth / 6.6, rowHeight)
						tecla.rect_size = Vector2(rowWidth / 6.6, rowHeight)
					else:
						tecla.rect_min_size = Vector2(rowWidth / 9.7, rowHeight)
						tecla.rect_size = Vector2(rowWidth / 9.7, rowHeight)
					tecladoRow.add_child(tecla, true)
		teclado.add_child(tecladoRow, true)
	$Main/HCenterContainer/CenterContent.add_child(teclado)
	
	#Antes de terminar el setup, busco el nodo de la fila y columna actual
	FindCurrentColNode()
	
	#PALABRAS FILTRADAAAAAAAAAAAAAAHHHHHH!
	palabrasFiltradas = []
	for x in PalabrasValidas.Palabras:
		if x.length() == LETTER_COUNT:
			palabrasFiltradas.append(x)
	
	for x in LETTER_COUNT:
		arrayEstados.append("Grey")

func _process(_delta):
	$Main/HCenterContainer/MarginContainer/CurrentCol.text = "COL: " + String(current_col) + "\n" + "ROW: " + String(current_row)
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
			#END if item match word
		#END if item.length()
	#END for palabrasFiltradas
	
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
	
	print(arrayEstados)
#END funcion

func ShowWinMessage():
	var WinMessage = WinMessageScene.instance()
	var posX = get_viewport().get_visible_rect().size.x / 2
	var posY = get_viewport().get_visible_rect().size.y / 2
	WinMessage.position = Vector2(posX, posY)
	WinMessage.connect("SiguienPalabraPressed", self, "_on_WinMessage_SiguientePalabraPressed")
	
	WinMessage.ChangeWinningWord(CURRENT_WORD)
	
	self.add_child(WinMessage)
	yield(get_tree().create_timer(1), "timeout")
	get_tree().paused = true


# ........................................ INPUTS ..... ...........................................................#
# INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS INPUTS 
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
					x += 1
				#END for letras in filaActual
				
				if submitedWord == CURRENT_WORD:
					print("YOU WIN!!!!")
					GAME_WON = true
					ShowWinMessage()
					return
				
				#AL FINAL - CAMBIAR DE FILA
				current_col = 0
				current_row += 1
				if current_row == ROWS:
					print("YOU'RE OUT OF GUESSES :(")
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
	
	if current_row <= ROWS - 1 and current_col <= LETTER_COUNT - 1:# and nodoColumActual.CURRENT_LETTER == "NULL" and GAME_WON == false:
		
		if event.is_action_pressed("A"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "A"
		
		if event.is_action_pressed("B"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "B"
		
		if event.is_action_pressed("C"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "C"
		
		if event.is_action_pressed("D"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "D"
		
		if event.is_action_pressed("E"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "E"
		
		if event.is_action_pressed("F"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "F"
		
		if event.is_action_pressed("G"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "G"
		
		if event.is_action_pressed("H"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "H"
		
		if event.is_action_pressed("I"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "I"
		
		if event.is_action_pressed("J"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "J"
		
		if event.is_action_pressed("K"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "K"
		
		if event.is_action_pressed("L"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "L"
		
		if event.is_action_pressed("M"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "M"
		
		if event.is_action_pressed("N"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "N"
		
		if event.is_action_pressed("Ñ"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "Ñ"
		
		if event.is_action_pressed("O"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "O"
		
		if event.is_action_pressed("P"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "P"
		
		if event.is_action_pressed("Q"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "Q"
		
		if event.is_action_pressed("R"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "R"
		
		if event.is_action_pressed("S"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "S"
		
		if event.is_action_pressed("T"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "T"
		
		if event.is_action_pressed("U"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "U"
		
		if event.is_action_pressed("V"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "V"
		
		if event.is_action_pressed("W"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "W"
		
		if event.is_action_pressed("X"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "X"
		
		if event.is_action_pressed("Y"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "Y"
		
		if event.is_action_pressed("Z"):
			current_col += 1
			nodoColumActual.CURRENT_LETTER = "Z"
		
		if event.is_action_pressed("LetterKey"):
			nodoColumActual.updateLetter()
		
		#Luego de cambiar de Columna, chequeo que no se haya pasado de INDEX
		if current_col > LETTER_COUNT:
			current_col = LETTER_COUNT


func _on_ErrorAnimationPlayer_animation_finished(anim_name):
	if anim_name == "Error" or anim_name == "FadeOut":
		isErrorActive = false
	elif anim_name == "ERRORR":
		$Main/HCenterContainer/HBoxContainer/ErrorAnimationPlayer.play("FadeOut")

func _on_WinMessage_SiguientePalabraPressed():
	var response = get_tree().change_scene_to(NextLevel)
	if response == ERR_CANT_CREATE:
		print("Unable to change to " + String(NextLevel) + ", check Nivel2 '_on_WinMessage_SiguientePalabraPressed()'")
