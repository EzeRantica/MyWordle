extends Node2D

signal Closed

func _on_CloseButton_pressed():
	$AnimationPlayer.play("Close")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("Closed")
