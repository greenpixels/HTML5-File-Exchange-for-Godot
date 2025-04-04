# HTML5 File Exchange for Godot 4.4

Loads and saves files using PackedByteArray

## Installation

- Copy the contents of */addons* to your projects
- *export_presets.cfg* for `"Web"` needs `include_filter="*js"`
- In your scenes that need it, add a new `Html5FileExchange`-node 

## API

`signal file_loaded(buffer: PackedByteArray, file_type: String, file_name: String)`
`func open_load_file_dialog() -> void` 

`func download_file(buffer: PackedByteArray, file_name: String)`

## Usage

``` gd

@onready var my_html_file_exchange = $Html5FileExchange

func _ready():
	web_file_exchange.file_loaded.connect(func(buffer: PackedByteArray, file_type: String, file_name: String):
		# Here goes ...
		# Logic that checks the file_type or file_name and then converts the buffer
		#
		# See /examples for more
	)

``` 

## What can I do with a PackedByteArray

PackedByteArray has several methods to convert to other data types. Examples are `PackedByteArray.get_string_from_utf8()` or ` Image.load_png_from_buffer(buffer: PackedByteArray)` 