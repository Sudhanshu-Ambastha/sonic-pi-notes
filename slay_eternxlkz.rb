#Slay - Eternxlkz
use_bpm 60
set_volume! 5
use_synth :piano
use_synth_defaults release: 0.4, amp: 1.0

define :play_custom_step do |note_map, char, step_length|
  play note_map[char] if note_map.key?(char)
  sleep step_length
end

define :func do |note_map, base_pattern, repeats, step_length|
  total_steps = base_pattern.length * repeats
  total_duration = total_steps * step_length
  
  in_thread do
    base_pattern.chars.cycle(repeats) do |char|
      play_custom_step(note_map, char, step_length)
    end
    
    with_fx :reverb, room: 0.4 do
      synth :sine, note: :f2, sustain: 2.0, release: 0.5, amp: 0.3
    end
  end
  
  return total_duration
end

note_map = {
  "1" => :f3,
  "2" => :ab3,
  "3" => :g3,
  "4" => :bb3,
  "5" => :c4,
}

base_pattern = "12141312"
base_pattern2 = "12141315"
repeat = 3
step_length = 0.25

d = func(note_map, base_pattern, repeat, step_length)
sleep d
sleep 0.03

final_base_pattern=base_pattern+base_pattern2+base_pattern
repeat2 = 1
d = func(note_map, final_base_pattern, repeat2, step_length)
sleep d
sleep 0.03

final_base_pattern2=base_pattern+base_pattern2+base_pattern*3
d = func(note_map, final_base_pattern2, repeat2, step_length)
sleep d
sleep 0.03

note_map2 = {
  "1" => :f4,
  "2" => :ab4,
  "3" => :g4,
  "4" => :bb4,
  "5" => :c5,
}
final_base_patter3=base_pattern+base_pattern2+base_pattern*1+"1"
d = func(note_map2, final_base_patter3, repeat2, step_length)
sleep d
sleep 0.03