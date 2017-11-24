extends Node

onready var EQUIPS = get_tree().get_root().get_node("Items_Equips")

var lvl
var lvl_xp
var xp
var par
var hp
var hp_max
var sp
var sp_max
var st
var atq
var def
var vel
var foco
var specials
var equips
var pos_x
var pos_y
var shader_color

func get_lvl():
	return lvl

func set_lvl(var new):
	lvl = new

func get_lvl_xp():
	return lvl_xp

func set_lvl_xp(var new):
	lvl_xp = new

func create_lvl_xp():
	lvl_xp = lvl*30

func get_par():
	return par

func upgrade(var status):
	if (par > 0):
		par -= 1
		if(status.nocasecmp_to("hp") == 0):
			hp += 100
			hp_max += 100
		elif(status.nocasecmp_to("sp") == 0):
			sp += 10
			sp_max += 10
		elif(status.nocasecmp_to("atq") == 0):
			atq += 1
		elif(status.nocasecmp_to("def") == 0):
			def += 1
		elif(status.nocasecmp_to("vel") == 0):
			vel += 1
		elif(status.nocasecmp_to("foco") == 0):
			foco += 0.1

func get_xp():
	return xp

func set_xp(var new):
	xp = new
	if (xp >= lvl_xp):
		xp -= lvl_xp
		lvl += 1
		create_lvl_xp()
		print("lvl up!! lvl="+str(lvl))
		par += 5
		if (lvl == 75):specials.append(4)
		if (lvl == 50):specials.append(3)
		if (lvl == 25):specials.append(2)

func get_hp():
	return hp

func set_hp(var new):
	hp = new
	if (hp > hp_max):
		hp = hp_max
	elif (hp < 0):
		hp = 0

func get_hp_max():
	return hp_max

func set_hp_max(var new):
	hp_max = new

func get_sp():
	return sp

func set_sp(var new):
	sp = new
	if (sp > sp_max):
		sp = sp_max
	elif (sp < 0):
		sp = 0

func get_sp_max():
	return sp_max

func set_sp_max(var new):
	sp_max = new

func get_st():
	return st

func set_st(var new):
	st = new
	if (st > 500):
		st = 500
	elif (st < 0):
		st = 0

func get_atq():
	return (atq+EQUIPS.get_atq())

func get_el_atq():
	return EQUIPS.get_el_atq()

func set_atq(var new):
	atq = new

func get_def():
	return (def+EQUIPS.get_def())

func set_def(var new):
	def = new

func get_vel():
	if (vel+EQUIPS.get_vel() > 0):return (vel+EQUIPS.get_vel())
	return 0

func set_vel(var new):
	vel = new

func get_foco():
	return (foco+EQUIPS.get_foco())

func set_foco(var new):
	foco = new

func get_specials(var i):
	return specials[i]

func refresh_equips():
	EQUIPS.refresh()
	EQUIPS.equipar(equips[0])
	EQUIPS.equipar(equips[1])
	EQUIPS.equipar(equips[2])
	EQUIPS.equipar(equips[3])

func get_equips(var i):
	return equips[i]

func set_equips(var i, var new):
	equips[i] = new

func get_pos_x():
	return pos_x

func set_pos_x(var new):
	pos_x = new

func get_pos_y():
	return pos_y

func set_pos_y(var new):
	pos_y = new

func get_shader_color():
	return shader_color

func set_shader_color(var new):
	shader_color = new

func _ready():
	lvl = 1
	lvl_xp = 30
	xp = 0
	par = 0
	hp = 300
	hp_max = 300
	sp = 100
	sp_max = 100
	st = 0
	atq = 50
	def = 10
	vel = 30
	foco = 1.0
	specials = IntArray()
	specials.append(1)
	equips = [0,1,2,3]
	refresh_equips()
	pos_x = 330
	pos_y = 360
	shader_color = -1
