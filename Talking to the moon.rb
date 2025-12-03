use_bpm 60
set_volume! 1.5

NOTE_MAP = {
  'a'=>:a, 'b'=>:b, 'c'=>:c, 'd'=>:d, 'e'=>:e, 'f'=>:f, 'g'=>:g,
  'A'=>:as,'B'=>:bs, 'C'=>:cs, 'D'=>:ds, 'F'=>:fs, 'G'=>:gs,
}

define :note_for do |char, oct|
  base = NOTE_MAP[char]
  return nil unless base
  "#{base}#{oct}".to_sym
end

define :parse_block do |block|
  lines = block.split("\n").map(&:strip).reject{|l| l.empty? || l =~ /^\d+$/}
  
  tracks = []
  
  lines.each do |line|
    m = line.match(/(RH|LH):(\d)\|(.+)\|/)
    next unless m
    
    tracks << {
      oct: m[2].to_i,
      chars: m[3].chars
    }
  end
  
  return [] if tracks.empty?
  
  width = tracks.map{|t| t[:chars].length}.max
  
  seq = []
  
  (0...width).each do |i|
    notes = []
    
    tracks.each do |t|
      ch = t[:chars][i]
      next if ch == '-' || ch.nil?
      n = note_for(ch, t[:oct])
      notes << n if n
    end
    
    seq << notes
  end
  
  seq
end

define :play_seq do |seq, dur|
  use_synth :piano
  with_fx :reverb, room: 0.5 do
    seq.each do |notes|
      if notes.empty?
        sleep dur
      else
        play notes, sustain: dur*0.8, release: 0.1
        sleep dur
      end
    end
  end
end

file_path = "./talking_to_the_moon.txt"

song = File.read(file_path)
blocks = song.split(/\n\d+\n/)

in_thread do
  sleep 1
  blocks.each do |blk|
    seq = parse_block(blk)
    play_seq(seq, 0.15)   # ← adjust tempo here
    sleep 0.3
  end
end
