extends Node2D

const MAX_HEALTH = 3
var CURRENT_HEALTH = 3
var HIT_AMOUNT = 1
var HealthTextureNode

signal HealthUpdated

func _ready():
	CURRENT_HEALTH = MAX_HEALTH
	
	HealthTextureNode = get_tree().get_nodes_in_group("healthTexture")


func TakeHit():
	CURRENT_HEALTH -= HIT_AMOUNT
	
	match CURRENT_HEALTH:
		"0":
			HealthTextureNode[0].texture = load("res://UI/HealthMinus3.png")
		"1":
			HealthTextureNode[0].texture = load("res://UI/HealthMinus2.png")
		"2":
			HealthTextureNode[0].texture = load("res://UI/HealthMinus1.png")
		"3":
			HealthTextureNode[0].texture = load("res://UI/HealthFull.png")


func ResetHealth():
	CURRENT_HEALTH = MAX_HEALTH
