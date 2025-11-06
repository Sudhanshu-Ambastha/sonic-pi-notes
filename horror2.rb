# The Sonic Pi Code for Max Horror and Less Silence

# --- 1. The Low-End Dread Drone (Constant, deep rumbling) ---
live_loop :sinister_drone do
  # Increased amp and more abrasive synth
  use_synth :dtri
  play :c1, attack: 4, sustain: 6, release: 2,
    cutoff: 30, res: 0.9, amp: 0.45, # Slightly louder, deeper
    pan: rrand(-0.4, 0.4)
  sleep 8
end

# --- 2. The Unrelenting Metallic Chaos (Core abrasive texture) ---
live_loop :metallic_chaos do
  # Use high-frequency noise and metallic impacts
  synth_choice = [:noise, :cnoise, :perc_snap, :perc_impact, :glitch_perc1]
  
  # **CHANGE:** Reduced silence probability and duration
  if one_in(10) # 1 in 10 chance of going silent (was 1 in 4)
    sleep rrand(0.1, 0.5) # Very short silence break
  else
    # Quick, frantic, and randomly panned sounds
    sample synth_choice.choose, rate: rrand(-3.0, 3.0), # Wider rate range for more distortion
      amp: rrand(0.5, 0.8),
      pan: rrand(-1, 1)
    sleep rrand(0.01, 0.2) # Much shorter, faster sleeps
  end
end

# --- 3. The Distorted Vocal Layer (Adding unsettling human-like element) ---
live_loop :whispers do
  # Use high-pitch synth with lots of effects to sound like distorted voices/screams
  use_synth :fm
  
  # Only play occasionally, but not too infrequently
  if one_in(2)
    with_fx :reverb, room: 0.7 do
      with_fx :flanger, depth: 8, feedback: 0.9 do # Flanger/Reverb for ghost-like sound
        play :b5, attack: 0.05, release: rrand(0.5, 1.5),
          amp: rrand(0.2, 0.4),
          pan: rrand(-0.8, 0.8)
      end
    end
  end
  sleep rrand(0.5, 2.5) # Keep this timing random but consistent
end

# --- 4. The Jittering Glitch (The Stable, Guaranteed Horror Version) ---

# This loop runs slowly and triggers a pre-loaded, complex sample
live_loop :stable_jitter do
  
  # A 1-in-3 chance to trigger a sound, ensuring unpredictability but also density
  if one_in(3)
    # Use a pre-loaded sample that already contains a complex, high-frequency sound
    # The 'bass_hardcore' sample, when played fast, sounds like a rapid tearing/sizzle.
    sample :bass_hardcore,
      rate: rrand(1.5, 3.0),      # Play it fast for the glitch effect
      amp: rrand(0.1, 0.3),
      pan: rrand(-0.9, 0.9),
      cutoff: rrand(100, 130)     # High cutoff for sharp, piercing sound
  end
  
  # A much slower, reliable sleep time to prevent timing errors.
  # This makes the sound fire sporadically but reliably without overloading the CPU.
  sleep rrand(0.05, 0.25)
end