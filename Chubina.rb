#Chubina
use_bpm 60
set_volume! 3.5
synth :piano

use_synth_defaults release: 0.4, amp: 1.0

define :play_custom_step do |note, step_length|
  play note
  sleep step_length
end

define :func_variable_steps do |note_map, base_pattern, step_lengths, repeats|
  total_duration = step_lengths.reduce(:+) * repeats
  
  in_thread do
    repeats.times do
      base_pattern.chars.zip(step_lengths).each do |char, step_length|
        note = note_map[char]
        play_custom_step(note, step_length) if note
      end
    end
    
    with_fx :reverb, room: 0.4 do
      synth :sine, note: :f2, sustain: 2.0, release: 0.5, amp: 0.3
    end
  end
  
  return total_duration
end

note_map = {
  "1" => :e4,
  "2" => :b4,
  "3" => :a4,
  "4" => :g4,
  "5" => :fs4
}

base_pattern = "12343451"
step_lengths = [0.35,0.25,0.15,0.45,0.15,0.45,0.07,0.35]
repeat = 1
d = func_variable_steps(note_map, base_pattern, step_lengths, repeat)
sleep d
sleep 0.2

base_pattern = "112343451"
step_lengths = [0.15,0.15,0.15,0.15,0.45,0.25,0.45,0.07,0.15]
repeat = 1
d = func_variable_steps(note_map, base_pattern, step_lengths, repeat)
sleep d
sleep 0.2

base_pattern = "13434551"
step_lengths = [0.15,0.15,0.17,0.15,0.3,0.07,0.07,0.15]
repeat = 1
d = func_variable_steps(note_map, base_pattern, step_lengths, repeat)
sleep d
sleep 0.2

base_pattern = "13434551"
step_lengths = [0.15,0.15,0.17,0.15,0.17,0.07,0.07,0.15]
repeat = 1
d = func_variable_steps(note_map, base_pattern, step_lengths, repeat)
sleep d
sleep 0.2

note_map = {
  "1" => :a5,
  "2" => :b5,
  "3" => :c5,
  "4" => :d5,
  "5" => :g4
}
base_pattern = "24323215"
step_lengths = [0.17,0.15,0.1,0.13,0.1,0.2,0.1,0.2]
repeat = 1
d = func_variable_steps(note_map, base_pattern, step_lengths, repeat)
sleep d
sleep 0.2

base_pattern = "24323215"
step_lengths = [0.15,0.17,0.17,0.17,0.17,0.2,0.17,0.2]
repeat = 1
d = func_variable_steps(note_map, base_pattern, step_lengths, repeat)
sleep d
sleep 0.2

base_pattern = "23232115"
step_lengths = [0.17,0.13,0.2,0.15,0.2,0.13,0.13,0.17]
repeat = 1
d = func_variable_steps(note_map, base_pattern, step_lengths, repeat)
sleep d
sleep 0.2

base_pattern = "23232115"
step_lengths = [0.17,0.13,0.2,0.15,0.2,0.13,0.13,0.17]
repeat = 1
d = func_variable_steps(note_map, base_pattern, step_lengths, repeat)
sleep d
sleep 0.2