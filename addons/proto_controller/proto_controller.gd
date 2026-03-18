# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

extends CharacterBody3D

## Can we move around?
@export var can_move : bool = true
## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we press to jump?
@export var can_jump : bool = true
## Can we hold to run?
@export var can_sprint : bool = true
## Can we press to enter freefly mode (noclip)?
@export var can_freefly : bool = true

#########################################################################
###################   MODIFICAÇÕES: DASH SUAVE   ########################
#########################################################################
@export_group("Dash Settings")
## O personagem pode dar dash?
@export var can_dash : bool = true
## Força do impulso inicial do dash.
@export var dash_speed : float = 50.0
## Duração do impulso (em segundos).
@export var dash_duration : float = 0.2
## Tempo de espera para usar de novo (em segundos).
@export var dash_cooldown : float = 0.8
## Suavidade da desaceleração (quanto maior, mais brusco volta ao normal).
@export var dash_smoothness : float = 12.0

@export_group("Input Actions")
## Nome da ação de Input para o Dash.
@export var input_dash : String = "dash"

# Variáveis internas para o funcionamento do dash
var is_dashing : bool = false
var can_dash_again : bool = true
var dash_timer : Timer
var cooldown_timer : Timer
#########################################################################

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 7.0
## Speed of jump.
@export var jump_velocity : float = 4.5
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?
@export var freefly_speed : float = 25.0

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "ui_left"
## Name of Input Action to move Right.
@export var input_right : String = "ui_right"
## Name of Input Action to move Forward.
@export var input_forward : String = "ui_up"
## Name of Input Action to move Backward.
@export var input_back : String = "ui_down"
## Name of Input Action to Jump.
@export var input_jump : String = "ui_accept"
## Name of Input Action to Sprint.
@export var input_sprint : String = "sprint"
## Name of Input Action to toggle freefly mode.
@export var input_freefly : String = "freefly"

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = false

## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider

func _ready() -> void:
	check_input_mappings()
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	
	#####################################################################
	################### CONFIGURAÇÃO DOS TIMERS (DASH) ##################
	# Criamos os timers via código para facilitar a instalação do script
	dash_timer = Timer.new()
	dash_timer.one_shot = true
	dash_timer.wait_time = dash_duration
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	add_child(dash_timer)
	
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)
	#####################################################################

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)
	
	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

func _physics_process(delta: float) -> void:
	
	check_fall()
	
	# If freeflying, handle freefly and nothing else
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return
	
	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Apply jumping
	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity

	# Modify speed based on sprinting
	if can_sprint and Input.is_action_pressed(input_sprint):
			move_speed = sprint_speed
	else:
		move_speed = base_speed

	#####################################################################
	################### LÓGICA DE MOVIMENTAÇÃO E DASH ###################
	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		# 1. DISPARAR O DASH
		if can_dash and can_dash_again and Input.is_action_just_pressed(input_dash) and move_dir != Vector3.ZERO:
			is_dashing = true
			can_dash_again = false
			dash_timer.start()
			# Impulso inicial forte
			velocity.x = move_dir.x * dash_speed
			velocity.z = move_dir.z * dash_speed
		
		# 2. SE ESTIVER EM DASH (SUAVIZAÇÃO)
		elif is_dashing:
			# Usamos lerp para reduzir a velocidade do dash gradualmente até a velocidade normal
			velocity.x = lerp(velocity.x, move_dir.x * move_speed, dash_smoothness * delta)
			velocity.z = lerp(velocity.z, move_dir.z * move_speed, dash_smoothness * delta)
			
		# 3. MOVIMENTO NORMAL
		elif move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.z = 0
	#####################################################################
	
	# Use velocity to actually move
	move_and_slide()


## Rotate us to look around.
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)


func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false


## Checks if some Input Actions haven't been created.
func check_input_mappings():
	if can_move and not InputMap.has_action(input_left):
		push_error("Movement disabled. No InputAction found for input_left: " + input_left)
		can_move = false
	if can_move and not InputMap.has_action(input_right):
		push_error("Movement disabled. No InputAction found for input_right: " + input_right)
		can_move = false
	if can_move and not InputMap.has_action(input_forward):
		push_error("Movement disabled. No InputAction found for input_forward: " + input_forward)
		can_move = false
	if can_move and not InputMap.has_action(input_back):
		push_error("Movement disabled. No InputAction found for input_back: " + input_back)
		can_move = false
	if can_jump and not InputMap.has_action(input_jump):
		push_error("Jumping disabled. No InputAction found for input_jump: " + input_jump)
		can_jump = false
	if can_sprint and not InputMap.has_action(input_sprint):
		push_error("Sprinting disabled. No InputAction found for input_sprint: " + input_sprint)
		can_sprint = false
	if can_freefly and not InputMap.has_action(input_freefly):
		push_error("Freefly disabled. No InputAction found for input_freefly: " + input_freefly)
		can_freefly = false
	
	#####################################################################
	# Verificação do Dash (nossa parte)
	if can_dash and not InputMap.has_action(input_dash):
		push_error("Dash disabled. No InputAction found for input_dash: " + input_dash)
		can_dash = false
	#####################################################################

#########################################################################
###################     FUNÇÕES EXTRAS (NOSSAS)      ####################
#########################################################################

@export_group("Fall Reset")
@export var fall_limit : float = -7.5
@export var spawn_point : Vector3 = Vector3(0, 2, 0)

func check_fall():
	if global_position.y < fall_limit:
		global_position = spawn_point
		velocity = Vector3.ZERO

# Chamado quando o tempo de "impulso" acaba
func _on_dash_timer_timeout():
	is_dashing = false
	cooldown_timer.start()

# Chamado quando o tempo de espera acaba
func _on_cooldown_timer_timeout():
	can_dash_again = true
#########################################################################
