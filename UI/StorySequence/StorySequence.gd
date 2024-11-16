extends Control

@onready var story_slide: Control = %StorySlide
@onready var story_text: RichTextLabel = %StoryText
@onready var story_image: TextureRect = %StoryImage
@onready var skip_button: Button = %SkipButton
@onready var next_button: Button = %NextButton
@onready var story_music: AudioStreamPlayer = %StoryMusic

const FADE_DURATION_SEC := 1.0
const STORY_COPY : Array[String] = [
	"Boy genius [b]Charlie[/b] has a sick grandmother...",
	"So [b]Charlie[/b] built a homemade flying time machine from household appliances to fly into the future and find a cure!",
	"While calibrating his navigation, the inter-dimensional police force [b]S.T.A.C.K. attack Charlie[/b] for unlicensed time travel.",
	"The [b]attack[/b] by [b]S.T.A.C.K.[/b] must not prevent [b]Charlie[/b] from saving his grandmother!"
]
const STORY_IMG_PATHS : Array[String] = [
	"res://UI/StorySequence/assets/test_01.png",
	"res://UI/StorySequence/assets/test_02.png",
	"res://UI/StorySequence/assets/test_03.png",
	"res://UI/StorySequence/assets/test_02.png",
]
var story_img_textures : Array[Texture2D] = []
var format_string = "[center]%s[/center]"

var story_index := 0

func _ready():
	next_button.pressed.connect(advanceSlide)
	skip_button.pressed.connect(skipStory)

	# load story images as textures
	for path in STORY_IMG_PATHS:
		story_img_textures.append(load(path))

	# start with slide visibility modulated to 0
	story_slide.modulate = Color.TRANSPARENT

	# TODO: start background music
	# story_music.play()

	# show first slide
	showSlide()

func showSlide() -> void:
	var current_copy := STORY_COPY[story_index]
	story_text.visible_ratio = 0.0 # hide all the text initially, so it can be animated in after the fade up
	story_text.text = format_string % current_copy

	# swap in the image texture for current slide
	story_image.texture = story_img_textures[story_index]

	# fade in on current slide
	var fade_in_animation := create_tween()
	fade_in_animation.tween_property(story_slide, "modulate", Color.WHITE, FADE_DURATION_SEC)
	await fade_in_animation.finished

	var text_animation = create_tween()
	var text_animation_duration := 0.04 * current_copy.length()

	# animate visible_ratio to 1.0 over text_animation_duration seconds
	text_animation.tween_property(story_text, "visible_ratio", 1.0, text_animation_duration)

func advanceSlide() -> void:
	# fade out on the current slide
	var fade_out_animation := create_tween()
	fade_out_animation.tween_property(story_slide, "modulate", Color.TRANSPARENT, FADE_DURATION_SEC)

	await fade_out_animation.finished

	story_index += 1 # advance slide index
	if story_index >= STORY_COPY.size():
	# exit to main menu for now
		SceneManager.SwitchScene("MainMenu")
	else:
		showSlide()

func skipStory() -> void:
	# fade out on the current slide
	var fade_out_animation := create_tween()
	fade_out_animation.tween_property(story_slide, "modulate", Color.TRANSPARENT, FADE_DURATION_SEC)

	await fade_out_animation.finished
	
	SceneManager.SwitchScene("MainMenu")
