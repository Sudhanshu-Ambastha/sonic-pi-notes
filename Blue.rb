#Blue by Yung Kai (https://pianoletternotes.blogspot.com/2025/09/blue-by-yung-kai.html)
use_synth :piano
use_bpm 92

MUSIC_FILE_PATH = "./blue.txt"
SMALLEST_TIME_UNIT_RATIO = 0.5

NOTE_MAP = {
  'a' => :a, 'b' => :b, 'c' => :c, 'd' => :d, 'e' => :e, 'f' => :f, 'g' => :g,
  'A' => :as, 'C' => :cs, 'D' => :ds, 'F' => :fs, 'G' => :gs,
  'B' => :bs, 'H' => :b
}

define :get_note do |char, octave|
  base_note = NOTE_MAP[char]
  return nil unless base_note
  return "#{base_note}#{octave}".to_sym
end

define :parse_and_play_block do |block_text|
  time_unit = 60.0 / current_bpm * SMALLEST_TIME_UNIT_RATIO
  
  lines = block_text.split("\n").map(&:strip).reject do |l|
    l.empty? || l.start_with?('#') || l.match(/^\d+$/)
  end
  
  raw_patterns = lines.map do |line|
    match = line.match(/(LH|RH):(\d)\|(.+)/)
    next nil unless match
    {
      octave: match[2].to_i,
      pattern: match[3].gsub(/[\|\s—]/, ''),
      line_length: match[3].gsub(/[\|\s—]/, '').length
    }
  end.compact
  
  return if raw_patterns.empty?
  
  total_steps = raw_patterns.max_by { |p| p[:line_length] }[:line_length]
  
  with_fx :reverb, room: 0.4 do
    (0...total_steps).each do |step|
      current_notes = []
      
      raw_patterns.each do |p|
        char = p[:pattern][step]
        next if char.nil? || char == '-'
        note = get_note(char, p[:octave])
        current_notes << note if note
      end
      
      if current_notes.empty?
        sleep time_unit
      else
        play current_notes, sustain: time_unit * 0.9, release: 0.1, amp: 1.2
        sleep time_unit
      end
    end
  end
end

in_thread do
  sleep 1
  
  begin
    current_bpm = 92
    complete_song_file = File.read(MUSIC_FILE_PATH)
    blocks = complete_song_file.split(/(?=\n\d+\n)/)
    
    blocks.each_with_index do |block, idx|
      next if block.strip.empty?
      parse_and_play_block(block)
      sleep 0.3
    end
  rescue Errno::ENOENT
    puts "File not found: #{MUSIC_FILE_PATH}"
  rescue => e
    puts "Error: #{e.message}"
  end
end
