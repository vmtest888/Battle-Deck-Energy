extends Control

@export var easy_battle_icon : Texture
@export var hard_battle_icon : Texture
@export var shelter_icon : Texture
@export var save_icon : Texture
@export var story_icon : Texture
@export var next_levels : Array : set = set_next_levels

@onready var level_texture_rect = %LevelTextureRect
@onready var separator_label := %SeparatorLabel
@onready var container := $HBoxContainer

var added_nodes : Array[Node]

func _add_level_icon(icon:Texture, is_first:bool=false):
	if is_first:
		level_texture_rect.texture = icon
		return
	var _separator_label := separator_label.duplicate()
	_separator_label.show()
	container.add_child.call_deferred(_separator_label)
	added_nodes.append(separator_label)
	var _level_texture_rect : TextureRect = level_texture_rect.duplicate()
	_level_texture_rect.show()
	_level_texture_rect.texture = icon
	container.add_child.call_deferred(_level_texture_rect)
	added_nodes.append(_level_texture_rect)

func _clear_added_nodes():
	for node in added_nodes:
		node.queue_free()
	added_nodes.clear()

func set_next_levels(value):
	next_levels = value
	_clear_added_nodes()
	var first:bool = true
	for next_level_path in next_levels:
		var next_level = load(next_level_path)
		if next_level is WeightedDataList:
			var random_level = next_level.get_random_data()
			if random_level is BattleLevelData:
				next_level = random_level
		if next_level is BattleLevelData:
			if next_level.mood_type == "HARD_BATTLE":
				_add_level_icon(hard_battle_icon, first)
			else:
				_add_level_icon(easy_battle_icon, first)
		elif next_level is ShelterLevelData:
			_add_level_icon(shelter_icon, first)
		elif next_level is StoryLevelData:
			_add_level_icon(story_icon, first)
		elif next_level is SaveDeckLevelData:
			_add_level_icon(save_icon, first)
		first = false

func _ready():
	next_levels = next_levels
