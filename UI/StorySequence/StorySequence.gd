extends Control

@onready var story_slide: Control = %StorySlide
@onready var story_text: RichTextLabel = %StoryText
@onready var story_image: TextureRect = %StoryImage
@onready var skip_button: Button = %SkipButton
@onready var story_music: AudioStreamPlayer = %StoryMusic

const FADE_DURATION_SEC := 1.0
const STORY_COPY : Array[String] = [
  "Once upon a time, this was the copy for the first slide of the story sequence.",
  "Then came the copy for the second slide of the story sequence. It contained [b]two[/b] sentences. Probably?",
  "Ultimately, the copy for slide 3 of the story sequence appeared. Since this was the final slide, it probably had some kind of call to action - something that told the player to strap in and prepare for adventure!",
]
const STORY_IMG_PATHS : Array[String] = [
  "res://UI/StorySequence/assets/test_01.png",
  "res://UI/StorySequence/assets/test_02.png",
  "res://UI/StorySequence/assets/test_03.png",
]
var story_img_textures : Array[Texture2D] = []

var story_index := 0

func _ready():
  skip_button.pressed.connect(advanceSlide)

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
  story_text.text = current_copy

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



  
  
