use_bpm 60
use_synth :piano
set_volume! 4

eighth_note_length = 0.5
six_eighths_length = 3.0
ten_eighths_length = 5.0
sixteenth_note_length = 0.25

define :custom_pattern_player do |note_map, pattern, opts={}|
  steps = pattern.gsub("|", "").chars
  step_length = opts[:step_length] || sixteenth_note_length
  release_time = opts[:release] || 0.1
  
  steps.each do |step|
    if note_map.key?(step)
      notes = note_map[step]
      play notes, amp: opts[:amp] || 1, release: release_time
    end
    sleep step_length
  end
end

a = [:gs5,:e5,:cs5,:cs4]
b = [:e5,:cs5,:a4,:a3]
c = [:b4,:gs4,:e4,:e3]
d = [:fs5,:ds5,:b4,:b3]
e = [:e5,:cs5,:a4,:a3]

define :chords_progression do
  live_loop :chord_player_loop do
    
    play a, release: ten_eighths_length, amp: 0.8
    sleep ten_eighths_length
    
    play b, release: six_eighths_length, amp: 0.8
    sleep six_eighths_length
    
    play c, release: ten_eighths_length, amp: 0.8
    sleep ten_eighths_length
    
    play d, release: six_eighths_length, amp: 0.8
    sleep six_eighths_length
    
    play a, release: ten_eighths_length, amp: 0.8
    sleep ten_eighths_length
    
    play e, release: six_eighths_length, amp: 0.8
    sleep six_eighths_length
    
    play c, release: ten_eighths_length, amp: 0.8
    sleep ten_eighths_length
    
    play d, release: six_eighths_length, amp: 0.8
    sleep six_eighths_length
    
  end
end

define :melody do
  live_loop :melody_player_loop do
    note_to_play = {
      "x" => :gs7, "y" => :e7, "a" => :ds7, "b" => :bs6, "z" => :cs7, "-" => nil
    }
    
    pattern_string = "xx--xxyyxx-y-zxx--xxyyxx-a-zxx--xxyyxx-y-zxx--xxyyxx-b-z"
    
    custom_pattern_player note_to_play,
      pattern_string,
      step_length: sixteenth_note_length,
      amp: 1.2
    sleep 0.1
  end
end

chords_progression()
melody()