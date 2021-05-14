extends KinematicBody


remote func sendPose(pos):
	global_transform = pos

remote func setAnimation(anim):
	$the_nun/AnimationPlayer.play(anim)

remote func flashLight(event):
	$the_nun/Armature/Skeleton/BoneAttachment/oil_lamp.visible = event
