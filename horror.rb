# Sonic Pi Ambient Drone for Long-Form Videos
# This script has been modified for maximum relaxation and calm.

# --- CHANGE 1: Switched to Major Scale ---

# 1. GLOBAL EFFECTS: Apply heavy Reverb and Delay to the entire mix.
with_fx :reverb, room: 0.9, mix: 0.8 do
  with_fx :echo, phase: 1.5, decay: 8, mix: 0.5 do
    
    # 2. DEFINE THE SCALE: Using the universally supported :major_pentatonic for calm.
    scale_to_use = scale(:c2, :major_pentatonic, num_octaves: 3).to_a.ring
    
    # 3. BACKGROUND DRONE: The main, sustained sound.
    live_loop :drone do
      # CHANGE 2: Using the gentler :saw synth
      synth :saw,
        note: choose(scale_to_use),
        sustain: 8,
        release: 4,
        attack: 4,
        cutoff: rrand(60, 90),
        amp: 0.3
      
      sleep 8
    end
    
    # 4. RANDOM HIGH-PITCHED TEXTURE: Adds sparkling, airy notes. (No change needed)
    live_loop :sparkle do
      use_synth :pluck
      if one_in(5)
        play choose(scale_to_use).choose + 12,
          amp: 0.15,
          attack: 0.01,
          release: 1.5
        sleep 0.5
      else
        sleep 1.0
      end
    end
    
    # 5. SUBTLE BASS PULSE: Keeps a very low, slow rhythm.
    live_loop :low_pulse do
      # CHANGE 3: Raised the note from :c1 to :c2 to reduce the "rumble" effect.
      synth :dsaw,
        note: :c2,
        sustain: 1.5,
        release: 1.0,
        attack: 0.5,
        amp: 0.2
      sleep [4, 8].choose
    end
    
  end
end
