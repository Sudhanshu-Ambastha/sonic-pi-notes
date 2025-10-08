#Talking to the Moon by Bruno Mars(https://pianoletternotes.blogspot.com/2021/03/talking-to-moon-by-bruno-mars.html)
use_bpm 60
use_synth :piano

define :custom_pattern_player do |note_map, pattern, opts={}|
  steps = pattern.gsub("|", "").chars
  step_length = opts[:step_length] || 0.25
  
  steps.each do |step|
    if note_map.key?(step)
      notes = note_map[step]
      play notes, amp: opts[:amp] || 1, release: 0.1
    end
    sleep step_length
  end
end

#RH:4|e-----e-----e-----e-----e-|
#RH:4|G-----G-----G-----G-----G-|
#RH:3|---b-----b-----b-----b----|
#LH:3|e-----------------------e-|
#LH:2|e-----------------------e-|
# Calculate 16th note length based on 90 BPM
sixteenth_note_length = 60.0 / 90.0 / 4
ch1 = [:e4, :g4, :e3, :e2]
ch2 = [:b3]
live_loop :piano_loop do
  note_to_play = {
    "x" => ch1,
    "y" => ch2
  }
  
  custom_pattern_player note_to_play,
    "x---y---x---y---x---y---x---y---",
    step_length: sixteenth_note_length,
    amp: 1.2
end

#RH:4|----e-----e-----e-----e---|
#RH:4|----G-----G-----G-----G---|
#RH:3|-b-----b-----b-----b-----b|
#LH:2|----------------------G--e|
#LH:2|----------------------b---|
ch1 = [:e4, :G4]
ch2 = [:b3]
ch3 = [:e4, :G4, :G2, :b2]
ch4 = [:b3, :e2]
live_loop :piano_loop_2 do
  notes_to_play = {
    "a" => ch1,
    "b" => ch2,
    "c" => ch3,
    "d" => ch4
  }
  custom_pattern_player notes_to_play,
    "-b--a--b--a--b--a--b--c--d",
    step_length: sixteenth_note_length,
    amp: 1.2
end

#RH:4|-De-De-De--G--------D-D--D|
#LH:3|--------------------c-----|
#LH:3|--------------------D-----|
#LH:2|--G--e--G--e--G--e-----G--|
#LH:2|--b-----b-----b-----------|
ch1 = [:D4]
ch1_2 = [:e4, :G2, :b2]
ch1_3 = [:e4, :e2]
ch1_4 = [:G4, :e2]
ch2 = [:G2, :b2]
ch2_1 = [:e2]
ch3 = [:D4, :c3, :D3]
ch3_2 = [:G2]
live_loop :piano_loop_3 do
  notes_to_play = {
    "a" => ch1,
    "b" => ch1_2,
    "c" => ch1_3,
    "d" => ch1_4,
    "e" => ch2,
    "f" => ch2_1,
    "g" => ch3,
    "h" => ch3_2
  }
  custom_pattern_player notes_to_play,
    "-ab-ac-ab--d--e--f--g-ah-a",
    step_length: sixteenth_note_length,
    amp: 1.2
end

