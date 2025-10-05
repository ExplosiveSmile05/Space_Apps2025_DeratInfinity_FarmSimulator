extends Node
##agregar la ruta
var main_scene_path: String =""
var main_scene_level_root_path: String = ""

var level_scenes : Dictionary = {
	"Level1" : ""
}

func load_main_scene_container() -> void:
	var node: Node = load(main_scene_path).instantiate()
	
	if node != null:
		get_tree().root.add_child(node)
		
func load_level(level : String) -> void:
	var scene_path: String = level_scenes.get(level)
	
	
	if scene_path == null:
		return
	
	var level_scene: Node = load(scene_path).instantisate()
	var level_root: Node = get_node(main_scene_level_root_path)
	
	if level_root != null:
		var nodes = level_root.get_children()
		
		if nodes != null:
			for node: Node in nodes:
				node.queue_free()
				
		#level_root.add_child(level_scenes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                )
