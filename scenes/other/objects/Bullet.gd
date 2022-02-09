extends Area2D

#SPEED VARIABLES
var SPEED = 400


#SHOOT DIRECTION VARIABLES
var shoot_direction


func _ready():
	if Input.is_action_pressed("up"):
		shoot_direction = "up"
		self.rotation_degrees = -90
	elif Input.is_action_pressed("down") and !Global.is_on_floor:
		shoot_direction = "down"
		self.rotation_degrees = 90
	elif Global.direction == -1:
		shoot_direction = "left"
		self.rotation_degrees = -180
	elif Global.direction == 1:
		shoot_direction = "right"
		
		
func _physics_process(delta):
	if shoot_direction == "left":
		position.x += -SPEED * delta
	elif shoot_direction == "right":
		position.x += SPEED * delta
	elif shoot_direction == "up":
		position.y += -SPEED * delta
	elif shoot_direction == "down":
		position.y += SPEED * delta


func _on_Bullet_body_entered(body):
	$Particles2D.emitting = true
	Global.play_wall_hit_sound = true
	SPEED = 0
	$Sprite.hide()
	$Timer.start()
	
	


func _on_Timer_timeout():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
