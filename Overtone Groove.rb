use_bpm 90

define :custom_synth_play do |note_name, duration, custom_amp=0.15|
  use_synth :dsaw
  play note_name,
    attack: 0.001,
    decay: 0.4,
    sustain: 0.5,
    release: 0.1,
    cutoff: 60,
    amp: custom_amp
  sleep duration
end

define :c_major_note do |offset|
  c_major = scale(:c4, :major, num_octaves: 2)
  return c_major[offset]
end

live_loop :melody do
  durations = [1, 0.5, 0.5, 1, 1, 2, 2].ring
  offsets = [0, 1, 0, 2, 4, 1, 2].ring
  
  durations.size.times do
    pitch = c_major_note(offsets.tick)
    custom_synth_play(pitch, durations.look)
  end
end

live_loop :harmony, sync: :melody do
  durations = [1, 0.5, 0.5, 1, 1, 0.5, 0.5, 0.5, 0.5, 2].ring
  offsets = [4, 4, 5, 4, 7, 6, 7, 6, 5, 4].ring
  
  durations.size.times do
    pitch = c_major_note(offsets.tick)
    custom_synth_play(pitch, durations.look, 0.2)
  end
end

live_loop :bass, sync: :melody do
  durations = [3, 0.75, 0.25].ring
  pitches = [46, 47, 48, 49, 48, 47].ring
  
  use_synth :fm
  use_synth_defaults release: 0.5, amp: 0.6
  
  6.times do
    pitch = pitches.tick
    dur = durations.tick
    
    with_fx :lpf, cutoff: 80 do
      play pitch, attack: 0.05, release: dur * 0.9
    end
    sleep dur
  end
end

live_loop :beat, sync: :melody do
  samples = [:bd_haus, :drum_cymbal_closed, :bd_haus, :bd_haus, :drum_cymbal_closed].ring
  durations = [1, 0.5, 0.5, 1, 1].ring
  
  10.times do
    sample_name = samples.tick
    duration = durations.look
    
    amp = (sample_name == :bd_haus) ? 1.5 : 0.8
    
    sample sample_name, amp: amp
    sleep duration
  end
end