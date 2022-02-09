extends KinematicBody2D


onready var shelldrop = $ShellDrop
var health = 5
var velocity = Vector2()
export var direction = -1
onready var SHELL_SCENE = preload("res://scenes/other/objects/Shell.tscn")


func _ready():
	randomize()
	if direction == 1:
		$AnimatedSprite.scale.x = -3
	$FloorChecker.position.x = $CollisionPolygon2D.shape.get_extents().x * direction
func _physics_process(delta):
	if is_on_wall() or not $FloorChecker.is_colliding() and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$FloorChecker.position.x = $CollisionPolygon2D.shape.get_extents().x * direction
	velocity.y += 20
	velocity.x = 15 * direction
	velocity = move_and_slide(velocity,Vector2.UP)
func _on_PlayerDetector_body_entered(body):
	Global.ge1_damage = true
func _on_BulletDetector_area_entered(area):
	
	Global.play_enemy_hit_sound = true
	if health > 0:
		health = health - 1
	elif health <= 0:
		die()
func die():
	var shell_drop_amount = (randi() % 5) 
	while shell_drop_amount > 0:
		var new_shell = SHELL_SCENE.instance()
		new_shell.position = shelldrop.global_position
		get_tree().current_scene.add_child(new_shell)
		shell_drop_amount -= 1
	if shell_drop_amount == 0:
		queue_free()
