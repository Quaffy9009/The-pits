extends StaticBody2D

onready var shelldrop = $ShellDrop
onready var SHELL_SCENE = preload("res://scenes/other/objects/Shell.tscn")
var health = 2


func _ready():
	randomize()
func _on_PlayerDetector_body_entered(body):
	Global.ge1_damage = true
func _on_BulletDetector_area_entered(area):
	Global.play_enemy_hit_sound = true
	if health > 0:
		health -= 1
	else:
		die()
func _on_PlayerSquashDetector_body_entered(body):
	Global.ge2_damage = true
func die():
	var shell_drop_amount = (randi() % 5) 
	while shell_drop_amount > 0:
		var new_shell = SHELL_SCENE.instance()
		new_shell.position = shelldrop.global_position
		get_tree().current_scene.add_child(new_shell)
		shell_drop_amount -= 1
	if shell_drop_amount == 0:
		queue_free()
