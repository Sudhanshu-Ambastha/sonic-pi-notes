require 'json'

file = "C:/Users/sudha/OneDrive/Documents/GitHub/sonic-pi-notes/audio/samples.json"
$SAMPLES = JSON.parse(File.read(file), symbolize_names: true)


def fetch_sounds(category, type=nil, sub=nil)
  sounds = if type && sub
             $SAMPLES.dig(category.to_sym, type.to_sym, sub.to_sym, :files)
           elsif type
             $SAMPLES.dig(category.to_sym, type.to_sym, :files)
           else
             top = $SAMPLES[category.to_sym]
             
             if top[:files]&.any?
               top[:files]
             else
               subcat = top.values.find { |v| v.is_a?(Hash) && v[:files]&.any? }
               subcat ? subcat[:files] : nil 
             end
           end

  Array(sounds)
end

def get_sample_path(category, type=nil, sub=nil, index=nil)
  sounds = fetch_sounds(category, type, sub)
  
  return nil if sounds.empty?

  index ? sounds[index] : sounds.sample
end

def play_first_clip(category, type=nil, sub=nil, **opts)
  path = get_sample_path(category, type, sub, 0)
  sample(path, **opts) if path
end

def play_random_clip(category, type=nil, sub=nil, **opts) 
  path = get_sample_path(category, type, sub)
  sample(path, **opts) if path
end