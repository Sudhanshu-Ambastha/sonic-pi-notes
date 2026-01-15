#Still Dre - Dr. Dre ft. Snoop Dogg (https://pianoletternotes.blogspot.com/2017/11/still-dre-by-dr-dre-ft-snoop-dogg.html)
use_synth :piano
use_bpm 120

MUSIC_FILE_PATH = "./still dre.txt"
SMALLEST_TIME_UNIT_RATIO = 0.5

NOTE_MAP = {
  'a' => :a, 'b' => :b, 'c' => :c, 'd' => :d, 'e' => :e, 'f' => :f, 'g' => :g,
  'A' => :as, 'C' => :cs, 'D' => :ds, 'F' => :fs, 'G' => :gs,
  'B' => :bs, 'H' => :b
}

define :get_note do |char, octave|
  base_note = NOTE_MAP[char]
  return nil unless base_note
  "#{base_note}#{octave}".to_sym
end

define :parse_and_play_block do |block_text|
  time_unit = 60.0 / current_bpm * SMALLEST_TIME_UNIT_RATIO
  
  lines = block_text.split("\n").map(&:strip).reject do |l|
    l.empty? || l.start_with?('#') || l.match(/^\d+$/)
  end
  
  raw_patterns = lines.map do |line|
    if line =~ /^(\d)\|(.*)\|$/
      octave = $1.to_i
      pattern = $2.gsub(/[\s—]/, "")
      {
        octave: octave,
        pattern: pattern,
        line_length: pattern.length
      }
    else
      nil
    end
  end.compact
  
  return if raw_patterns.empty?
  
  total_steps = raw_patterns.max_by { |p| p[:line_length] }[:line_length]
  
  with_fx :reverb, room: 0.4 do
    (0...total_steps).each do |step|
      notes = []
      
      raw_patterns.each do |p|
        char = p[:pattern][step]
        next if char.nil? || char == '-'
        n = get_note(char, p[:octave])
        notes << n if n
      end
      
      if notes.empty?
        sleep time_unit
      else
        play notes, sustain: time_unit * 0.9, release: 0.1, amp: 1.2
        sleep time_unit
      end
    end
  end
end

in_thread do
  sleep 1
  begin
    current_bpm = 92
    file = File.read(MUSIC_FILE_PATH)
    
    blocks = file.split(/(?=\n\d+\n)/)
    
    blocks.each do |block|
      next if block.strip.empty?
      parse_and_play_block(block)
      sleep 0.3
    end
    
  rescue Errno::ENOENT
    puts "Missing: #{MUSIC_FILE_PATH}"
  rescue => e
    puts "Error: #{e.message}"
  end
end
