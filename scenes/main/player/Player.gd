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
var reload_time = 15
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

export var SHOOTFORCE = -260 # height when shooting down
const HITBACK = -40

var tick = false
var current_speed = 0
var is_moving = false
var has_jumped = false
var direction = 0

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

export var maxfallspeed = 200
var has_pressed_jump = false

#wall stuff variables
onready var left_wall_raycasts = $WallRaycastsLeft
onready var right_wall_raycasts = $WallRaycastsRight
var wall_direction = 0
export var max_wall_slide_speed = 20
export var Wall_jump_Velocity = Vector2(10, 10)
var has_wall_jumped =false



func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	
	#for some reason has_jumped fires off without a reason
	max_speed -= jump_slowing_down

func _process(delta):
	if (has_jumped or has_wall_jumped) and is_on_floor():
		max_speed += jump_slowing_down
		has_jumped = false
		has_wall_jumped = false
		tick = false
	
	#saves player direction globaly
	Global.direction = direction
	#saves if player is touching floor globaly
	Global.is_on_floor = is_on_floor()
	
	



func _physics_process(delta):
	get_gravity()
	get_sound()
	get_shoot_input()
	get_input()
	get_health()
	shell_amount_func()
	_update_wall_directions()
	#print(wall_direction)
	
	#lowers max speed if in air
	if !is_on_floor():
		#gravity
		velocity.y += get_gravity() * delta 
		if has_jumped and !tick:
			max_speed -= jump_slowing_down
			tick = true
			has_pressed_jump = false
		has_jumped = true
	
	if Input.is_action_just_pressed("jump") and move_able:
		has_pressed_jump = true
		if is_on_floor():
			jump()
	
	#low jumping
	if has_jumped and Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y += lowfallMultiplier
	

func get_gravity() -> float:  #sets gravity type
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func get_input():
	
	#print(velocity.y)
	current = state_machine.get_current_node()
	move_and_slide(velocity,Vector2.UP)
	#if youre not moving 
	if velocity.x == 0:
		if Input.is_action_pressed("up"):
			$AnimationPlayer.play("OnGroundLookUp")
		elif Input.is_action_pressed("down") and !is_on_floor():
			$AnimationPlayer.play("LookingDown(OnlyInAir)")
		else:  
			$AnimationPlayer.play("Idle")
	if move_able:
		#acceleration 
		if is_moving:
			acceleration()
		
		
		
		#controls
		if Input.is_action_pressed("left"):
			is_moving = true
			direction = -1
			
			$Sprite.flip_h = true
			if Input.is_action_pressed("up"):
				$AnimationPlayer.play("RunPointingUp")
			else:  
				$AnimationPlayer.play("Run")
		elif Input.is_action_pressed("right"):
			is_moving = true
			direction = 1
			if Input.is_action_pressed("up"):
				$AnimationPlayer.play("RunPointingUp")
			else:  
				$AnimationPlayer.play("Run")
			$Sprite.flip_h = false
		else: 
			
			is_moving = false
			deceleration()
		
	
	#max falling speed
	if velocity.y > maxfallspeed:
		velocity.y = maxfallspeed
	
	#removes y velocity when on ground
	if is_on_floor() and !has_pressed_jump:
		velocity.y = 1
	
	#wall jumping and sliding
	if !is_on_floor() and wall_direction != 0:
		wall_jumping()
		if Input.is_action_pressed("left") and wall_direction == -1 and velocity.y > 0:
			velocity.y = max_wall_slide_speed
		elif Input.is_action_pressed("right") and wall_direction == 1 and velocity.y > 0:
			velocity.y = max_wall_slide_speed
	
	
	
	#falling animation
	if velocity.y > 0 and !is_on_floor():
		$AnimationPlayer.play("FallingNormal")
	

func jump(): #jumping
	velocity.y = jump_velocity
	$Sounds/JumpSound.play()
	

func acceleration():
	if velocity.x < max_speed and direction == 1:
		velocity.x += acceleration / 2
	elif velocity.x > -max_speed and direction == -1:
		velocity.x -= acceleration / 2
	else:
		#current_speed = max_speed
		velocity.x = max_speed * sign(velocity.x)

func deceleration():
	if velocity.x > 0 and direction == 1:
		velocity.x -= deceleration
	elif velocity.x < 0 and direction == -1:
		velocity.x += deceleration
	elif (wall_direction !=0 and !is_on_floor()) or has_wall_jumped:
		velocity.x += deceleration * wall_direction *6
	elif !is_on_floor() and has_jumped:
		velocity.x += deceleration * direction * 4
	else: velocity.x = 0

func wall_jumping():
	if Input.is_action_just_pressed("jump"):
		has_wall_jumped = true
		var wall_jump_velocity = Wall_jump_Velocity
		wall_jump_velocity.x *= -wall_direction 
		velocity = wall_jump_velocity

func _update_wall_directions():
	var is_near_wall_left = _check_is_valid_wall(left_wall_raycasts)
	var is_near_wall_right = _check_is_valid_wall(right_wall_raycasts)
	if is_near_wall_left and is_near_wall_right:
		wall_direction = direction
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)


#checks if colliding with wall and returns true or false
func _check_is_valid_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI * 0.35 and dot < PI * 0.55:
				return true
	return false





func get_shoot_input():
	if Input.is_action_just_pressed("shoot") and Input.is_action_pressed("down") and ammo_amount > 0:
		shot = true
		if !is_on_floor():
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
	if is_on_floor() and ammo_amount == 0:
		if reload_time > 0:
			reload_time -=1
		else:
			reload_time = 15
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
