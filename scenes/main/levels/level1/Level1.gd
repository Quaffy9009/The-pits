extends Node2D


func _physics_process(delta):
	#print($Player.position)
	#print(Global.cur_room)
	if Global.respawn == true:
		respawn()
func respawn():
	$Player.set_position(Global.last_position)
	$Player/FlashScreen/ColorRect.show()
	$Player/FlashScreen/FlashIN.play("flashin")
	#$Player/FlashScreen/MoveTimer.play("timer")
	Global.respawn = false
