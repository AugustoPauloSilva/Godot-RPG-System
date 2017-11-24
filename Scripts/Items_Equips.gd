extends Node

onready var PLAYER = get_tree().get_root().get_node("Player_stats")

var atq
var el_atq
var foco
var vel
var def
var items
var inv_id
var outro_atq
var outro_el_atq
var outro_foco
var outro_vel
var outro_def
var efeito

func get_atq():
	return atq

func get_el_atq():
	return el_atq

func get_def():
	return def

func get_vel():
	return vel

func get_foco():
	return foco

func _ready():
	atq = 0
	el_atq = null
	foco = 0.0
	vel = 0
	def = 0
	items = IntArray()
	items.append(2)
	items.append(102)
	items.append(202)
	items.append(302)
	items.append(401)
	outro_atq = 0
	outro_el_atq = null
	outro_foco = 0.0
	outro_vel = 0
	outro_def = 0
	inv_id = -1

func refresh():
	atq = 0
	el_atq = null
	foco = 0.0
	vel = 0
	def = 0
	outro_atq = 0
	outro_el_atq = null
	outro_foco = 0.0
	outro_vel = 0
	outro_def = 0
	inv_id = -1

func refresh_inv():
	outro_atq = 0
	outro_el_atq = null
	outro_foco = 0.0
	outro_vel = 0
	outro_def = 0
	inv_id = -1

func _set_weapon(var name):
	if(name.nocasecmp_to("Rusty Sword") == 0):
		atq += 0
		el_atq += 0
		foco += 0.0
		vel += 0
	elif(name.nocasecmp_to("Iron Sword") == 0):
		atq += 50
		el_atq += 0
		foco += 0.0
		vel += -10
	elif(name.nocasecmp_to("GreatSword") == 0):
		atq += 100
		el_atq += 0
		foco += 0.0
		vel += -50

func _set_shield(var name):
	if (name.nocasecmp_to("Wooden Shield") == 0):
		def += 20
		vel += 0
	elif (name.nocasecmp_to("Iron Shield") == 0):
		def += 50
		vel += -30

func _set_armor(var name):
	if(name.nocasecmp_to("TShirt") == 0):
		def += 0
		vel += 0
	elif(name.nocasecmp_to("Leather Armor") == 0):
		def += 40
		vel += 0
	elif(name.nocasecmp_to("Iron Armor") == 0):
		def += 70
		vel += -30

func _set_shoes(var name):
	if (name.nocasecmp_to("Iron Boots") == 0):
		def += 30
		vel += 10
	elif (name.nocasecmp_to("Leather Boots") == 0):
		def += 10
		vel += 30
	elif(name.nocasecmp_to("Casual Shoes") == 0):
		def += 0
		vel += 0

func _get_weapon(var name):
	if(name.nocasecmp_to("Rusty Sword") == 0):
		outro_atq += 0
		if(outro_el_atq != null):outro_el_atq += 0
		else:outro_el_atq = 0
		outro_foco += 0.0
		outro_vel += 0
	elif(name.nocasecmp_to("Iron Sword") == 0):
		outro_atq += 50
		if(outro_el_atq != null):outro_el_atq += 0
		else:outro_el_atq = 0
		outro_foco += 0.0
		outro_vel += -10
	elif(name.nocasecmp_to("GreatSword") == 0):
		outro_atq += 100
		if(outro_el_atq != null):outro_el_atq += 0
		else:outro_el_atq = 0
		outro_foco += 0.0
		outro_vel += -50

func _get_shield(var name):
	if (name.nocasecmp_to("Wooden Shield") == 0):
		outro_def += 20
		outro_vel += 0
	elif (name.nocasecmp_to("Iron Shield") == 0):
		outro_def += 50
		outro_vel += -30

func _get_armor(var name):
	if(name.nocasecmp_to("TShirt") == 0):
		outro_def += 0
		outro_vel += 0
	elif(name.nocasecmp_to("Leather Armor") == 0):
		outro_def += 40
		outro_vel += 0
	elif(name.nocasecmp_to("Iron Armor") == 0):
		outro_def += 70
		outro_vel += -30

func _get_shoes(var name):
	if (name.nocasecmp_to("Iron Boots") == 0):
		outro_def += 30
		outro_vel += 10
	elif (name.nocasecmp_to("Leather Boots") == 0):
		outro_def += 10
		outro_vel += 30
	elif(name.nocasecmp_to("Casual Shoes") == 0):
		outro_def += 0
		outro_vel += 0

func _get_items(var name):
	if (name.nocasecmp_to("HP Potion") == 0):efeito = 5
	elif (name.nocasecmp_to("SP Potion") == 0):efeito = 105
	elif (name.nocasecmp_to("Rebirth Potion") == 0):efeito = 201

func usar_item():
	if (inv_id != -1 and inv_id < items.size()):
		if(efeito != 0):
			if (PLAYER.get_hp() > 0):
				items.remove(inv_id)
				if (efeito < 100):
					PLAYER.set_hp(PLAYER.get_hp()+(100*efeito))
				elif (efeito < 200):
					efeito -= 100
					PLAYER.set_hp(PLAYER.get_sp()+(100*efeito))
			elif (efeito < 300):
				items.remove(inv_id)
				efeito -= 200
				PLAYER.set_hp(PLAYER.get_sp()+(100*efeito))
	else:
		print("O item nao existe")

func equipar(var id):
	var name
	
	if (id >= 0 and id < items.size()):
		if (el_atq == null):el_atq = 0
		id = items[id]
		if(id < 100):
			if (id == 1):name = "Rusty Sword"
			elif(id == 2):name = "Iron Sword"
			elif(id == 3):name = "GreatSword"
			_set_weapon(name)
		elif(id < 200):
			id -= 100
			if (id == 1):name = "Wooden Shield"
			elif(id == 2):name = "Iron Shield"
			_set_shield(name)
		elif(id < 300):
			id -= 200
			if (id == 1):name = "TShirt"
			elif(id == 2):name = "Leather Armor"
			elif(id == 3):name = "Iron Armor"
			_set_armor(name)
		elif(id < 400):
			id -= 300
			if (id == 1):name = "Casual Shoes"
			elif(id == 2):name = "Leather Boots"
			elif(id == 3):name = "Iron Boots"
			_set_shoes(name)
		
		if (el_atq == 0):el_atq = null
		return name

func identificar(var id):
	var name
	refresh_inv()
	
	if (id >= 0 and id < items.size()):
		inv_id = id
		id = items[id]
		if(id < 100):
			if (id == 1):name = "Rusty Sword"
			elif(id == 2):name = "Iron Sword"
			elif(id == 3):name = "GreatSword"
			_get_weapon(name)
		elif(id < 200):
			id -= 100
			if (id == 1):name = "Wooden Shield"
			elif(id == 2):name = "Iron Shield"
			_get_shield(name)
		elif(id < 300):
			id -= 200
			if (id == 1):name = "TShirt"
			elif(id == 2):name = "Leather Armor"
			elif(id == 3):name = "Iron Armor"
			_get_armor(name)
		elif(id < 400):
			id -= 300
			if (id == 1):name = "Casual Shoes"
			elif(id == 2):name = "Leather Boots"
			elif(id == 3):name = "Iron Boots"
			_get_shoes(name)
		else:
			id -= 400
			if (id == 1):name = "HP Potion"
			elif (id == 11):name = "SP Potion"
			elif (id == 21):name = "Rebirth Potion"
			_get_items(name)
		
		return name
