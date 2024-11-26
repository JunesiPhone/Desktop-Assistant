extends Node2D

@onready var _MainWindow: Window = get_window()
@onready var input_dialog = $AcceptDialog

# Exported variables for configuration in the editor on Main
@export var model_sprite: Sprite2D
@export var mouth_anim_player: AnimationPlayer
@export var player_size: Vector2 = Vector2(200, 250)
@export var player_offset_from_right: int = 20

# Position of character above the taskbar
var taskbar_pos: int = int(DisplayServer.screen_get_usable_rect().size.y - player_size.y)

func _ready():
	# Change the size of the window
	_MainWindow.min_size = player_size
	_MainWindow.size = _MainWindow.min_size
	
	# Places the character in the middle of the screen and on top of the taskbar
	update_window_position()

func update_window_position():
	var screen_size = DisplayServer.screen_get_size()
	var window_position = Vector2(
		screen_size.x - (player_size.x + player_offset_from_right),
		taskbar_pos
	)
	_MainWindow.position = window_position

func _process(_delta):
	# Update the window position dynamically
	update_window_position()
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		input_dialog.show_dialog();
