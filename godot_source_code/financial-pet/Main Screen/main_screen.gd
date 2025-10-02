extends Control

@onready var money_label: Label = $Interface/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/MoneyLabel
@onready var mood_progress_bar: TextureProgressBar = $Interface/MarginContainer/Bars/VBoxContainer/HBoxContainer2/MoodProgressBar
@onready var fullness_progress_bar: TextureProgressBar = $Interface/MarginContainer/Bars/VBoxContainer/HBoxContainer/FullnessProgressBar
@onready var financial_progress_bar: TextureProgressBar = $Interface/MarginContainer/Bars/VBoxContainer/HBoxContainer3/FinancialProgressBar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var buttons_sound: AudioStreamPlayer = $ButtonsSound

var time: float = 0

func _ready() -> void:
	money_label.text = "Финансы " + str(Globals.money)
	mood_progress_bar.value = Globals.mood
	fullness_progress_bar.value = Globals.fullness
	financial_progress_bar.value = Globals.financial_literacy

func _physics_process(delta: float) -> void:
	time += delta
	if time >= 5.0:
		mood_progress_bar.value -= 1
		fullness_progress_bar.value -= 1
		Globals.mood = int(mood_progress_bar.value)
		Globals.fullness = int(fullness_progress_bar.value)
		time = 0.0

func _on_learn_button_pressed() -> void:
	for child in $Interface/Menu.get_children():
		child.queue_free()
		return
	var menu = preload("res://Button Menu/Learn Menu/learn_product_menu.tscn")
	var menu_instance = menu.instantiate()
	$Interface/Menu.add_child(menu_instance)
	menu_instance.change_financial_literacy_value.connect(_on_change_financial_literacy_value)
	menu_instance.add_fullness_value.connect(_on_add_fullness_value)
	buttons_sound.play()


func _on_my_briefcase_pressed() -> void:
	for child in $Interface/Menu.get_children():
		child.queue_free()
		return
	var my_briefcase_menu = preload("res://Button Menu/My Briefcase Menu/my_brief_case_menu.tscn")
	var my_briefcase_menu_instance = my_briefcase_menu.instantiate()
	$Interface/Menu.add_child(my_briefcase_menu_instance)
	my_briefcase_menu_instance.change_financial_literacy_value.connect(_on_change_financial_literacy_value)
	buttons_sound.play()


func _on_play_button_pressed() -> void:
	buttons_sound.play()
	var black_box: ColorRect = ColorRect.new()
	black_box.color = Color(0.0, 0.0, 0.0)
	black_box.set_anchors_preset(Control.PRESET_FULL_RECT)
	black_box.z_index = 1
	black_box.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$Interface.add_child(black_box)
	
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(black_box, "modulate", Color(1.0, 1.0, 1.0), 1)
	tween.parallel().tween_property(audio_stream_player, "volume_db", -80, 1)
	await tween.finished
	
	get_tree().change_scene_to_file("res://Games/Hunt For Scammers/hunt_for_scammers.tscn")


func _on_shop_button_pressed() -> void:
	add_close_menu("res://Button Menu/Shop Menu/shop_menu.tscn")

func _on_change_financial_literacy_value(added_value: int, add_money: int) -> void:
	financial_progress_bar.value += added_value
	Globals.money += add_money
	money_label.text = "Финансы " + str(Globals.money)

func _on_add_fullness_value(added_value: int) -> void:
	fullness_progress_bar.value += added_value
	Globals.fullness += added_value

func _on_daily_bonus_button_pressed() -> void:
	add_close_menu("res://Button Menu/Daily Box Menu/daily_bonus_menu.tscn")

func _on_setting_button_pressed() -> void:
	add_close_menu("res://Button Menu/Settings Menu/settings_menu.tscn")

func add_close_menu(menu_path: String) -> void:
	for child in $Interface/Menu.get_children():
		child.queue_free()
		return
	var menu = load(menu_path)
	var menu_instance = menu.instantiate()
	$Interface/Menu.add_child(menu_instance)
	buttons_sound.play()

func _on_menu_child_exiting_tree(_node: Node) -> void:
	buttons_sound.play()
