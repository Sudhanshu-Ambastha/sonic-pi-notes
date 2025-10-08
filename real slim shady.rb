# Slim Shady - Complete Song Structure (Verse-Chorus-Bridge)
use_bpm 100
set_volume! 1

# --- Global Structure Controller Function ---
# Checks which part of the song is currently set by the :structure loop
define :song_part do |key|
  return get(:song_structure) == key
end

# --- MELODY AND RHYTHM DEFINITIONS ---
mel1 = ring(
  :C5, :Eb5, :G5, :Ab5, :C6, :Ab5, :G5,
  :Ab5, :G5, :Ab5, :G5, :F5, :G5, :B4,
)

t1 = ring(
  0.5, 0.5, 0.5, 0.5, 1.5, 0.5, 1.5,
  0.5, 0.1, 0.1, 0.3, 0.5, 0.5, 0.5 # Total duration: 8.0 beats (16 * 0.5)
)

mel2 = ring(
  :D5, :C5, :G4, :F4, :Eb4, :D4, :C4,
)

t2 = ring(
  0.5, 0.5, 0.5, 1, 0.5, 0.5, 0.5, # Total duration: 4.0 beats
)

bass = ring(:C3, :F3, :Eb3, :D3)

# --- DRUM SAMPLES (Inbuilt) ---
kick = :drum_bass_hard
snare = :drum_snare_hard
hat1 = :drum_cymbal_closed
hat2 = :drum_cymbal_open

# 32-step grid (8 beats total)
grid1= [
  1,0,3,0, 2,0,3,0, # Bar 1
  1,0,3,0, 2,0,3,0, # Bar 2
  1,0,3,0, 2,0,3,0, # Bar 3
  1,0,3,0, 2,0,4,0, # Bar 4 - Note the open hat (4) on the last bar
]

# --- LIVE LOOPS (The Instruments) ---

## 1. Drums (8-Beat Cycle)
live_loop :drum do
  32.times do |index|
    # This loop runs for exactly 8 beats (32 * 0.25)
    sample kick, amp: 1.5 if grid1[index] == 1
    sample snare if grid1[index] == 2
    sample hat1 if grid1[index] == 3
    sample hat2, release: 0.25 if grid1[index] == 4
    sleep 0.25
  end
end

## 2. Bassline (8-Beat Cycle)
live_loop :bass, sync: :drum do
  tick(:b) # Unique ticker for bass
  use_synth :fm
  
  if song_part(:verse) or song_part(:chorus)
    # The bassline repeats the 4 notes twice for an 8-beat cycle
    play bass.look(:b), release: 2.5
    sleep 2
  elsif song_part(:bridge)
    # Bridge: A sustained, simplified groove for contrast
    play :C3, release: 4
    sleep 4
    play :F3, release: 4
    sleep 4
  else
    sleep 8 # Silent during intro/outro
  end
end

## 3. Main Melody (8-Beat Cycle)
live_loop :melody, sync: :drum do
  tick(:m1) # Unique ticker for melody 1
  use_synth :prophet
  
  if song_part(:verse)
    with_fx :band_eq, distort: 0.6, room: 1 do
      # Plays the full mel1 array which is 8 beats long
      play mel1.look(:m1), amp: 0.8
      sleep t1.look(:m1)
    end
  elsif song_part(:chorus)
    # Chorus: Higher octave, faster repetition
    play :C6, amp: 1.2
    sleep 0.5
    play :Ab5, amp: 1.2
    sleep 0.5
    play :G5, amp: 1.2
    sleep 0.5
    sleep 6.5 # Total sleep = 8 beats
  else
    sleep 8
  end
end

## 4. Counter Melody (8-Beat Cycle)
live_loop :melody2, sync: :drum do
  tick(:m2) # Unique ticker for melody 2
  
  if song_part(:verse)
    with_fx :flanger, phase: 0.8 do
      use_synth :dtri
      # Plays mel2 at double duration, completing the 8-beat cycle in 2 passes
      play mel2.look(:m2), cutoff: 60, release: 2, amp: 0.8
      sleep t2.look(:m2) * 2
    end
  else
    sleep 8 # Silent during chorus/bridge/etc.
  end
end

# --- SONG STRUCTURE CONTROLLER ---
live_loop :structure do
  # NOTE: All sleep times are multiples of the 8-beat loop length
  
  # 1. INTRO
  set :song_structure, :intro
  in_thread do
    with_fx :reverb, room: 0.8 do
      sample :elec_ping, amp: 2, rate: 0.5
      sleep 4
      sample :elec_ping, amp: 2, rate: 1
    end
  end
  sleep 8
  
  # 2. VERSE 1
  set :song_structure, :verse
  sleep 32 # 4 x 8-beat loops
  
  # 3. CHORUS
  set :song_structure, :chorus
  sleep 16 # 2 x 8-beat loops
  
  # 4. VERSE 2
  set :song_structure, :verse
  sleep 32
  
  # 5. BRIDGE (Build-up/Breakdown)
  set :song_structure, :bridge
  sleep 16 # 2 x 8-beat loops
  
  # 6. CHORUS (Double Length)
  set :song_structure, :chorus
  sleep 32 # 4 x 8-beat loops
  
  # 7. OUTRO
  set :song_structure, :outro
  sleep 8
  
  # End the song
  stop
end