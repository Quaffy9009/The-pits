extends Node2D


#POSITION VARIABLES
var last_position = Vector2(0,0)

#MAIN VARIABLES
var is_stoped = true
var cur_room = 1
var respawn = false
var direction
var is_on_floor
#PLAYER DAMAGE VARIABLES
var health = 7

#SHELL AMOUNT VARIUABLES
var add_cur_game_sa = false
var shell_amount = 0

#SOUNDS
var play_wall_hit_sound = false
var play_enemy_hit_sound = false
var play_shell_sound = false

func damage(ammount):
	if is_stoped:
		health -= ammount
		get_node("Invincibility timer").start()
		is_stoped = false


func _on_Invincibility_timer_timeout():
	is_stoped = true


