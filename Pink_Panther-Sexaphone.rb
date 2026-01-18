#Pink Panther Theme Song - Saxophone Version
use_bpm 105

define :sax_lead do |n, d|
  use_synth :blade
  play n, attack: 0.05, sustain: d * 0.8, release: 0.2, cutoff: 100, vibrato_rate: 6, amp: 1
end

define :play_phrase do |notes, durs|
  notes.each_with_index do |n, i|
    d = durs[i]
    sax_lead n, d if n != :nil
    sleep d
  end
end

define :section_intro do |dur, s|
  n = [:gs4, :a4, :nil, :b4, :c5]
  d = [0.25, 0.25, dur, 0.25, 0.5]
  play_phrase n, d
  sleep s
end

define :section_theme_1 do
  n = [:f5, :e5, :nil, :a4, :c5, :nil, :e5]
  d = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0]
  play_phrase n, d
end

define :section_theme_2 do
  n = [:f5, :e5, :nil, :c5, :e5, :nil, :a5, :gs5]
  d = [0.5, 0.5, 0.25, 0.5, 0.5, 0.25, 0.5, 3.2]
  play_phrase n, d
end

define :section_chromatic_stutter do |reps|
  n = ([:eb4, :d4] * reps)
  d = ([0.1, 0.7] * reps)
  sleep 0.7
  play_phrase n, d
end

define :section_descending_run do
  n = [:a4, :g4, :e4, :d4, :c4, :a3]
  d = [0.5, 0.5, 0.5, 0.5, 0.5, 0.25]
  play_phrase n, d
end

define :section_finale do
  play_phrase [:eb5], [1.5]
  n = [:d5, :c5, :a4, :g4, :a4]
  d = [0.33, 0.33, 0.33, 0.33, 1.5]
  play_phrase n, d
end

define :section_resolution do
  n = [:c5, :a4, :g4, :a4,:nil, :a4]
  d = [0.5, 0.25, 0.25, 0.25, 0.2, 3.0]
  play_phrase n, d
end

define :section_1 do
  section_intro 1, 1
  section_intro 0.2, 0.2
  section_theme_1
  section_finale
  sleep 1
end

define :section_2 do
  section_intro 1, 1
  section_theme_2
  sleep 1
end

define :main do
  section_1
  section_2
  sleep 2
  section_1
  section_descending_run
  section_chromatic_stutter 4
  3.times do
    section_resolution
    sleep 1
  end
  sleep 1
end
main
stop
