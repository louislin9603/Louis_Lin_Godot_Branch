extends CharacterBody2D

var SPEED = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player 
var chase = false
const JUMP_VELOCITY = -250.0

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if chase == true:
		if is_on_floor():

			velocity.y = JUMP_VELOCITY
			if get_node("AnimatedSprite2D").animation != "Death":
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
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		
	move_and_slide()
		
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
	

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false
		

func _on_player_death_body_entered(body):
	
	#If player steps on top (collision box) of the frog, frog stops moving and dies
	if body.name == "Player":
		velocity.x = 0
		chase = false
		get_node("AnimatedSprite2D").play("Death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()
		Game.Gold += 1
		Utils.saveGame()


func _on_player_collision_body_entered(body):
	#If player hits the side of the frog, takes damage
	if body.name == "Player":
		Game.playerHP -= 1
		player.get_node("AnimatedSprite2D").play("Death")



func _on_timer_timeout():
	print("hi")
