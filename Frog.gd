extends CharacterBody2D

var SPEED = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player 
var chase = false
const JUMP_VELOCITY = -250.0

const JUMP_DELAY = 2.0 
var jump_timer = 0.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if chase == true:
		if is_on_floor():
			jump_timer += delta
			
			if jump_timer >= JUMP_DELAY:
				jump_timer = 0.0
				velocity.y = JUMP_VELOCITY
				get_node("AnimatedSprite2D").play("Jump")
			

		player = get_node("../../Player/Player")
		var direction = (player.global_position - self.global_position).normalized()
		
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
		if velocity.y > 0 and velocity.x == 0:
			get_node("AnimatedSprite2D").play("Fall")
			
	else:
		velocity.x = 0
		get_node("AnimatedSprite2D").play("Idle")
		
	move_and_slide()
		
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
	

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false

