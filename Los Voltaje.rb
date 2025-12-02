#Los Voltaje
use_bpm 40
set_volume! 3.5
use_synth :piano
use_synth_defaults release: 0.4, amp: 1.0

define :play_variable_melody do |melody_map, melody_pattern, rhythms, repeats|
  seq = melody_pattern.chars.zip(rhythms)
  total = rhythms.sum * repeats
  
  in_thread do
    seq.cycle(repeats) do |char, dur|
      play melody_map[char] if melody_map.key?(char)
      sleep dur
    end
  end
  
  total
end

define :play_sustained_bass do |note, duration, amp|
  in_thread do
    with_fx :reverb, room: 0.4 do
      synth :sine, note: note, sustain: duration, release: 0.5, amp: amp
    end
  end
end
#part1:-
los_map = {
  "1" => :g2,
  "2" => :a3,
  "3" => :bb3,
  "4" => :c3,
  "5" => :d3,
  "6" => :f2,
}
#need to fix timing for 1st part based on music
#                  ,     , ,   ,    ,   , (add a comma just before the digit over it present)
los_melody = "15441321334215441543432321216"
rhythms = [1,0.15,0.15,0.3,0.4, #15441
           0.1,0.1,0.1,0.1,0.1,0.1, #321334
           0.4,1, #21
           0.2,0.2,0.2,0.1, #5441
           0.12,0.12,0.12,0.12,0.12, #54343
           0.15,0.15,0.15,0.15, #2321
           0.1,0.1,0.1] #216

d = play_variable_melody(los_map, los_melody, rhythms, 1)
sleep d
sleep 0.2

#part2:-
los_map2 = {
  "1" => :g1,
  "2" => :a2,
  "3" => :d2,
  "4" => :g2,
  "5" => :a3,
  "6" => :bb3
}
n1 = "132"
r1 = [0.20,0.20,0.20]
n2 = "654"
r2 =[0.10,0.10,0.10]
mel = n1+n2*2
rhy = r1+r2*2
fin_melody=mel*8+n2
fin_rhythm = (rhy * 8) + r2

repeat_count_2 = 1
melody_duration_2 = fin_rhythm.sum * repeat_count_2

play_sustained_bass(los_map2["4"], melody_duration_2, 0.4)

d2 = play_variable_melody(los_map2, fin_melody, fin_rhythm, repeat_count_2)
sleep d2
sleep 0.5