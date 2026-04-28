# ProtoController v1.0 by Brackeys
# Modificado para incluir Dash e Fall Reset com rotação inicial da cena
extends CharacterBody3D

## Configurações Básicas
@export var can_move : bool = true
@export var has_gravity : bool = true
@export var can_jump : bool = true
@export var can_sprint : bool = true
@export var can_freefly : bool = true

#########################################################################
#   MODIFICAÇÕES: DASH SUAVE
#########################################################################
@export_group("Dash Settings")
@export var can_dash : bool = true
@export var dash_speed : float = 50.0
@export var dash_duration : float = 0.2
@export var dash_cooldown : float = 0.8
@export var dash_smoothness : float = 12.0

@export_group("Input Actions")
@export var input_dash : String = "dash"

var is_dashing : bool = false
var can_dash_again : bool = true
var dash_timer : Timer
var cooldown_timer : Timer

#########################################################################
#   MODIFICAÇÕES: FALL RESET
#########################################################################
@export_group("Fall Reset")
## Altura Y que ativa o teleporte
@export var fall_limit : float = -10.0
## Posição para onde o jogador será levado
@export var spawn_point : Vector3 = Vector3(0, 2, 0)

# Variável para guardar como o player estava virado no começo
var initial_look_rotation : Vector2

#########################################################################
#   CONFIGURAÇÕES DE VELOCIDADE (ORIGINAL)
#########################################################################
@export_group("Speeds")
@export var look_speed : float = 0.002
@export var base_speed : float = 7.0
@export var jump_velocity : float = 4.5
@export var sprint_speed : float = 10.0
@export var freefly_speed : float = 25.0

@export_group("Input Actions")
@export var input_left : String = "ui_left"
@export var input_right : String = "ui_right"
@export var input_forward : String = "ui_up"
@export var input_back : String = "ui_down"
@export var input_jump : String = "ui_accept"
@export var input_sprint : String = "sprint"
@export var input_freefly : String = "freefly"

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = false

@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider

func _ready() -> void:
	check_input_mappings()
	# Captura a rotação inicial da cena (Editor)
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x
	
	# Salva essa rotação para usar no respawn
	initial_look_rotation = look_rotation
	
	# Inicialização dos Timers do Dash
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

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)
	
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()

func _physics_process(delta: float) -> void:
	check_fall()
	
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return
	
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			velocity.y = jump_velocity

	if can_sprint and Input.is_action_pressed(input_sprint):
			move_speed = sprint_speed
	else:
		move_speed = base_speed

	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		# Logica de Dash
		if can_dash and can_dash_again and Input.is_action_just_pressed(input_dash) and move_dir != Vector3.ZERO:
			is_dashing = true
			can_dash_again = false
			dash_timer.start()
			velocity.x = move_dir.x * dash_speed
			velocity.z = move_dir.z * dash_speed
		elif is_dashing:
			velocity.x = lerp(velocity.x, move_dir.x * move_speed, dash_smoothness * delta)
			velocity.z = lerp(velocity.z, move_dir.z * move_speed, dash_smoothness * delta)
		elif move_dir:
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.has_method("iniciar_sumir"):
			collider.iniciar_sumir()

func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)

func check_fall():
	if global_position.y < fall_limit:
		# Reposiciona o jogador
		global_position = spawn_point
		
		# Zera o movimento
		velocity = Vector3.ZERO
		
		# Restaura exatamente a rotação que estava na cena ao começar
		look_rotation = initial_look_rotation
		
		# Aplica a rotação visualmente
		rotate_look(Vector2.ZERO)

func _on_dash_timer_timeout():
	is_dashing = false
	cooldown_timer.start()

func _on_cooldown_timer_timeout():
	can_dash_again = true

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

func check_input_mappings():
	var actions = [input_left, input_right, input_forward, input_back]
	for a in actions:
		if not InputMap.has_action(a):
			push_error("Botão de movimento faltando: " + a)
	if can_dash and not InputMap.has_action(input_dash):
		push_error("Botão de dash faltando: " + input_dash)
