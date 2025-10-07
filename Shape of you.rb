use_bpm 96

ch1 = [:cs5, :ab4, :cs4]
ch2 = [:e5, :ab4, :cs4]
ch3 = [:cs5, :Ab4, :cs4]
ch4 = [:cs5, :a4, :fs3]
ch5 = [:e5, :a4, :fs3]
ch6 = [:cs5, :a4, :fs3]
ch7 = [:cs5, :a4, :a3]
ch8 = [:e5, :a4, :a3]
ch9 = [:cs5, :a4, :a3]
ch10 = [:Eb5, :fs4, :b3]
ch11 = [:cs5, :fs4, :b3]
ch12 = [:b4, :fs4, :b3]

notes = [ch1, [], ch2, [], ch3, [], ch4, [], ch5, [], ch6, [],
         ch7, [], ch8, [], ch9, [], ch10, [], ch11, [], ch12, []]
times = [0.25,0.5, 0.25, 0.5, 0.25, 0.25]

in_thread do
  22. times do
    use_synth :beep
    with_synth_defaults amp: 0.9, sustain_level: 0.75, release: 0.5 do
      with_fx :reverb, room: 0.3 do
        with_fx :rlpf, cutoff: 100, res: 0.8 do
          play_pattern_timed notes, times
        end
      end
    end
  end
end

in_thread do
  use_synth :piano
  with_synth_defaults amp: 0.2, sustain_level: 0.7, release: 0.4 do
    at 8 do
      20.times do
        with_fx :reverb, room: 0.3 do
          play_pattern_timed [:cs4, :cs4, :cs4], [0.75, 0.75, 0.5]
          play_pattern_timed [:fs3, :fs3, :fs3], [0.75, 0.75, 0.5]
          play_pattern_timed [:a3, :a3, :a3], [0.75, 0.75, 0.5]
          play_pattern_timed [:b3, :b3, :b3], [0.75, 0.75, 0.5]
        end
      end
    end
  end
end

notes2 = [:e4, :e4, :e4, :e4, :e4, :e4, :e4, :e4, :e4, :e4, :e4, :e4, :e4, :gs4, :fs4, :e4, :cs4]
times2 = [0.5, 0.25, 0.25, 0.25, 0.75, 0.5, 0.25,
          0.25, 0.25, 0.75, 0.5, 0.5, 0.25, 0.5]

in_thread do
  use_synth :pretty_bell
  with_fx :reverb, room: 0.3 do
    with_fx :rlpf, cutoff: 100, res: 0.8 do
      at 16 do
        play_pattern_timed notes2, times2,
          amp: 0.3, release: 0.5, sustain_level: 0.75
      end
    end
  end
end

notes3 = [:gs4, :fs4, :fs4, :fs4, :fs4, :fs4, :fs4, :fs4, :fs4,
          :fs4, :fs4, :fs4, :fs4, :fs4, :fs4, :fs4, :gs4, :fs4, :e4, :cs4]
times3 = [0.5, 0.5, 0.25, 0.5, 0.25, 0.5, 0.5, 0.25,
          0.25, 0.5, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25]

in_thread do
  use_synth :piano
  with_fx :reverb, room: 0.3 do
    at 24 do
      play_pattern_timed notes3, times3,
        amp: 0.6, release: 0.3, sustain_level: 0.75
    end
  end
end

notes4 = [:cs5, :gs5, :gs5, :gs5, :gs5, :gs5, :gs5, :gs5, :gs5,:gs5, :gs5, :b5, :gs5, :fs5, :e5, :gs5]
notes4_1 = [:cs4, :gs4, :gs4, :gs4, :gs4, :gs4, :gs4, :gs4, :gs4, :gs4, :gs4, :b4, :gs4, :fs4, :e4, :gs4]
times4 = [0.5, 0.25, 0.25, 0.25, 0.75, 0.5, 0.25, 0.25, 0.25, 0.75, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25]

in_thread do
  use_synth :piano
  with_fx :reverb, room: 0.3 do
    at 32 do
      play_pattern_timed notes4_1, times4,
        amp: 0.5, release: 0.5, sustain_level: 0.5
    end
  end
  use_synth :beep
  with_fx :reverb, room: 0.3 do
    at 32 do
      play_pattern_timed notes4, times4,
        amp: 0.4, release: 0.2, sustain_level: 0.75
    end
  end
end

notes5 = [:gs4, :fs4, :e4, :cs4, :gs4, :gs4, :cs4, :cs4, :gs4, :gs4, :fs4, :fs4, :gs4, :fs4, :fs4, :e4, :cs4]
times5 = [0.5, 0.25, 0.25, 0.75, 0.5, 0.75, 0.25, 0.5, 0.5, 0.75, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25]
in_thread do
  use_synth :pretty_bell
  with_fx :reverb, room: 0.3 do
    at 40 do
      play_pattern_timed notes5, times5,
        amp: 0.3, release: 0.3, sustain_level: 0.75
    end
  end
end

notes6 = [:b3, :cs4, :cs4, :b3, :cs4, :gs4, :fs4, :fs4, :fs4, :gs4, :fs4, :e4, :fs4, :fs4, :gs4, :fs4, :e4, :cs4]
times6 = [0.5, 0.75, 0.75, 0.5, 0.5, 0.5, 1, 0.25, 0.5, 0.25, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5]
in_thread do
  use_synth :piano
  with_fx :reverb, room: 0.3 do
    at 48 do
      play_pattern_timed notes6, times6,
        amp: 0.9, release: 0.3, sustain_level: 0.75
    end
  end
end

notes7 = [:b4, :gs4, :fs4, :gs4, :fs4, :e4, :gs4, :fs4, :fs4, :gs4, :fs4, :e4, :fs4, :e4, :cs4]
times7 = [0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 1, 0.25, 0.5, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
in_thread do
  use_synth :pretty_bell
  with_fx :reverb, room: 0.5 do
    at 56 do
      play_pattern_timed notes7, times7,
        amp: 0.9, release: 0.2, sustain_level: 0.75
    end
  end
end

notes8 = [:e4, :fs4, :gs4, :fs4, :e4, :e4, :fs4, :fs4, :e4, :fs4, :gs4, :fs4, :e4, :e4, :fs4, :cs4]
times8 = [0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.5, 1.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.5]
in_thread do
  use_synth :piano
  with_fx :reverb, room: 0.5 do
    at 64 do
      play_pattern_timed notes8, times8,
        amp: 0.9, release: 0.2, sustain_level: 0.75
    end
  end
end

notes9 = [:gs4, :gs4, :b4, :fs4, :e4, :fs4, :e4, :fs4,:gs4, :fs4, :e4, :fs4, :cs4, :cs4, :cs4,
          :cs4, :e4, :fs4, :e4, :cs4, :e4, :fs4, :fs4, :e4, :fs4, :gs4, :fs4, :e4, :e4, :fs4, :cs4]
times9 = [0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 1.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25,
          0.25, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 1.5, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25]
in_thread do
  use_synth :piano
  with_fx :reverb, room: 0.5 do
    at 72 do
      play_pattern_timed notes9, times9,
        amp: 0.9, release: 0.2, sustain_level: 0.75
    end
  end
end