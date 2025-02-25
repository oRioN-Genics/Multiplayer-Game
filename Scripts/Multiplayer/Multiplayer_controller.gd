extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var player_id := 1:
	set(id):
		player_id = id
		$InputSynchronizer.set_multiplayer_authority(id)


@onready var anim_tree = $Anim_tree
@onready var anim_state = anim_tree.get("parameters/playback")

enum player_states {MOVE, SWORD, JUMP, DEAD}
var current_state = player_states.MOVE

var input_movement = Vector2.ZERO
var speed = 350 

func _ready() -> void:
	$Sword/CollisionShape2D.disabled = true
	# Ensure the correct player has authority
	if $InputSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		set_physics_process(true)
		print("Set authority %s" % player_id)
	else:
		set_physics_process(false)
		print("No authority %s" % player_id)
		

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		#print("Processing inputs for player: ", player_id)
		match current_state:
			player_states.MOVE:
				Move()
			player_states.SWORD:
				Sword()
			player_states.JUMP:
				Jump()
			player_states.DEAD:
				Dead()
		

func Move():
	input_movement = $InputSynchronizer.input_direction
	
	if input_movement != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_movement)
		anim_tree.set("parameters/Walk/blend_position", input_movement)
		anim_tree.set("parameters/Sword/blend_position", input_movement)
		anim_tree.set("parameters/Jump/blend_position", input_movement)
		anim_state.travel("Walk")
		
		velocity = input_movement * speed
	
	if input_movement == Vector2.ZERO:
		anim_state.travel("Idle")
		velocity = Vector2.ZERO
		
	if Input.is_action_just_pressed("sword"):
		current_state = player_states.SWORD
		
	if Input.is_action_just_pressed("jump"):
		current_state = player_states.JUMP
	
	if Player_data.health <= 0:
		current_state = player_states.DEAD
		
	move_and_slide()
	
	
func Sword():
	anim_state.travel("Sword")
	

func Jump():
	anim_state.travel("Jump")
	velocity = input_movement * speed
	move_and_slide()


func Dead():
	anim_state.travel("Dead")
	Player_data.health = 4
	

func on_state_reset():
	current_state = player_states.MOVE
	

func clear_collision():
	$CollisionShape2D.disabled = true


func create_collision():
	$CollisionShape2D.disabled = false
