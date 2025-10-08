# Gangsta Paradise - Complete Song Structure
use_bpm 140
set_volume! 1.5

# --- GLOBAL CONTROL FUNCTION ---
# This function checks the current section of the song
define :song_part do |key|
  return get(:song_structure) == key
end

# --- MELODY DEFINITION ---
define :mel1 do
  # Main descending line: C -> C -> B -> B -> C -> G (16 beats total)
  4.times do
    play [:c7, :c6], sustain: 0.3, attack: 0.1
    sleep 2
  end
  2.times do
    play [:b6, :b5], sustain: 0.3, attack: 0.1
    sleep 2
  end
  play [:c7, :c6], sustain: 0.3, attack: 0.1
  sleep 2
  play [:g6, :g5], sustain: 0.3, attack: 0.1
  sleep 2
end

# --- CHORDS DEFINITION ---
define :chords_progression do
  # Progression: Gs minor, F major, G major, C minor (16 beats total)
  with_fx :reverb, amp: 0.5 do
    play :gs3, sustain: 4
    sleep 4
    play :f3, sustain: 4
    sleep 4
    play :g3, sustain: 4
    sleep 4
    play :c3, sustain: 4
    sleep 4
  end
end

# --- INBUILT SAMPLES ---
kick = :drum_bass_hard
snare = :drum_snare_hard
clap = :elec_clap
hat1 = :drum_cymbal_closed
tam = :drum_cowbell

# --- 1. CHORDS/HARMONY (The backbone, always running) ---
live_loop :chords do
  use_synth :organ_tonewheel
  chords_progression # Total loop duration is 16 beats
end

# --- 2. MELODY (Only active during the Verse) ---
live_loop :mel_saw, sync: :chords do
  use_synth :tech_saws
  
  if song_part(:verse)
    with_fx :reverb, mix: 0.5 do
      mel1 # 16 beats
    end
  else
    sleep 16 # Mute during Intro, Chorus, Outro
  end
end

# --- 3. CHOIR PAD (Active during Intro, Verse, and Chorus) ---
live_loop :choir1, sync: :chords do
  use_synth :dtri
  
  if song_part(:intro) or song_part(:verse) or song_part(:chorus)
    with_fx :reverb, room: 0.8, mix: 0.7 do
      # Sustained C minor chord (16 beats)
      play chord(:c4, :minor), sustain: 16, release: 0.5, amp: 1.5
      sleep 16
    end
  else
    sleep 16 # Mute during Outro
  end
end

# --- 4. DRUMS (The Beat) ---
live_loop :drum, sync: :chords do
  # Define the full 16-beat pattern once
  16.times do |i|
    # Drum only plays during Verse, Chorus, and Outro
    if song_part(:verse) or song_part(:chorus) or song_part(:outro)
      # Kick Pattern (Strong hits on 1, 3, and a subtle hit on 3&)
      sample kick, amp: 3 if i == 0 or i == 8 or i == 10
      
      # Hi-Hat (8th notes)
      sample hat1, amp: 0.8
      
      # Clap/Snare (On beats 2 and 4)
      sample clap, amp: 1.5 if i == 4 or i == 12 
    end
    sleep 0.5 # 8th note duration
  end
end

# --- 5. PERCUSSION ACCENT (Tambourine/Cowbell) ---
live_loop :tam, sync: :chords do
  # Only plays when the drums are active
  if song_part(:verse) or song_part(:chorus) or song_part(:outro)
    # Plays on every 8th note
    sample tam, amp: 0.5, sustain: 0.1
  end
  sleep 0.5
end

# --- 6. SONG STRUCTURE CONTROLLER (The Conductor) ---
live_loop :structure do
  # All sleeps are multiples of 16 (the duration of the chords loop)
  
  # A. INTRO (Choir and Chords set the mood)
  set :song_structure, :intro
  sleep 16 # 1 cycle
  
  # B. VERSE 1 (Melody enters)
  set :song_structure, :verse
  sleep 32 # 2 cycles
  
  # C. CHORUS 1 (Melody drops out, main beat/choir continues)
  set :song_structure, :chorus
  sleep 16 # 1 cycle
  
  # D. VERSE 2
  set :song_structure, :verse
  sleep 32 # 2 cycles
  
  # E. CHORUS 2 (Double length for emphasis)
  set :song_structure, :chorus
  sleep 32 # 2 cycles
  
  # F. OUTRO (Beat fades, chords continue)
  set :song_structure, :outro
  sleep 16
  
  # End the song
  stop
end