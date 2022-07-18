extends Node2D

const MAX_HEALTH = 3
var CURRENT_HEALTH = 3
var HIT_AMOUNT = 1

signal HealthUpdated
signal HealthEmpty

func _ready():
	CURRENT_HEALTH = MAX_HEALTH


func TakeHit():
	CURRENT_HEALTH -= HIT_AMOUNT
	emit_signal("HealthUpdated")
	
	if CURRENT_HEALTH <= 0:
		emit_signal("HealthEmpty")


func ResetHealth():
	CURRENT_HEALTH = MAX_HEALTH
