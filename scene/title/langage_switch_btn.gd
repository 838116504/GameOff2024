extends Button

var chinese := true

func _ready():
	var loc = TranslationServer.get_locale()
	if loc.begins_with("zh_"):
		chinese = true
		text = "English"
	else:
		chinese = false
		text = "中文"
		TranslationServer.set_locale("en_US")

func _pressed():
	switch()

func switch():
	if chinese:
		TranslationServer.set_locale("en_US")
	else:
		TranslationServer.set_locale("zh_TW")
	
	chinese = !chinese
