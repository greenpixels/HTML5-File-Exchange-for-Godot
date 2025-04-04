extends Node

signal file_read_completed(file_type: String, file_name: String)
signal binary_loaded(buffer: PackedByteArray, file_type: String, file_name: String)

var js_callback: JavaScriptObject
var js_interface: JavaScriptObject

static var _js_initialized := false

func _ready() -> void:
	if OS.get_name() == "Web" and JavaScriptBridge.eval("typeof window != 'undefined'"):
		if not _js_initialized:
			_init_js()
		js_callback = JavaScriptBridge.create_callback(load_handler)
		js_interface = JavaScriptBridge.get_interface("_HTML5FileExchange")

func _init_js() -> void:
	var js_path := "res://addons/HTML5FileExchange/exchange.js"
	if not FileAccess.file_exists(js_path):
		push_error("JavaScript file not found: " + js_path)
		return
		
	var file := FileAccess.open(js_path, FileAccess.READ)
	var js_code := file.get_as_text()
	file.close()
	
	JavaScriptBridge.eval(js_code, true)
	_js_initialized = true

func load_handler(_args) -> void:
	var file_type = js_interface.fileType
	var file_name = js_interface.fileName
	file_read_completed.emit(file_type, file_name)

func load_file() -> void:
	if OS.get_name() != "Web" or !JavaScriptBridge.eval("typeof window != 'undefined'"):
		return

	js_interface.upload(js_callback)
	
	var file_type: String
	var file_name: String
	await file_read_completed.connect(
		func(type: String, name: String) -> void:
			file_type = type
			file_name = name
	)
	
	#var file_data = JavaScriptBridge.eval("_HTML5FileExchange.result", true)
	#binary_loaded.emit(file_data, file_type, file_name)

func save_file(buffer: PackedByteArray, file_name: String) -> void:
	if OS.get_name() != "Web" or !JavaScriptBridge.eval("typeof window != 'undefined'"):
		return
	
	JavaScriptBridge.download_buffer(buffer, file_name)
