use_bpm 120
use_synth :piano
set_volume! 1.2

live_loop :main_rhythm do
  
  in_thread do
    play :E4, amp: 0.7, sustain: 7.9, release: 0.1
  end
  
  8.times do
    play [:C5, :B4], amp: 1.0, release: 0.9
    sleep 1
    
    play :A4, amp: 0.9, release: 0.9
    sleep 1
  end
end

live_loop :e5_melody, sync: :main_rhythm do
  
  4.times do
    sleep 1.5
    play :E5, amp: 1.1, release: 0.2
    sleep 0.5
  end
end


live_loop :counter_melody, sync: :main_rhythm do
  
  4.times do
    play :E6, amp: 1.3, release: 0.1
    sleep 0.25
    
    play :B5, amp: 1.1, release: 0.1
    sleep 0.25
    
    play :C6, amp: 1.2, release: 0.1
    sleep 0.25
    
    play :B5, amp: 1.1, release: 0.1
    sleep 0.25
  end
  
  sleep 4
end