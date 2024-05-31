extends LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	text = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)

