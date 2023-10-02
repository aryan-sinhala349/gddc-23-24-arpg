extends CharacterBody2D

@onready var spriteAnim = $AnimatedSprite2D

@export var speed: float = 200.0 # Speed of character. Will need to tune appropriately to BPM of eventual song. 
@export var jump_velocity: float = -200.0 # Jump Speed. Alter as necessary.

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var landing : bool # Check if character is landing or not

func _ready():
	# Player will continually move to the right of the screen. We can add Area2D nodes in the level to manually change the speed of player. 
	velocity.x = speed

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor(): #If on ground...
		if landing: # Play the land animation if character has just landed
			spriteAnim.play("land")
			landing = false
	else:
		velocity.y += gravity * delta
		if !landing: #If character is in air and hasn't landed yet.
			landing = true
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		spriteAnim.play("jump")
	
	move_and_slide()


func _on_animated_sprite_2d_animation_finished(): # For animations that play one after another.
	if (spriteAnim.get_animation() == "land"): # After land animation ends, play run loop.
		spriteAnim.play("run")
	elif (spriteAnim.get_animation() == "jump"): #After jump animation ends, play airborne animation
		spriteAnim.play("air")


func _on_animated_sprite_2d_animation_looped(): # If run loops while character is in air, then play air state. Might lag behind a second depending on area. Will fix later.
	if !is_on_floor() and landing:
		spriteAnim.play("air")
