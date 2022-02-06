extends Area2D

#SPEED VARIABLES
const SPEED = 400


#SHOOT DIRECTION VARIABLES
var shootright = false
var shootleft = false
var shootdown = false
var shootup = false


func _ready():
	if Input.is_action_pressed("up"):
		shootup = true
	elif Input.is_action_pressed("down") and !Global.is_on_floor:
		shootdown = true
	elif Global.direction == "left":
		shootleft = true
	elif Global.direction == "right":
		shootright = true
func _physics_process(delta):
	if shootleft == true:
		position.x += -SPEED * delta
		$Sprite.show()
		$Sprite1Coll.disabled = false
		$Sprite.flip_h = true
	elif shootright == true:
		position.x += SPEED * delta
		$Sprite.show()
		$Sprite1Coll.disabled = false
	elif shootup == true:
		position.y += -SPEED * delta
		$Sprite2.show()
		$Sprite2Coll.disabled = false
		$Sprite2.rotation_degrees = 270
	elif shootdown == true:
		position.y += SPEED * delta
		$Sprite2.show()
		$Sprite2Coll.disabled = false
	if shootup == true or shootdown == true:
		$WallFinder/CollisionShape2D2.disabled = true
		$WallFinder/CollisionShape2D.disabled = false
	elif shootleft == true or  shootright == true:
		$WallFinder/CollisionShape2D2.disabled = false
		$WallFinder/CollisionShape2D.disabled = true
func _on_Bullet_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	$DiePlayerTimer.play("timer")
func _on_Bullet_body_entered(body):
	$DiePlayerTimer.play("timer")
func _on_DiePlayerTimer_animation_finished(anim_name):
	queue_free()
func _on_QueTimer_animation_finished(anim_name):
	queue_free()
func _on_EnemyFinder_body_entered(body):
	$EnemyFinder/EnemyHitSound.play()
	if $EnemyFinder/EnemyHitSound.playing == false:
		queue_free()
func _on_WallFinder_body_entered(body):
	Global.play_wall_hit_sound = true
	queue_free()
