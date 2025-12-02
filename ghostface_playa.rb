# GhostFace Playa - Dr.Livesey Phonk
use_bpm 50
set_volume! 3.5
use_synth :piano
use_synth_defaults release: 0.4, amp: 1.0

define :play_variable_melody do |melody_map, melody_pattern, rhythms, repeats|
  seq = melody_pattern.chars.zip(rhythms)
  total = rhythms.sum * repeats
  
  in_thread do
    seq.cycle(repeats) do |char, dur|
      play melody_map[char] if melody_map.key?(char)
      sleep dur
    end
  end
  
  total
end

define :play_sustained_bass do |note, duration, amp|
  in_thread do
    with_fx :reverb, room: 0.4 do
      synth :sine, note: note, sustain: duration, release: 0.5, amp: amp
    end
  end
end

livesey_map = {
  "1" => :d3,
  "2" => :eb3,
  "3" => :a3,
  "4" => :d4,
  "5" => :bb3,
  "6" => :a3,
  "8" => [:d2,:a3],
  "9" => [:g2,:d3]
}

livesey_melody = "921853921865692182186"
rhythms = [0.25,0.25,0.25,0.25,0.125,0.25,0.25,0.25,0.25,0.25,0.125,0.125,0.25,0.25,0.25,0.25,0.25,0.125,0.25,0.25,0.25]
bass_note = :d2
repeat_count = 2
bass_amp = 0.4

mel_duration = rhythms.sum * repeat_count
play_sustained_bass(bass_note, mel_duration, bass_amp)

d = play_variable_melody(livesey_map, livesey_melody, rhythms, repeat_count)
sleep d
sleep 0.5