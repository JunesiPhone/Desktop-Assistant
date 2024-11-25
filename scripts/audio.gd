extends Control

# Exported variables set from Control in AudioListener
@export var root_node: Node2D
@export var mouth_anim_player: AnimationPlayer

# Get the spectrum analyzer instance from the audio server this is applied in the audio tab of godot
@onready var spectrum: AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(0, 0)

# Constants
const VU_COUNT = 32  # Number of frequency bands
const START_FREQUENCY = 300  # Starting frequency for the first band
const FREQUENCY_FACTOR = 1.10  # Factor to increase frequency for each band
const MIN_DB = 80  # Minimum decibel value
const BACKLOG_TRUSTWORTHY = 3  # Number of consistent decisions to trust

# Variables
var decision_backlog = [0, 0, 0, 0, 0]  # Backlog for decision making
var FREQUENCY_BANDS = []  # List to store frequency bands
var FREQENCY_MULTIPLIER = []  # List to store frequency multipliers
var silence_time: float = 0.0  # Time counter for silence
var time_since_last_anim: float = 0.0  # Time counter since last animation

# Initialize the frequency bands and multipliers
func initialize_frequency_bands():
	var v = START_FREQUENCY
	for i in range(VU_COUNT + 1):
		v *= FREQUENCY_FACTOR
		FREQUENCY_BANDS.append(v)
		FREQENCY_MULTIPLIER.append(min(0.5 + i * 0.03, 1.0))

# Helper function to check if a value is between two bounds
func between(val, left, right):
	return val >= left and val <= right

# Called when the node is ready
func _ready():
	initialize_frequency_bands()

# Main processing function, called every frame
func _process(delta):
	var unsorted_bands = []
	var sorted_bands = []

	# Calculate energy for each frequency band
	for i in range(VU_COUNT):
		var prev_hz = FREQUENCY_BANDS[i]
		var hz = FREQUENCY_BANDS[i + 1]
		var f = spectrum.get_magnitude_for_frequency_range(prev_hz, hz)
		var energy = clamp((MIN_DB + linear_to_db(f.length())) / MIN_DB, 0, 1) * FREQENCY_MULTIPLIER[i]
		unsorted_bands.append({"index": i, "energy": energy})
		sorted_bands.append({"index": i, "energy": energy})

	# Sort bands by energy
	sorted_bands.sort_custom(sort_by_energy)

	# Update decision backlog based on sorted bands
	update_decision_backlog(sorted_bands)

	# Determine the result based on the decision backlog
	var result = determine_result()

	# Update animations based on the result
	update_animations(result, delta)

# Custom sort function to sort bands by energy
func sort_by_energy(a, b):
	return a["energy"] > b["energy"]

# Update the decision backlog based on the sorted bands
func update_decision_backlog(sorted_bands):
	if sorted_bands[0].energy >= 0.30:
		silence_time = 0.0
		if between(sorted_bands[0].index, 28, 32) and sorted_bands[0].energy > 0.4:
			decision_backlog.push_front(1)
		elif sorted_bands[0].energy > 0.4:
			if between(sorted_bands[0].index, 12, 16):
				decision_backlog.push_front(2)
			elif between(sorted_bands[0].index, 17, 28):
				decision_backlog.push_front(3)
			elif between(sorted_bands[0].index, 1, 11):
				decision_backlog.push_front(4)
			else:
				decision_backlog.push_front(5)
		else:
			decision_backlog.push_front(5)
	else:
		decision_backlog.push_front(0)
		silence_time += 1.5
	decision_backlog.pop_back()

# Determine the result based on the decision backlog
func determine_result():
	var sorted_backlog = decision_backlog.duplicate()
	var result = 0
	var is_strong_evidence = false

	for i in range(1, 6):
		var counted = sorted_backlog.count(i)
		if counted >= BACKLOG_TRUSTWORTHY - 1 and not is_strong_evidence:
			result = i
		if counted >= BACKLOG_TRUSTWORTHY:
			is_strong_evidence = true
			break

	return result

# Update animations based on the result
func update_animations(result, delta):
	time_since_last_anim += delta

	# Map results to animation names
	var anim_map = {
		1: "s",
		2: "a",
		3: "e",
		4: "o",
		5: "f",
		0: "closed"
	}

	# Map results to animation delays
	var anim_delay_map = {
		1: 0.0,
		2: 0.1,
		3: 0.1,
		4: 0.2,
		5: 0.1,
		0: 0.05
	}

	# Check if the time since the last animation is greater than the delay
	if time_since_last_anim > anim_delay_map.get(result, 0.0):
		# Play the corresponding animation
		root_node.mouth_anim_player.play(anim_map.get(result, "closed"))
		time_since_last_anim = 0
