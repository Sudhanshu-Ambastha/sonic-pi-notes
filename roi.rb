#ROI - VideoClub
use_bpm 72
use_synth :piano

define :l4 do |n|
  4.times do
    play n
    sleep 0.5
  end
end

define :intro do
  2.times do
    l4 :a4
    l4 :db4
    l4 :fs3
    l4 :e3
  end
end

define :mid do |sustain_note, melody_start_note|
  in_thread do
    play sustain_note, sustain: 2.5, release: 0.5, amp: 0.7
  end
  
  if melody_start_note != :nil
    in_thread do
      play melody_start_note, sustain: 0.2, release: 0.1
      sleep 0.5
      play :b5, sustain: 0.1, release: 0.1
      sleep 0.5
      play :db6, sustain: 0.1, release: 0.1
      sleep 0.5
      play :b5, sustain: 0.1, release: 0.1
      sleep 0.5
    end
  end
  
  sleep 2
end

define :mid2 do |sustain_note, melody_start_note|
  in_thread do
    play sustain_note, sustain: 2.5, release: 0.5, amp: 0.7
  end
  
  if melody_start_note != :nil
    in_thread do
      play melody_start_note, sustain: 0.2, release: 0.1
      sleep 0.5
      play :db6, sustain: 0.1, release: 0.1
      sleep 0.5
      play :b5, sustain: 0.1, release: 0.1
      sleep 0.5
      play :db6, sustain: 0.1, release: 0.1
      sleep 0.5
      play :b5, sustain: 0.1, release: 0.1
      sleep 0.5
    end
  end
  
  sleep 2
end

define :main do
  intro
  mid :a4, :nil
  live_loop :loop do
    mid :db4, :ab5
    mid2 :fs3, :a5
    mid :e3, :ab5
    mid :a4, :a5
  end
end

main