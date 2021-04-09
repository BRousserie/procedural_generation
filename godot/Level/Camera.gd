# Gère les mouvements de caméra pour explorer le niveau généré
extends Camera2D
class_name LevelCamera

export(float) var CameraMoveSpeed := 0.0
export(float) var CameraZoomSpeed := 1.0

export(float) var CameraZoomMax := 4.0
export(float) var CameraZoomMin := 0.3

onready var _tween : Tween = $Tween

var _velocity := Vector2.ZERO
var _zoom_factor := 1.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_velocity.x = Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
	_velocity.y = Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")
	_velocity = _velocity.normalized() * CameraMoveSpeed

	translate(_velocity * _zoom_factor)

	if Input.is_action_just_released("camera_zoom_in") or Input.is_action_pressed("camera_zoom_in"):
		_zoom_factor -= CameraZoomSpeed
	elif Input.is_action_just_released("camera_zoom_out") or Input.is_action_pressed("camera_zoom_out"):
		_zoom_factor += CameraZoomSpeed

	_zoom_factor = clamp(_zoom_factor, CameraZoomMin, CameraZoomMax)
	
	var zoom_vector = Vector2.ONE * _zoom_factor
	
	_tween.interpolate_property(self, "zoom", null, zoom_vector, 0.1)
	_tween.start()
