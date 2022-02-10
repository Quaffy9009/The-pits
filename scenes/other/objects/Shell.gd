extends KinematicBody2D

var FLYRANGE = 10
var GRAVITY = 10
var JUMPFORCE = 0
var velocity = Vector2(0,0)


func _ready():
	randomize()
	var SVD = (randi() % 10)
	#print("SVD =", SVD)
	if SVD == 10:
		FLYRANGE = -50
		JUMPFORCE = -50
	elif SVD == 9:
		FLYRANGE = 45
		JUMPFORCE = -45
	elif SVD == 8:
		FLYRANGE = -40
		JUMPFORCE = -40
	elif SVD == 7:
		FLYRANGE = 40
		JUMPFORCE = -40
		velocity.y = JUMPFORCE
	elif SVD == 6:
		FLYRANGE = 35
		JUMPFORCE = -35
		velocity.y = JUMPFORCE
	elif SVD == 5:
		FLYRANGE = -30
		JUMPFORCE = -30
		velocity.y = JUMPFORCE
	elif SVD == 4:
		FLYRANGE = -25
		JUMPFORCE = -25
		velocity.y = JUMPFORCE
	elif SVD == 3:
		FLYRANGE = 20
		JUMPFORCE = -20
		velocity.y = JUMPFORCE
	elif SVD == 2:
		FLYRANGE = -15
		JUMPFORCE = -15
		velocity.y = JUMPFORCE
	elif SVD == 1:
		FLYRANGE = 10
		JUMPFORCE = -10
		velocity.y = JUMPFORCE
	elif SVD == 0:
		FLYRANGE = -5
		JUMPFORCE = -5
		velocity.y = JUMPFORCE
func _physics_process(delta):
	if is_on_floor() == false:
		velocity.x += FLYRANGE
		velocity.y += GRAVITY
	if is_on_floor():
		GRAVITY = 0
		FLYRANGE = 0
		velocity.x -= FLYRANGE
		velocity.y -= GRAVITY
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.x = lerp(velocity.x,0,0.2)
func _on_PlayerDetector_body_entered(body):
	Global.add_cur_game_sa = true
	Global.play_shell_sound = true
	Global.shell_amount += 1
	queue_free()
