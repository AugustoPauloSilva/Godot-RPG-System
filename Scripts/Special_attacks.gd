
extends Node

var mov_id
var mov_name
var mov_mult
var mov_el_atq
var mov_cost

func _ready():
	mov_mult = 1.0
	mov_id = -1
	mov_name = null
	mov_el_atq = null

func refresh():
	mov_mult = 1.0
	mov_id = -1
	mov_name = null
	mov_el_atq = null

func get_mov_id():
	return mov_id

func get_mov_name():
	return mov_name

func get_mov_mult():
	return mov_mult

func get_mov_el_atq():
	return mov_el_atq

func get_mov_cost():
	return mov_cost

func special(var id):
	if (id < 100):
		if (id == 1):
			mov_id = id
			mov_name = "Power Slash"
			mov_mult = 1.5
			mov_cost = 20
		elif (id == 2):
			mov_id = id
			mov_name = "Multi Slash"
			mov_mult = 3.0
			mov_cost = 100
		elif (id == 3):
			mov_id = id
			mov_name = "Burst Slash"
			mov_mult = 5.5
			mov_cost = 200
		elif (id == 4):
			mov_id = id
			mov_name = "Zero Slash"
			mov_mult = 10.0
			mov_cost = 400
	else:
		mov_mult = 1.0
		mov_id = -1
		mov_name = null
		mov_el_atq = null
