extends KinematicBody2D

#HEALTH VARIABLES
var health = 7
var max_health = 6
var health_minus = 1

#SHELL/MONEY VARIABLES
export var shell_amount = 0
var cur_game_sa = 0

#GUN VARIABLES
var shootinga 
var shot = false
var shooting = false
var shoot_able = true
var ammo_amount = 2
var max_ammo_amount = 2
onready var gun_muzzle = $Muzzle
onready var BULLET_SCENE = preload("res://scenes/other/objects/Bullet.tscn")

#CURRENT STATE VARIABLES
var state_machine
var cur_direction  #1 = right/ 2 = left/ 3 = up/ 4 = down/
var current

#MOVEMENT VARIABLES
var move_able = true
var velocity = Vector2()
const SPEED = 65
var GRAVITY = 15
const JUMPFORCE = -225
const SHOOTFORCE = -260
const HITBACK = -40


func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
func _physics_process(delta):
	get_gravity()
	get_sound()
	get_shoot_input()
	get_input()
	get_health()
	shell_amount_func()
func get_gravity():
	GRAVITY = Global.cur_gravity
func get_input():
	#print(velocity.length())
	if $Sprite.scale.x == 4:
		Global.scale_x = 4
	elif $Sprite.scale.x == -4:
		Global.scale_x = -4
	current = state_machine.get_current_node()
	if Input.is_action_pressed("right") and move_able == true:
		$Sprite.scale.x = 1
		Global.scale_x = 4
		velocity.x = SPEED
	if Input.is_action_pressed("left") and move_able == true:
		$Sprite.scale.x = -1
		Global.scale_x = -4
		velocity.x = -SPEED
	if velocity.length() < 59 and is_on_floor() and Input.is_action_pressed("up"):
		state_machine.travel("OnGroundLookingUp")
	if Input.is_action_just_pressed("jump") and is_on_floor() and move_able == true:
		velocity.y = JUMPFORCE
		$Sounds/JumpSound.play()
	if velocity.length() <= 59:
		state_machine.travel("Idle")
	if velocity.length() > 59 and is_on_floor():
		state_machine.travel("Run")
	elif velocity.length() > 59 and is_on_floor() == false and Input.is_action_pressed("down"):
		state_machine.travel("LookingDown(OnlyInAir)")
		Global.scale_x = 0
	elif velocity.length() > 59 and is_on_floor() == false and Input.is_action_pressed("up"):
		state_machine.travel("FallLookingUp")
		Global.scale_x = 0
	elif velocity.length() > 59 and is_on_floor() == false:
		state_machine.travel("FallingNormal")
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.x = lerp(velocity.x,0,0.2)
func get_shoot_input():
	if Input.is_action_just_pressed("shoot") and Input.is_action_pressed("down") and ammo_amount > 0:
		shot = true
		velocity.y = SHOOTFORCE
		ammo_amount = ammo_amount - 1
		print(ammo_amount)
		$Sounds/ShootSound1.play()
		shoot()
	elif Input.is_action_just_pressed("shoot") and ammo_amount > 0:
		shot = true
		ammo_amount = ammo_amount - 1
		print(ammo_amount)
		$Sounds/ShootSound1.play()
		shoot()
	if is_on_floor():
		ammo_amount = max_ammo_amount
	if ammo_amount == 2:
		$HUD/ShotUI/Sprite3.show()
	elif ammo_amount == 1:
		$HUD/ShotUI/Sprite3.hide()
		$HUD/ShotUI/Sprite2.show()
	elif ammo_amount == 0:
		$HUD/ShotUI/Sprite3.hide()
		$HUD/ShotUI/Sprite2.hide()
		$HUD/ShotUI/Sprite.show()
func shoot():
	var new_bullet = BULLET_SCENE.instance()
	new_bullet.position = gun_muzzle.global_position
	get_tree().current_scene.add_child(new_bullet)
func get_health():
	if Global.md == true:
		if health >= 1:
			health -= health_minus
			#$Sounds/HurtSound1.play()
			Global.md = false
	if Global.ge1_damage == true:
		health -= health_minus
		Global.ge1_damage = false
		#$Sounds/HurtSound1.play()
		#state_machine.travel("Damaged")
	if Global.ge2_damage == true:
		health -= 4
		Global.ge2_damage = false
	if health == 6:
		$HUD/HeartUI/Hearts3.show()
	elif health == 5:
		$HUD/HeartUI/Hearts3.hide()
		$HUD/HeartUI/HHearts2.show()
	elif health == 4:
		$HUD/HeartUI/Hearts3.hide()
		$HUD/HeartUI/HHearts2.hide()
		$HUD/HeartUI/Hearts2.show()
	elif health == 3:
		$HUD/HeartUI/Hearts3.hide()
		$HUD/HeartUI/HHearts2.hide()
		$HUD/HeartUI/Hearts2.hide()
		$HUD/HeartUI/HHearts1.show()
	elif health == 2:
		$HUD/HeartUI/Hearts3.hide()
		$HUD/HeartUI/HHearts2.hide()
		$HUD/HeartUI/Hearts2.hide()
		$HUD/HeartUI/HHearts1.hide()
		$HUD/HeartUI/Hearts1.show()
	elif health == 1:
		$HUD/HeartUI/Hearts3.hide()
		$HUD/HeartUI/HHearts2.hide()
		$HUD/HeartUI/Hearts2.hide()
		$HUD/HeartUI/HHearts1.hide()
		$HUD/HeartUI/Hearts1.hide()
		$HUD/HeartUI/HHearts.show()
	else:
		$HUD/HeartUI/Hearts3.hide()
		$HUD/HeartUI/HHearts2.hide()
		$HUD/HeartUI/Hearts2.hide()
		$HUD/HeartUI/HHearts1.hide()
		$HUD/HeartUI/Hearts1.hide()
		$HUD/HeartUI/HHearts.hide()
		$HUD/HeartUI/Hearts0.show()
		Global.shell_amount = Global.shell_amount - cur_game_sa
		get_tree().change_scene("res://scenes/main/levels/level1/Level1.tscn")
func shell_amount_func():
	if Global.add_cur_game_sa == true:
		cur_game_sa += 1
		Global.add_cur_game_sa = false
	shell_amount = Global.shell_amount
	$HUD/ShellUI/ShellAmount.text = String(shell_amount)
func get_sound():
	if Global.play_shell_sound == true:
		$Sounds/ShellPickupSound.play()
		Global.play_shell_sound = false
	if Global.play_enemy_hit_sound == true:
		$Sounds/EnemyHitSound.play()
		Global.play_enemy_hit_sound = false
	if Global.play_wall_hit_sound == true:
		$Sounds/WallHitSound.play()
		Global.play_wall_hit_sound = false
func _on_MoveTimer_animation_finished(anim_name):
	move_able = true
func _on_FlashOUT_animation_finished(anim_name):
	move_able = false
func _on_SpikeTDT_body_entered(body):
	Global.respawn = true
	Global.md = true
