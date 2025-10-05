extends Node

@onready var http := HTTPRequest.new()

const API_KEY = "e839b932e3ca7ad602e999c88625f8bc"
@onready var location_label: Label = $"../Location/MarginContainer/LocationLabel"
@onready var temperature_label: Label = $"../Temperature/MarginContainer/temperatureLabel"

func _ready():
	add_child(http)
	print("🔍 Obteniendo ubicación del jugador...")
	http.request("http://ip-api.com/json/")
	http.request_completed.connect(_on_request_completed)

func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		print(" Error al obtener ubicación:", response_code)
		return

	var data = JSON.parse_string(body.get_string_from_utf8())
	if typeof(data) != TYPE_DICTIONARY or not data.has("lat"):
		print("⚠️ No se pudo obtener datos de ubicación.")
		return

	var lat = data["lat"]
	var lon = data["lon"]
	var ciudad = data["city"]
	var pais = data["country"]

	location_label.text = ciudad
	obtener_clima(lat, lon, ciudad, pais)

func obtener_clima(lat: float, lon: float, ciudad: String, pais: String):
	var url = "https://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&appid=%s&units=metric&lang=es" % [lat, lon, API_KEY]
	var clima_http := HTTPRequest.new()
	add_child(clima_http)

	clima_http.request(url)
	clima_http.request_completed.connect(func(result, response_code, headers, body):
		if response_code != 200:
			print("Error al obtener clima:", response_code)
			return

		var clima_data = JSON.parse_string(body.get_string_from_utf8())
		if typeof(clima_data) != TYPE_DICTIONARY or not clima_data.has("main"):
			print("No se pudo leer el clima.")
			return

		var temperatura = clima_data["main"]["temp"]
		var descripcion = clima_data["weather"][0]["description"]

		temperature_label.text = str(temperatura, "°C")
		print("Clima en %s (%s): %s°C, %s" % [ciudad, pais, temperatura, descripcion])
		decidir_cultivos(ciudad, pais, temperatura, descripcion)
	)

func decidir_cultivos(ciudad: String, pais: String, temp: float, clima: String):
	var cultivo = ""

	if pais == "México":
		if clima.contains("lluvia"):
			cultivo = "🌱 Café"
		elif temp > 30:
			cultivo = "🌽 Maíz"
		elif temp < 20:
			cultivo = "🌾 Trigo"
		else:
			cultivo = "🍅 Tomate"
	elif pais == "España":
		cultivo = "🫒 Olivo"
	elif pais == "Estados Unidos":
		cultivo = "🌻 Soya"
	else:
		cultivo = "🍇 Uvas"

	print("✅ Cultivo recomendado para %s (%s): %s" % [ciudad, pais, cultivo])
