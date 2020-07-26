extends Area2D

# warning-ignore:unused_signal
signal pellet_touch
# warning-ignore:unused_signal
signal segment_touch
var direction = null

func _process(_delta):
	
	if Input.is_action_pressed("ui_right") and self.direction != 3:
		self.set_dir(1)
	elif Input.is_action_pressed("ui_left") and self.direction != 1:
		self.set_dir(3)
	elif Input.is_action_pressed("ui_up") and self.direction != 2:
		self.set_dir(0)
	elif Input.is_action_just_pressed("ui_down") and self.direction != 0:
		self.set_dir(2)
	
	pass

func set_dir(dir):
	
	self.direction = dir
	
	pass

func get_dir():
	
	return self.direction

func _on_Head_area_entered(_area):
	call_deferred("emit_signal", "pellet_touch")
	pass


func _on_Head_body_entered(_body):
	call_deferred("emit_signal", "segment_touch")
	pass # Replace with function body.
