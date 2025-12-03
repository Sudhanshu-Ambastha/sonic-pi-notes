#I think of you not thinking of me - by far (https://pianoletternotes.blogspot.com/2025/11/i-think-of-you-not-thinking-of-me-by-far.html)
set_volume! 1.5
use_bpm 60

MUSIC_FILE_PATH = "./i-think-of-you-not-thinking-of-me-by-far.txt"

SMALLEST_TIME_UNIT_RATIO = 1.5

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

define :parse_and_play_block do |block_text, block_bpm|
  use_bpm block_bpm
  time_unit_duration = 60.0 / current_bpm * SMALLEST_TIME_UNIT_RATIO
  use_synth :piano
  
  lines = block_text.split("\n").map(&:strip).reject { |l|
    l.start_with?('#') || l.empty? || l.match(/^\d+bpm$/) || l.match(/^\d+$/)
  }
  return if lines.empty?
  
  raw_patterns = lines.map do |line|
    match = line.match(/(LH|RH):(\d)\|(.+)/)
    next nil unless match
    {
      octave: match[2].to_i,
      pattern: match[3].gsub(/[\|\s]/, ''),
      line_length: match[3].gsub(/[\|\s]/, '').length
    }
  end.compact
  
  return if raw_patterns.empty?
  
  total_steps = raw_patterns.first[:line_length]
  final_sequence = []
  current_step = 0
  
  while current_step < total_steps
    current_notes = []
    
    raw_patterns.each do |pattern_data|
    char = pattern_data[:pattern][current_step]
    next if char == '-'
    note = get_note(char, pattern_data[:octave])
    current_notes << note if note
  end
  
  if current_notes.empty?
    final_sequence << { note_or_chord: nil, duration: time_unit_duration }
    current_step += 1
    next
  end
  
  duration_units = 1
  
  (current_step + 1...total_steps).each do |next_step|
    is_sustained = true
    
    raw_patterns.each do |pattern_data|
      char_at_start = pattern_data[:pattern][current_step]
      char_at_next = pattern_data[:pattern][next_step]
      
      if char_at_start != '-'
        if char_at_next != '-' && char_at_next != char_at_start
          is_sustained = false
          break
        end
      end
    end
    
    break unless is_sustained
    duration_units += 1
  end
  
  final_sequence << {
    note_or_chord: current_notes.length == 1 ? current_notes.first : current_notes,
    duration: duration_units * time_unit_duration
  }
  
  current_step += duration_units
end

with_fx :reverb, room: 0.4 do
  final_sequence.each do |event|
    if event[:note_or_chord].nil?
      sleep event[:duration]
    else
      play event[:note_or_chord], sustain: event[:duration], release: 0.1, amp: 1.2
      sleep event[:duration]
    end
  end
end
end

in_thread do
  sleep 1
  
  begin
    current_bpm = 60
    complete_song_file = File.read(MUSIC_FILE_PATH)
    blocks_with_bpm = complete_song_file.split(/(?=\n\s*\d+bpm|\n\s*\d+\s*\n)/)
    
    blocks_with_bpm.each_with_index do |block, index|
      next if block.strip.empty?
      bpm_match = block.match(/^(\d+)bpm/)
      
      if bpm_match
        block_bpm = bpm_match[1].to_i
        current_bpm = block_bpm
        next if block.strip.match(/^\d+bpm$/)
      else
        block_bpm = current_bpm
      end
      
      parse_and_play_block(block, block_bpm)
      sleep 0.5
    end
    
  rescue Errno::ENOENT
    puts "ERROR: File not found at path: #{MUSIC_FILE_PATH}"
  rescue => e
    puts "Error: #{e.message}"
    puts e.backtrace.join("\n")
  end
end
