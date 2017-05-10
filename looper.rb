path = "/rand/"

window = 8
notes = Array.new(window, 0)
mode = :silence
resttime = 0.25
patt = spread(4,4)

synthdef = Proc.new do
  use_synth :mod_fm
  use_synth_defaults mod_phase: 0.0125,mod_wave:0, mod_range: 3, cutoff: 70
end
with_fx :echo do |echo|
  with_fx :bpf do |bpf|
    uncomment do
      live_loop :generate do
        if mode == :gen
          synthdef.call
          note = rrand(1,127)
          play note
          notes.push note
          notes.shift
          puts notes
        end
        sleep resttime
      end
      
      live_loop :play_capture do
        if mode == :loop and patt.tick
          synthdef.call
          puts notes
          r = (ring *notes)
          play r.tick
        end
        sleep resttime
      end
    end
    
    live_loop :filter do
      msg = sync path + "bpf"
      x,y = msg
      control bpf, centre: x, res: y
    end
    
    live_loop :echo do
      msg = sync path + "echo"
      rate,decay = msg
      control echo, phase: rate, decay: decay
    end
    
    live_loop :modechange do
      msg = sync path + "change"
      puts msg
      mode = case msg[0]
      when 1
        :loop
      when 0
        :silence
      else
        :gen
      end
      puts mode
    end
    
    live_loop :window do
      msg = sync path + "windowsize"
      window = msg[0]
      if window <= notes.length
        notes = notes.take(window)
      else
        notes = notes + Array.new(window - notes.length, 0)
      end
    end
    
    live_loop :speed do
      msg = sync path + "speed"
      if msg[0]
        resttime = msg[0]
      end
    end
    
    live_loop :rthm do
      msg = sync path +"rthm"
      if msg[0]
        patt = msg[0]
      end
    end
    
    live_loop :voice do
      msg = sync path + "voice"
      puts msg
      case msg[0]
      when 0
        synthdef = Proc.new do
          use_synth :sine
          use_synth_defaults attack: 0.1, release: 2
        end
      else
        synthdef = Proc.new do
          use_synth :mod_fm
          use_synth_defaults mod_phase: 0.0125,mod_wave:0, mod_range: 3, cutoff: 70
        end
      end
    end
  end
end

