extends RigidBody2D

onready var PLAYER = get_tree().get_root().get_node("Player_stats")
onready var EQUIPS = get_tree().get_root().get_node("Items_Equips")

var acelerar = 5000
var maxvel = 300
var lv
var color
var shader_Wait
var counter
var active

func _visibility(var aux):
	get_node("Wait").set_hidden(true)
	get_node("Walk_up").set_hidden(true)
	get_node("Walk_down").set_hidden(true)
	get_node("Walk_left").set_hidden(true)
	get_node("Walk_right").set_hidden(true)
	if (aux == 0):
		get_node("Wait").set_hidden(false)
	elif (aux == 1):
		get_node("Walk_up").set_hidden(false)
	elif (aux == 2):
		get_node("Walk_down").set_hidden(false)
	elif (aux == 3):
		get_node("Walk_left").set_hidden(false)
	elif (aux == 4):
		get_node("Walk_right").set_hidden(false)

func get_color():
	return color

func set_color(var new):
	color = new
	shader_Wait.set_shader_param("ativar",new)
	get_node("Timer").start()
	counter = 0
	active = 0

func anim_heal():
	var PLAYER = get_tree().get_root().get_node("Player_stats")
	var ACT_PLAYER = self
	#PLAYER.set_hp(PLAYER.get_hp_max())
	#PLAYER.set_sp(PLAYER.get_sp_max())
	ACT_PLAYER.set_color(3)
	ACT_PLAYER.get_node("Heal").set_emitting(true)

func _ready():
	color = 0
	counter = 0
	active = 1
	shader_Wait = get_node("Wait").get_material()
	set_process(true)
	set_process_input(true)
	pass

func get_active():
	return active

func set_active(var new):
	active = new

func _integrate_forces(s):
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var step = s.get_step()
	var action = 0
	lv = s.get_linear_velocity()
	
	if (active == 1):
		if (right):
			if (lv.length() < maxvel):
				lv.x += acelerar*step
				action = 1
			else:
				var angle = lv.angle_to(Vector2(1,0))/20
				lv = lv.rotated(angle)
				action = 1
		if (left):
			if (lv.length() < maxvel):
				lv.x -= acelerar*step
				action = 1
			else:
				var angle = lv.angle_to(Vector2(-1,0))/20
				lv = lv.rotated(angle)
				action = 1
		if (up):
			if (lv.length() < maxvel):
				lv.y -= acelerar*step
				action = 1
			else:
				var angle = lv.angle_to(Vector2(0,-1))/20
				lv = lv.rotated(angle)
				action = 1
		if (down):
			if (lv.length() < maxvel):
				lv.y += acelerar*step
				action = 1
			else:
				var angle = lv.angle_to(Vector2(0,1))/20
				lv = lv.rotated(angle)
				action = 1
	
	if (action == 0 and active == 1):
		if (lv.x > 0):
			lv.x -= acelerar*step
			if (lv.x < 0):
				lv.x = 0
		elif (lv.x < 0):
			lv.x += acelerar*step
			if (lv.x > 0):
				lv.x = 0
		if (lv.y > 0):
			lv.y -= acelerar*step
			if (lv.y < 0):
				lv.y = 0
		elif (lv.y < 0):
			lv.y += acelerar*step
			if (lv.y > 0):
				lv.y = 0
	
	PLAYER.set_pos_x(get_pos().x)
	PLAYER.set_pos_y(get_pos().y)
	s.set_linear_velocity(lv)

func wanted_body():
	pass

func _input(event):
	if (Input.is_action_pressed("ui_move_change")):
		if (maxvel == 300):
			maxvel = 500
		else:
			maxvel = 300

func _process(delta):
	if (active == 1):
		if (Input.is_action_pressed("ui_up")):
			_visibility(1)
		elif (Input.is_action_pressed("ui_down")):
			_visibility(2)
		elif (Input.is_action_pressed("ui_left")):
			_visibility(3)
		elif (Input.is_action_pressed("ui_right")):
			_visibility(4)
		else:
			_visibility(0)
	else:
		_visibility(0)

func _on_Timer_timeout():
	counter += 1
	if (counter > 15):
		counter = 0
		set_color(0)
		active = 1
		get_node("Timer").stop()
