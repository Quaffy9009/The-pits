extends Node2D


func _physics_process(delta):
	#print($Player.position)
	print(Global.cur_room)
	if Global.respawn == true:
		respawn()
	if Global.testing_camera == true:
		set_camera_point()
		Global.testing_camera = false
func respawn():
	$Player.set_position(Global.last_position)
	$Player/FlashScreen/ColorRect.show()
	$Player/FlashScreen/FlashIN.play("flashin")
	$Player/FlashScreen/MoveTimer.play("timer")
	Global.respawn = false
func set_camera_point():
	$Player/Camera2D.limit_top = Global.cur_camera_point_top
	$Player/Camera2D.limit_bottom = Global.cur_camera_point_bottom
	$Player/Camera2D.limit_right = Global.cur_camera_point_right
	$Player/Camera2D.limit_left = Global.cur_camera_point_left
