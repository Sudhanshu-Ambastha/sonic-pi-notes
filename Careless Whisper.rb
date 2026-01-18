#Careless Whisper
use_bpm 100

define :sax_lead_warm do |n, d|
  use_synth :blade
  play n, attack: 0.2, sustain: d * 0.7, release: 0.8,
    cutoff: 85, amp: 0.7,
    vibrato_rate: 5, vibrato_depth: 0.15,
    mod_phase: 0.25, mod_range: 0.1
end

define :play_phrase_relaxing do |notes, durs|
  notes.each_with_index do |n, i|
    d = durs[i]
    sax_lead_warm n, d if n != :nil
    sleep d
  end
end

define :part_1_intro do
  play_phrase_relaxing [:d5, :cs5, :b4, :fs4, :d5, :cs5], [0.75, 0.75, 0.75, 0.75, 0.75, 1.5]
end

define :part_2_bridge do
  play_phrase_relaxing [:b4, :fs4, :d5, :a4, :g4, :d4, :b3], [0.75, 0.75, 0.75, 0.5, 0.5, 0.5, 2.0]
end

define :part_3_resolve do
  play_phrase_relaxing [:g4, :d5, :b4, :a4, :g4, :d5], [0.5, 0.5, 0.5, 3.0, 0.5, 1.0]
end

define :part_4_rising do
  play_phrase_relaxing [:fs4, :g4, :a4, :b4, :cs5, :d5, :e5], [0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.8]
end

define :part_8_trills do
  play_phrase_relaxing [:g4, :a4, :g4, :a4], [0.125, 0.125, 0.125, 0.5]
  play_phrase_relaxing [:fs4, :g4, :b4], [0.25, 0.25, 3.0]
end

live_loop :background_harmonies do
  use_synth :hollow
  with_fx :reverb, room: 0.8, mix: 0.5 do
    play_chord [:d3, :f3, :a3], attack: 4, release: 4, amp: 0.5
    sleep 8
    play_chord [:bb2, :d3, :f3], attack: 4, release: 4, amp: 0.5
    sleep 8
  end
end

live_loop :careless_whisper_performance do
  with_fx :reverb, room: 0.9, mix: 0.5 do
    with_fx :lpf, cutoff: 90 do
      part_1_intro
      part_2_bridge
      part_3_resolve
      sleep 1
      
      part_4_rising
      part_8_trills
      
      sleep 10
    end
  end
end