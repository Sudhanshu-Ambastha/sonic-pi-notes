use_bpm 93                                                                                # BPM
# 8th notes    |1   2   3   4   5   6   7   8  |1   2   3   4   5   6   7   8  |
kick_rhythm  = [1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0]          # Kick Sequencer
snare_rhythm = [0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0]          # Snare Sequencer
hh_rhythm    = [1,0,1,0,1,0,1,0,1,0,1,0,1,0,2,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,2,0]          # HiHats (1=closed, 2=open)
chords       = [2,4,6,5,2,4,1,3]                                                          # Chord Progression


sc1 = :G3                                 # Here you can set the tonic / root note.
sc2 = :major                              # And here wether you want a minor or major scale.
no = 4                                    # Determines how many notes are in a chord. It's still basic Triads though.


# Cues the chords + bass notes
in_thread do
  7.times do
    cue :keys
    sleep 32
  end
end


# Cues the drums and takes care of timing and song structure
in_thread do
  4.times do
    cue :hihat
    sleep 8
  end
  8.times do
    cue :kick
    cue :snare
    cue :hihat
    sleep 8
  end
  4.times do
    cue :kick
    sleep 8
  end
  8.times do
    cue :kick
    cue :snare
    cue :hihat
    sleep 8
  end
  sleep 32
  #Final chord + bass note
  if chords[0] < 3
    inv = 0
  elsif chords[0] < 5
    inv = -1
  elsif chords[0] < 7
    inv = -2
  else
    inv = -3
  end
  use_synth :fm
  play (chord_degree chords[0], sc1, sc2, no)[0]-12, cutoff: 70, decay: 1.2, release: 0.8
  use_synth :sine
  play_chord (chord_degree chords[0], sc1, sc2, no, invert: inv), cutoff: 50, decay: 1.2, sustain_level: 0.8
end


# Code below cycles through the chords and plays it + the bass note.
in_thread do
  loop do
    sync :keys
    for i in chords
      if i < 3
        inv = 0
      elsif i < 5
        inv = -1
      elsif i < 7
        inv = -2
      else
        inv = -3
      end
      2.times do
        use_synth :fm
        play (chord_degree i, sc1, sc2, no)[0]-12, cutoff: 70, decay: 1.2, release: 0.8
        use_synth :sine
        play_chord (chord_degree i, sc1, sc2, no, invert: inv), cutoff: 50, decay: 1.2, sustain_level: 0.8
        sleep 2
      end
    end
  end
end


# Code below is necessary to make the sequencer work. It checks for 1's and 0's at the
# top of the file (and 2's for open hihats) and it determines the drum sounds.
in_thread do
  loop do
    sync :kick
    for i in kick_rhythm
      if i == 1
        with_fx :reverb, mix: 0.2 do
          use_synth :mod_sine
          play 30, amp: 4, attack: rt(0.0003), decay: rt(0.0571), sustain_level: 0.54, release: rt(0.1429), mod_wave: 1, mod_pulse_width: 0.275, mod_phase: rt(0.1429)
        end
      end
      sleep 0.25
    end
  end
end


in_thread do
  loop do
    sync :snare
    for i in snare_rhythm
      if i == 1
        with_fx :reverb, mix: 0.125 do
          use_synth :mod_sine
          play 30, amp: 0.5, attack: rt(0.0006), release: rt(0.1143), mod_wave: 1, mod_phase: rt(0.1429)
          use_synth :noise
          play 60, amp: 2, attack: rt(0.0029), decay: rt(0.0286), sustain_level: 0.6, release: rt(0.0286), cutoff: 107
        end
      end
      sleep 0.25
    end
  end
end


in_thread do
  loop do
    sync :hihat
    for i in hh_rhythm
      if i == 1
        with_fx :hpf, cutoff: 105, mix: 0.6 do
          use_synth :noise
          play 50, amp: 0.5, attack: rt(0.0029), decay: rt(0.0114), sustain_level: 0.3, release: rt(0.0126), amp: 0.6, cutoff: 130
        end
      elsif i == 2
        with_fx :hpf, pre_mix: 0.7, cutoff: 100, mix: 0.9 do
          use_synth :noise
          play 50, amp: 0.6, attack: rt(0.0057), decay: rt(0.1429), sustain_level: 0.58, release: rt(0.1714), cutoff: 126
        end
      end
      sleep 0.25
    end
  end
end
