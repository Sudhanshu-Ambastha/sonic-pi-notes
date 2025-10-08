# Phantom of Opera - Sequenced and Corrected Structure
use_bpm 70
use_synth :piano
set_volume! 1.5

# --- 1. Custom Player Function ---
# Note: steps.length will be 25 (the length of the pattern strings)
define :custom_pattern_player do |note_map, pattern, opts={}|
  steps = pattern.gsub("|", "").chars
  step_length = opts[:step_length] || 0.25 # 1/16th note
  
  steps.each do |step|
    if note_map.key?(step)
      notes = note_map[step]
      play notes, amp: opts[:amp] || 1, release: 0.1
    end
    sleep step_length
  end
end

sixteenth_note_length = 60.0 / 60.0 / 4 # 0.25 seconds

# --- 2. UNIFIED NOTE MAPPING ---
# Key mapping is standardized to the note name and octave for clarity.
# Using lowercase for the lower octave notes and uppercase for higher ones.
note_map = {
  # Lower Notes (ch1, ch2, ch3, ch4, ch5)
  "D" => [:d4],  # ch1
  "C" => [:c4],  # ch2
  "B" => [:b3],  # ch3
  "A" => [:a3],  # ch4
  "G" => [:g3],  # ch5
  "F" => [:f4],  # ch6 (mid-range)
  
  # Higher Notes (ch7, ch8, ch9, ch10)
  "H" => [:a4],  # ch7 (Used H to avoid confusion with A3)
  "I" => [:g4],  # ch8 (Used I to avoid confusion with G3)
  "J" => [:c5],  # ch9 (Used J for C5)
  "K" => [:d5],  # ch10 (Used K for D5)
  
  # The original pattern uses a mix of case, so we must map those too:
  "b" => [:b3],  # From piano_loop_7
}


# --- 3. SEQUENTIAL SONG LOOP ---
live_loop :phantom_sequence do
  
  # Bar 1 (from piano_loop)
  custom_pattern_player note_map,
    "D-----------------------D-", # D4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 2 (from piano_loop_2)
  custom_pattern_player note_map,
    "D-C-C-B-------------------", # D4, C4, B3
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 3 (from piano_loop_3)
  custom_pattern_player note_map,
    "----B-C-C-D-D-------------", # B3, C4, D4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 4 (from piano_loop_4)
  custom_pattern_player note_map,
    "----------D-D-C-C-B-------", # D4, C4, B3
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 5 (from piano_loop_5)
  custom_pattern_player note_map,
    "----------------B-C-C-D-D-", # B3, C4, D4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 6 (from piano_loop_6)
  custom_pattern_player note_map,
    "------------------A---D---", # A3, D4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 7 (from piano_loop_7)
  custom_pattern_player note_map,
    "A---C-----b-b-----------G-", # A3, C4, B3, G3
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 8 (from piano_loop_8)
  custom_pattern_player note_map,
    "--C-----G-A---------------", # C4, G3, A3
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 9 (from piano_loop_9)
  custom_pattern_player note_map,
    "----A---D---A---C-----B-B-", # A3, D4, C4, B3
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 10 (from piano_loop_10)
  custom_pattern_player note_map,
    "----------G---C-----G-A---", # G3, C4, A3
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 11 (from piano_loop_11)
  custom_pattern_player note_map,
    "----------------A---D---F-", # A3, D4, F4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 12 (from piano_loop_12) - Swapped A/G for H/I (A4/G4)
  custom_pattern_player note_map,
    "--H-----I-I-----------I---", # A4, G4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 13 (from piano_loop_13) - Swapped A/G/c for H/I/J (A4/G4/C5)
  custom_pattern_player note_map,
    "J-----I-H----------------", # C5, G4, A4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 14 (from piano_loop_14) - Swapped A/D for H/K (A4/D5)
  custom_pattern_player note_map,
    "------H---K---------------", # A4, D5
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 15 (from piano_loop_15) - Swapped A/C/D/G for H/J/K/I (A4/C5/D5/G4)
  custom_pattern_player note_map,
    "--K-J-J-H-H-I-I---------", # D5, C5, A4, G4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 16 (from piano_loop_16) - Swapped D/F for K/F (D5/F4)
  custom_pattern_player note_map,
    "----------F---F-----K-K---", # F4, D5
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 17 (from piano_loop_17) - Swapped D/C for K/C (D5/C4)
  custom_pattern_player note_map,
    "--------------------K-K-C-", # D5, C4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 18 (from piano_loop_18)
  custom_pattern_player note_map,
    "C-B-----------------------", # C4, B3
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 19 (from piano_loop_19)
  custom_pattern_player note_map,
    "B-C-C-D-D-----------------", # B3, C4, D4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 20 (from piano_loop_20)
  custom_pattern_player note_map,
    "------D-D-C-C-B-----------", # D4, C4, B3
    step_length: sixteenth_note_length, amp: 1.2
  
  # Bar 21 (from piano_loop_21)
  custom_pattern_player note_map,
    "------------B-C-C-D-------", # B3, C4, D4
    step_length: sixteenth_note_length, amp: 1.2
  
  # Stop the loop after the sequence finishes
  stop
end