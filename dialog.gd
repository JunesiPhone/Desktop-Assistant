extends AcceptDialog

# Reference to the LineEdit node
@onready var input_field = $LineEdit

# Reference to the HTTPRequest node
@onready var http_request = $HTTPRequest

# Flag to track if an HTTP request is in progress
var request_in_progress = false

func _ready():
	# Connect signals
	connect("confirmed", Callable(self, "_on_confirmed"))
	connect("visibility_changed", Callable(self, "_on_visibility_changed"))
	input_field.connect("text_submitted", Callable(self, "_on_text_submitted"))
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	
	#set dialog title
	title = "Chat"
	
	# Hide the dialog initially
	hide()

func show_dialog():
	input_field.text = ""
	popup_centered()

func _on_confirmed():
	# Get the text from the input field
	var user_input = input_field.text
	print("User input: ", user_input)
	send_text_to_server(user_input)

func _on_text_submitted(_new_text):
	get_ok_button().emit_signal("pressed")

func _on_visibility_changed():
	if visible:
		input_field.grab_focus()

func send_text_to_server(text):
	if request_in_progress:
		print("Request already in progress. Please wait.")
		return
		
	request_in_progress = true
	print("sending to server")
	var url = "http://127.0.0.1:6969/send_text"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"text": text})
	http_request.request(url, headers, HTTPClient.METHOD_POST, body)

func _on_request_completed(result, _response_code, _headers, body):
	request_in_progress = false
	if result == HTTPRequest.RESULT_SUCCESS:
		var json_instance = JSON.new()
		var error = json_instance.parse(body.get_string_from_utf8())
		if error == OK:
			var response = json_instance.get_data()
			print("Server response: ", response)
		else:
			print("Failed to parse JSON response")
	else:
		print("Request failed")
