extends Node2D

@onready var player = $Player

func _on_control_box_change_body_entered(body):
	player.set_script(load("res://Characters/playerRhythm.gd"))
