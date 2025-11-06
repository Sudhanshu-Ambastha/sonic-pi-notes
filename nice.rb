use_bpm 150
set_volume! 0.7 

live_loop :structure do
  cue :start_phrase
  sleep 16
end

live_loop :pure_bass do
  use_synth :sine 
  with_fx :lpf, cutoff: 80 do
    play :C2, attack: 0, sustain: 0.5, release: 0.1, amp: 0.8
    sleep 1.0
    play :Eb2, attack: 0, sustain: 0.5, release: 0.1, amp: 0.8
    sleep 1.0
  end
end

live_loop :drums do
  sync :start_phrase
  8.times do 
    sample :bd_haus, amp: 1.0
    sleep 0.5
    sample :sn_dolf, amp: 0.7
    sleep 0.5
  end
  
  8.times do
    sample :bd_haus, amp: 1.2
    sleep 0.25
    sample :drum_cymbal_closed, rate: 2, amp: 0.4
    sleep 0.25
    sample :sn_dolf, amp: 0.8
    sleep 0.25
    sample :drum_cymbal_closed, rate: 2, amp: 0.4
    sleep 0.25
  end
end

live_loop :prophet_arp do
  sync :start_phrase
  8.times do 
    use_synth :prophet
    play_pattern_timed chord(:C4, :minor), 0.25, amp: 0.5, release: 0.05
  end
  
  8.times do 
    play_pattern_timed chord(:C4, :minor), 0.125, amp: 0.6, release: 0.05
  end
end

live_loop :saw_lead do
  sync :start_phrase
  
  sleep 8 
  
  with_fx :reverb, room: 0.8, mix: 0.9 do
    play :G5, attack: 0.2, sustain: 1.0, release: 0.5, amp: 0.8
    sleep 1.75
    play :Bb5, attack: 0.2, sustain: 0.5, release: 0.5, amp: 0.8
    sleep 1.25
    play :C6, attack: 0.2, sustain: 0.5, release: 0.5, amp: 0.8
    sleep 1.0
    sleep 4
  end
end

live_loop :hollow_pad do
  sync :start_phrase
  
  8.times do 
    play :C5, attack: 0.2, sustain: 1.0, release: 0.0, amp: 0.5
    sleep 2
    play :G4, attack: 0.2, sustain: 1.0, release: 0.0, amp: 0.5
    sleep 2
  end
  
  sleep 8 
end