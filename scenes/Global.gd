extends Node2D


#POSITION VARIABLES
var last_position = Vector2(0,0)
var cur_camera_point_top #-1408
var cur_camera_point_bottom #576
var cur_camera_point_right #480
var cur_camera_point_left #-4160

#MAIN VARIABLES
var cur_gravity = 50
var cur_room = 1
var testing_camera = false
var respawn = false
var md = false
var direction
var is_on_floor
#PLAYER DAMAGE VARIABLES
var ge1_damage = false
var ge2_damage = false

#SHELL AMOUNT VARIUABLES
var add_cur_game_sa = false
var shell_amount = 0

#SOUNDS
var play_wall_hit_sound = false
var play_enemy_hit_sound = false
var play_shell_sound = false


