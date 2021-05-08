extends KinematicBody


remote func sendPose(pos):
	global_transform = pos

remote func setAnimation(anim):
	$the_nun/AnimationPlayer.play(anim)
