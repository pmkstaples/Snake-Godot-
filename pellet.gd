extends Area2D

# warning-ignore:unused_signal
signal pellet_blocked

func _on_Pellet_body_entered(_body):
	call_deferred("emit_signal", "pellet_blocked")
	pass # Replace with function body.
