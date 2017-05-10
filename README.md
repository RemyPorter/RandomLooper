# Random Looper
I was inspired by [this video](https://www.youtube.com/watch?v=Fg9zHKSWPNQ), to build a synth that does something similar. I fired up Sonic-Pi and Processing 3 to take advantage of the OSC-features in Sonic-Pi.

## Usage
Load `looper.rb` in Sonic-Pi and run it. Load and run the `Controls` sketch in Processing 3 (the sketch depends on OscP5 and ControlP5). Use the radio buttons to switch between `Silence`, `Generation`, and `Loop`. `Loop` will play the last generated notes, up to `Window`. So, if `Window` is 8, the looped notes will be 8. `filter` is a band-pass filter (X controls the note, Y controls the res), and `echo` controls an echo filter.

More features and buttons to be added.

## Demo
<a href="https://www.youtube.com/embed/I-uKK9a9gPU">
<img src="https://i.ytimg.com/vi/I-uKK9a9gPU/hqdefault.jpg">
</a>