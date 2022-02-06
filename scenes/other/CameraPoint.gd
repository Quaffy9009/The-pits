extends Area2D

export(int) var cur_camera_point_top
export(int) var cur_camera_point_bottom
export(int) var cur_camera_point_right
export(int) var cur_camera_point_left 
export(int) var cur_gravity = 20
export(int) var camera_point_id
export(bool) var one_time_pass = false
var pass_able = true


func _on_CameraPoint_body_entered(body):
	print("BodyEntered")
	Global.cur_room = camera_point_id
	Global.testing_camera = true
	Global.cur_camera_point_top = cur_camera_point_top
	Global.cur_camera_point_bottom = cur_camera_point_bottom
	Global.cur_camera_point_right = cur_camera_point_right
	Global.cur_camera_point_left = cur_camera_point_left
	Global.cur_gravity = cur_gravity
	print("Top:", Global.cur_camera_point_top)
	print("Bottom:", Global.cur_camera_point_bottom)
	print("Right:", Global.cur_camera_point_right)
	print("Left:", Global.cur_camera_point_left)
func _on_CameraPoint_area_entered(area):
	if pass_able == true:
		if one_time_pass == true:
			pass_able = false
		Global.cur_room = camera_point_id
		Global.testing_camera = true
		Global.cur_camera_point_top = cur_camera_point_top
		Global.cur_camera_point_bottom = cur_camera_point_bottom
		Global.cur_camera_point_right = cur_camera_point_right
		Global.cur_camera_point_left = cur_camera_point_left
		Global.cur_gravity = cur_gravity
		print("Top:", Global.cur_camera_point_top)
		print("Bottom:", Global.cur_camera_point_bottom)
		print("Right:", Global.cur_camera_point_right)
		print("Left:", Global.cur_camera_point_left)
		print("AreaEntered")
