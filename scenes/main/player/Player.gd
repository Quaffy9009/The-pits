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

const SHOOTFORCE = -260 # height when shooting down
const HITBACK = -40

var tick = false
var current_speed = 0
var is_moving = false
var has_jumped = false
var direction

export var acceleration = 10
export var deceleration = 15
export var max_speed = 100


var velocity = Vector2()
#jumping variables
export var jump_slowing_down = 3

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float
export var lowfallMultiplier = 1

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0






func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	
	#for some reason has_jumped fires off without a reason
	max_speed -= jump_slowing_down

func _process(delta):
	if has_jumped and is_on_floor():
		max_speed += jump_slowing_down
		has_jumped = false
		tick = false


func _physics_process(delta):
	get_gravity()
	get_sound()
	get_shoot_input()
	get_input()
	get_health()
	shell_amount_func()
	#print(velocity.x)
	
	#lowers max speed if in air
	if !is_on_floor():
		#gravity
		velocity.y += get_gravity() * delta 
		if has_jumped and !tick:
			max_speed -= jump_slowing_down
			tick = true
		has_jumped = true
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and move_able:
		jump()
	
	#low jumping
	if has_jumped and Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y += lowfallMultiplier


func get_gravity() -> float:  #sets gravity type
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func get_input():
	#print(velocity.length())
	current = state_machine.get_current_node()
	
	if move_able:
		#acceleration 
		if is_moving:
			acceleration()
		
		
		
		#controls
		if Input.is_action_pressed("left"):
			is_moving = true
			direction = "left"
			$Sprite.flip_h = true
		elif Input.is_action_pressed("right"):
			is_moving = true
			direction = "right"
			$Sprite.flip_h = false
		else: 
			
			is_moving = false
			deceleration()
		
	
	if is_on_floor() and Input.is_action_pressed("up"):
		state_machine.travel("OnGroundLookingUp")
	
	
		
	#if velocity.length() <= 59:
	#	state_machine.travel("Idle")
	#if velocity.length() > 59 and is_on_floor():
	#	state_machine.travel("Run")
	#elif velocity.length() > 59 and !is_on_floor() and Input.is_action_pressed("down"):
	#	state_machine.travel("LookingDown(OnlyInAir)")
	#	Global.scale_x = 0
	#elif velocity.length() > 59 and is_on_floor() == false and Input.is_action_pressed("up"):
	#	state_machine.travel("FallLookingUp")
	#	Global.scale_x = 0
	#elif velocity.length() > 59 and is_on_floor() == false:
	#	state_machine.travel("FallingNormal")
	
	move_and_slide(velocity,Vector2.UP)

func jump(): #jumping
	velocity.y = jump_velocity
	$Sounds/JumpSound.play()

func acceleration():
	if velocity.x < max_speed and direction == "right":
		velocity.x += acceleration / 2
	elif velocity.x > -max_speed and direction == "left":
		velocity.x -= acceleration / 2
	else:
		#current_speed = max_speed
		velocity.x = max_speed * sign(velocity.x)

func deceleration():
	if velocity.x > 0 and direction == "right":
		velocity.x -= deceleration
	elif velocity.x < 0 and direction == "left":
		velocity.x += deceleration
	else: velocity.x = 0


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

#shooting
func shoot():
	var new_bullet = BULLET_SCENE.instance()
	new_bullet.position = gun_muzzle.global_position
	get_tree().current_scene.add_child(new_bullet)


#health
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
