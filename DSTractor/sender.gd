extends Node

@export var ws: WebSocketServer
@export var camera: Camera3D
var peers: Dictionary = {}

func _ready():
	if OS.has_feature("web"):
		return

	print(ws.listen(9080))

	ws.client_connected.connect(on_connected)
	ws.client_disconnected.connect(on_disconnected)

func on_connected(peer: int):
	print("peer connected")
	peers[peer] = true
	
func on_disconnected(peer: int):
	print("peer disconnected")
	peers.erase(peer)

func _process(delta):
	if OS.has_feature("web") or peers.is_empty():
		return

	var data = camera.get_viewport().get_texture().get_image().get_data()
	for id in peers.keys():
		ws.send(id, data)
