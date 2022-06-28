extends Node2D

const MAX_HEALTH = 3
var CURRENT_HEALTH = 3
var HIT_AMOUNT = 1

signal HealthUpdated

func _ready():
	CURRENT_HEALTH = MAX_HEALTH


func TakeHit():
	CURRENT_HEALTH -= HIT_AMOUNT
	emit_signal("HealthUpdated")


func ResetHealth():
	CURRENT_HEALTH = MAX_HEALTH
