import re
import os
import json # Used internally to create stable hashable keys for comparison

# --- CONFIGURATION ---
INPUT_FILE_NAME = "blue.txt" 
OUTPUT_FILE_EXTENSION = ".rb"
# Using a limited set of chars for mapping chords/notes within a block
CHORD_MAPPING_CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

# --- NOTE TRANSLATION ---
# Converts a single character to the corresponding Sonic Pi symbol.
NOTE_MAP = {
    'a': 'a', 'b': 'b', 'c': 'c', 'd': 'd', 'e': 'e', 'f': 'f', 'g': 'g',
    'A': 'as', 'C': 'cs', 'D': 'ds', 'F': 'fs', 'G': 'gs',
}

def get_note_symbol(char, octave):
    """Converts a note character and octave to a Sonic Pi symbol (e.g., 'e', 4 -> ':e4')."""
    base_note = NOTE_MAP.get(char)
    if base_note:
        return f":{base_note}{octave}"
    return None

def parse_tabs_to_section_patterns(file_content):
    """
    Parses multi-track tabs, detects repetition, and ensures modularity with map reuse.
    """
    
    # 1. Get Global Metadata (BPM, Volume)
    bpm = 60
    # 1) Set volume to 2.5 as requested
    volume = 2.5 
    
    bpm_match = re.search(r'use_bpm\s*(\d+)|(\d+)\s*bpm', file_content, re.IGNORECASE)
    if bpm_match:
        bpm = int(bpm_match.group(1) or bpm_match.group(2))
    
    volume_match = re.search(r'set_volume!\s*(\d+\.?\d*)', file_content)
    # Only override volume if explicitly set in the file (otherwise use requested 2.5)
    if volume_match:
        volume = float(volume_match[1]) 

    # 2. Split content into sections based on simple numbers on a line (e.g., '\n1\n')
    content_blocks = re.split(r'^\s*\d+\s*$', file_content.strip(), flags=re.MULTILINE)
    
    final_sequence = []
    
    # This dictionary stores unique sections identified by their track content string
    # {track_content_hash: section_data}
    unique_sections_map = {}
    
    # This list stores the order in which unique sections were created
    unique_section_creation_order = [] 

    # 3. Process each block in the input order
    for i, block_content in enumerate(content_blocks):
        block_content = block_content.strip()
        if not block_content:
            continue

        input_section_name = f"SECTION_{i}" 
        tracks = []
        raw_track_content = [] # Store raw content for comparison/hashing

        # 3.1. Extract tracks within the current block
        for line in block_content.split('\n'):
            match = re.match(r'(LH|RH):(\d)\|(.+)', line.strip())
            if match:
                track_content = match[3].replace('|', '').replace(' ', '')
                tracks.append({
                    'octave': int(match[2]),
                    'pattern': track_content
                })
                # Use raw track content for hash (comparison)
                raw_track_content.append(f"{match[1]}:{match[2]}|{track_content}") 

        if not tracks:
            continue

        # Create a unique hash/key for this block's track content
        # 2) Check for repetition against previously identified unique sections
        track_content_hash = json.dumps(raw_track_content, sort_keys=True)
        
        if track_content_hash in unique_sections_map:
            # REPETITION DETECTED: Reuse the existing map and pattern
            reused_section = unique_sections_map[track_content_hash]
            
            final_sequence.append({
                'name': input_section_name, # Use the current name in the sequence
                'is_repeat': True,
                'map_name': reused_section['map_name'], # Use the original map name
                'pattern': reused_section['pattern'],
                'note_map': {} # No map needed for repeats
            })
            continue 

        # NOT A REPEAT: Generate a new map and pattern
        
        map_name = f"NOTE_MAP_UNIQUE_{len(unique_sections_map)}"
        
        max_length = max(len(t['pattern']) for t in tracks)
        new_pattern = []
        chord_to_char_map = {} 
        char_counter = 0

        # Generate the pattern and the local map for this section
        for j in range(max_length):
            current_notes = []
            for track in tracks:
                char = track['pattern'][j] if j < len(track['pattern']) else None
                if char and char not in ('-', '—'):
                    note = get_note_symbol(char, track['octave'])
                    if note:
                        current_notes.append(note)
            
            if not current_notes:
                new_pattern.append('-')
            else:
                current_notes.sort()
                # Create Ruby list string: e.g., ":e4, :g4, :c5"
                chord_key_ruby_format = ", ".join(current_notes)

                if chord_key_ruby_format not in chord_to_char_map:
                    if char_counter < len(CHORD_MAPPING_CHARS):
                        new_char = CHORD_MAPPING_CHARS[char_counter]
                        chord_to_char_map[chord_key_ruby_format] = new_char
                        char_counter += 1
                    else:
                        print(f"Error: Ran out of unique characters for chord mapping in section {input_section_name}!")
                        new_pattern.append('?') 
                        continue
                
                new_pattern.append(chord_to_char_map[chord_key_ruby_format])
        
        # Convert local map to Sonic Pi format
        sonic_pi_note_map = {
            v: k # k is already ":e4, :g4, :c5"
            for k, v in chord_to_char_map.items()
        }
        
        # Store the unique section data
        unique_section_data = {
            'map_name': map_name,
            'pattern': "".join(new_pattern),
            'note_map': sonic_pi_note_map
        }
        unique_sections_map[track_content_hash] = unique_section_data
        unique_section_creation_order.append(unique_section_data)

        # Add to final sequence (this is the original creation instance)
        final_sequence.append({
            'name': input_section_name,
            'is_repeat': False,
            'map_name': map_name,
            'pattern': unique_section_data['pattern'],
            'note_map': unique_section_data['note_map']
        })

    return bpm, volume, final_sequence, unique_section_creation_order

def generate_ruby_file(bpm, volume, final_sequence, unique_sections, output_file_path):
    """Generates the final modular Sonic Pi Ruby code file."""
    
    ruby_code = f"""# Generated by tab_parser.py
# Source file: {os.path.basename(output_file_path).replace(OUTPUT_FILE_EXTENSION, '.txt')}
#
# Note: Sections that are exact repetitions of previous sections now reuse the same NOTE MAP and pattern, 
# achieving the requested function reusability.
#
# --- 1. CONFIGURATION ---
use_bpm {bpm}
use_synth :piano
set_volume! {volume}
use_synth_defaults release: 0.4, amp: 1.0

# Calculate 1/16th note length based on BPM (assuming this is the base rhythmic unit)
base_step_length = 60.0 / {bpm}.0 / 4 

# --- 2. CUSTOM PLAYER FUNCTIONS ---

# Function to play a single step (note or chord)
define :play_custom_step do |note_map, char, step_length|
  # The value is a string of notes, e.g., ":c4, :e4, :g4"
  notes_string = note_map[char]
  
  if notes_string.is_a?(String)
    # Convert the string to a Ruby array of symbols.
    # This robust way ensures symbols are correctly interpreted by Sonic Pi's play function.
    notes_array = notes_string.split(',').map {{ |n| n.strip.to_sym }}
    play notes_array, release: 0.1, amp: 1.0
  end
  
  sleep step_length
end

# Function to play a complete section pattern (The "d1()" style call)
define :play_section_pattern do |note_map, pattern_string, repeats, step_length, section_name|
  
  puts "Playing Section: #{{section_name}}"
  
  total_steps = pattern_string.length * repeats
  total_duration = total_steps * step_length
  
  # Play the pattern in a new thread
  in_thread do
    pattern_string.chars.cycle(repeats) do |char|
      play_custom_step(note_map, char, step_length)
    end
    # Add a simple synth background for effect
    with_fx :reverb, room: 0.4 do
      synth :sine, note: :f2, sustain: total_duration * 0.5, release: total_duration * 0.5, amp: 0.3
    end
  end
  
  return total_duration
end

# --- 3. NOTE MAP DEFINITIONS (One map per unique musical block) ---
"""
    
    # Define the unique map for each section that was not a repeat
    for section in unique_sections:
        map_lines = []
        map_name = section['map_name']
        
        # Build the map content
        for char, notes in section['note_map'].items():
            # 'notes' is a string of note symbols: ":e4, :g4, :c5"
            map_lines.append(f'  "{char}" => "{notes}",')
            
        note_map_str = "\n".join(map_lines)

        ruby_code += f"""
# {map_name} (Unique Musical Block)
{map_name} = {{
{note_map_str}
}}
"""

    # 4. Main Sequence
    ruby_code += f"""
# --- 4. MAIN SEQUENCE (The Song Structure) ---
# Sequencing the sections generated from the input file.
# NOTE: Adjust the 'repeats' variable for each section below as needed.
live_loop :song_sequence do
  current_step_length = base_step_length 

"""
    # 5. Add the function calls sequentially (following the input file order)
    for i, seq_item in enumerate(final_sequence):
        
        map_name = seq_item['map_name']
        pattern_string = seq_item['pattern']
        
        repeats = 1
        
        if seq_item['is_repeat']:
            # For repeated sections, point back to the original unique section
            comment = f"# REPEAT: {seq_item['name']} reuses the pattern and map from the unique section {map_name}"
        else:
            # For new sections, show the full details
            comment = f"# NEW SECTION: {seq_item['name']} (Pattern Length: {len(pattern_string)})"


        ruby_code += f"""
  {comment}
  d = play_section_pattern {map_name},
    "{pattern_string}",
    {repeats}, current_step_length, "{seq_item['name']}"
  sleep d
  sleep 0.03 # Small buffer between sections
"""

    ruby_code += """
  # Stop the loop after the sequence finishes
  stop
end
"""
    
    with open(output_file_path, 'w') as f:
        f.write(ruby_code)

def main():
    try:
        global INPUT_FILE_NAME 
        
        if not os.path.exists(INPUT_FILE_NAME):
            alt_input_name = "input_tabs.txt"
            if os.path.exists(alt_input_name):
                 INPUT_FILE_NAME = alt_input_name
            else:
                print(f"Error: Input file '{INPUT_FILE_NAME}' or '{alt_input_name}' not found.")
                print("Please ensure your tab file exists and is named one of the above.")
                return

        with open(INPUT_FILE_NAME, 'r', encoding='utf-8') as f:
            file_content = f.read()
        
        bpm, volume, final_sequence, unique_sections = parse_tabs_to_section_patterns(file_content)
        
        if not final_sequence:
            print("ERROR: No valid track data found in the input file after checking for 'LH/RH' lines.")
            return

        base_name = os.path.splitext(INPUT_FILE_NAME)[0]
        output_file_path = base_name + OUTPUT_FILE_EXTENSION
        
        generate_ruby_file(bpm, volume, final_sequence, unique_sections, output_file_path)
        
        print("-" * 50)
        print(f"SUCCESS: Converted {len(final_sequence)} sections at {bpm} BPM with modular mapping.")
        print(f"Identified {len(unique_sections)} unique musical blocks.")
        print(f"Generated Ruby code saved to: {output_file_path}")
        print("NOTE: Repetitions (SECTION_5) now reuse the map/pattern of the original section.")
        print("-" * 50)

    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    main()