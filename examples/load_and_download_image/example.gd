extends Node

@onready var texture_rect = %TextureRect
@onready var web_file_exchange = %WebFileExchange

func _ready() -> void:
	web_file_exchange.file_loaded.connect(_on_file_loaded)

func _on_file_loaded(buffer: PackedByteArray, file_type: String, _file_name: String) -> void:
	var image = Image.new()
	var error: Error
	match file_type:
		"image/png": error = image.load_png_from_buffer(buffer)
		"image/jpeg": error = image.load_jpg_from_buffer(buffer)
		"image/webp": error = image.load_webp_from_buffer(buffer)
		_:
			print("Non texture image format: ", file_type)
			return
	
	if error != OK:
		print("Failed to load image")
		return
		
	texture_rect.texture = ImageTexture.create_from_image(image)

func _on_download_button_pressed() -> void:
	if not texture_rect.texture:
		return
	var image = texture_rect.texture.get_image()
	var buffer = image.save_png_to_buffer()
	web_file_exchange.download_file(buffer, "image.png")


func _on_upload_button_pressed() -> void:
	web_file_exchange.open_load_file_dialog()
