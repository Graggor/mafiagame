extends StaticBody2D

func _on_Area2D_area_entered(area):
	$Light2D.visible = false
	$CPUParticles2D.emitting = true
