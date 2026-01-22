#Epic Sax Guy - Sergey Stepanov (https://pianoletternotes.blogspot.com/2017/10/epic-sax-guy-by-sergey-stepanov.html)
use_bpm 120
use_synth :piano
set_volume! 0.5

MUSIC_FILE_PATH = "./Epic Sax Guy.txt"
SMALLEST_TIME_UNIT_RATIO = 0.5

NOTE_MAP = {
  'a' => :a, 'b' => :b, 'c' => :c, 'd' => :d, 'e' => :e, 'f' => :f, 'g' => :g,
  'A' => :as, 'C' => :cs, 'D' => :ds, 'F' => :fs, 'G' => :gs,
  'B' => :bs, 'H' => :b, 'D' => :ds
}

define :get_note do |char, octave|
  base_note = NOTE_MAP[char]
  return nil unless base_note
  return "#{base_note}#{octave}".to_sym
end

define :parse_and_play_block do |block_text|
  time_unit = 60.0 / current_bpm * SMALLEST_TIME_UNIT_RATIO
  
  lines = block_text.split("\n").select { |l| l.include?('|') }
  
  raw_patterns = lines.map do |line|
    parts = line.split('|')
    next nil if parts.length < 2
    {
      octave: parts[0].strip.to_i,
      pattern: parts[1].strip
    }
  end.compact
  
  return if raw_patterns.empty?
  
  total_steps = raw_patterns.map { |p| p[:pattern].length }.max
  
  with_fx :reverb, room: 0.6, mix: 0.4 do
    (0...total_steps).each do |step|
      current_notes = []
      
      raw_patterns.each do |p|
        char = p[:pattern][step]
        if char && char != '-' && char != ' '
          note = get_note(char, p[:octave])
          current_notes << note if note
        end
      end
      
      if current_notes.empty?
        sleep time_unit
      else
        play current_notes, hard: 0, vel: 0.5, release: time_unit * 1.2
        sleep time_unit
      end
    end
  end
end

begin
  complete_song_file = File.read(MUSIC_FILE_PATH)
  blocks = complete_song_file.split(/\n\d+\n/)
  
  blocks.each do |block|
    next if block.strip.empty?
    parse_and_play_block(block)
  end
rescue Errno::ENOENT
  puts "File not found at #{MUSIC_FILE_PATH}"
rescue => e
  puts "Error: #{e.message}"
end