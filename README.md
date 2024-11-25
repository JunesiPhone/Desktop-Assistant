# Desktop Assistant
Overlay that grabs audio and displays a character on the desktop with transparency.

# Support
[Patreon](https://patreon.com/junesiphone)

# Info
This is a Godot project you need Godot to run. I will upload an exe eventually. Just got this poc working.
My knowledge of Godot is 4 days old, but I think i'm getting the hang of it.

# Overview
This project takes audio and converts it to a character that seems to speak what is played.
My usage is I have a local AI ran that speaks it's replies. I wanted to add the speech to a character.

There is many ways of doing this, but they require a lot. Example you can use VTuberStudio to display 
a character, use an addon that forwards audio to the Vtuber. While this is very good it reqires running 
multiple applications. I wanted something lightweight and something that could be displayed on the desktop
with transparency.

Since this is a game engine it can be highly extended to add things like skeleton, bones, animations, etc.
Right now it's basic. I was able to get audio piped in, convert audio into syllables and vowels, then map
those to display a mouth image of that sound. 


# Setup
[VoiceMeter Virtual Audio Device](https://vb-audio.com/Cable/) - brings desktop audio to an output

[VoiceMeter Banana](https://vb-audio.com/Voicemeeter/banana.htm) - used to map sound inputs and outputs

[Godot 4.3](https://godotengine.org/) - runs this project

## Setup VoiceMeter Virtual Audio Device
Install

Set your windows sound output to CABLE In 16ch

Set your windows sound input (mic) to CABLE Output

## Setup VoiceMeter Banana
Install

Set Stereo Input 1 to CABLE Output

Set A1 to whatever speakers you want your sounds to play through. Bascially whatever your Windows output
device was.

# Setup Godot Project
git clone this project or download it

open the project.godot

press play

play some audio

# Extendability
This is a Godot project. You can change out the images, add a full rigged character, add animations, etc. 
I thought about adding a way to tap on the character to send messages. Which would then forward to a local
LLM or API, but I feel like a lot of people already have their LLM setup. What they don't have is a character
that is live on their desktop, so this achieves that for now. I will attempt to add a skeleton to this model.
To give it more life. A simple blink animation as well, but as I mentioned i've only messed with Godot for 4 days. 

# Credits
Character model was generated on [Charat](https://charat.me/genesis/)
I created the mouth images with help from [Devon](https://www.youtube.com/watch?v=h7U2YvmIMOo)
Understanding Godot Audio Analyzer [FencerDevLog](https://www.youtube.com/watch?v=2LHljiWIx3w)
Audio Analysis [LewdGarlic](https://www.youtube.com/watch?v=2vMiZoIy2NQ)
