use_bpm 172

live_loop :drums do
  #stop
  3.times do
    sample :drum_heavy_kick, amp: 2
    sleep 1
    sample :drum_snare_soft, amp: 3
    sleep 1
  end
  
  sample :drum_heavy_kick, amp: 2
  sleep 0.5
  sample :drum_heavy_kick, amp: 3
  sleep 0.5
  sample :drum_snare_soft, amp: 3
  sleep 1
end

live_loop :hihat, sync: :drums do
  #stop
  sample :drum_cymbal_closed, amp: 0.3
  sleep 0.5
end

live_loop :keyboard_a, sync: :drums do
  #stop
  use_synth :blade
  use_synth_defaults amp: 1.5
  
  2.times do
    notes = [:f, :f,  :Ds,  :f, :g, :c, :Ds]
    times = [2, 1.5, 0.5, 0.5, 1,  1,   1.5]
    play_pattern_timed notes, times
  end
  
  2.times do
    notes = [:Bb, :g, :f, :Ds]
    times = [0.5,  1,  1,   1]
    play_pattern_timed notes, times
    sleep 0.5
  end
  play :f, sustain: 2
  sleep 4
end

live_loop :vocals_pre_chorus, sync: :drums do
  stop
  use_synth :chiplead
  
  with_fx :reverb do
    notes = [:Bb3, :c, :Bb3, :c, :Bb3]
    times = [0.5, 0.5, 0.5, 0.5, 1]
    play_pattern_timed notes, times
    
    3.times do
      notes = [:c, :Eb, :f, :g, :c, :eb, :f]
      times = [1, 0.5, 1, 1, 1, 1, 2]
      play_pattern_timed notes, times
    end
    
    notes = [:d, :c, :Bb3]
    times = [2, 2, 2]
    play_pattern_timed notes, times
  end
end