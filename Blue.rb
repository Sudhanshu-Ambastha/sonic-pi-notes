#Blue - Yung Kai
use_bpm 63
set_volume! 1.5
synth :piano
3.times do
  play :B4, sustain: 0.25
  sleep 0.5
  play :E4, sustain: 0.25
  sleep 0.5
  play :Ds4, sustain: 0.25
  sleep 0.5
end

play :e4, sustain: 0.15
sleep 0.5
play :fs4, sustain: 0.25
sleep 0.5
play :gs4, sustain: 0.25
sleep 0.5
play [:B5,:A3], sustain: 0.5
sleep 0.5
play [:cs5,:A3], sustain: 0.5
sleep 0.5
play [:e5,:A3], sustain: 0.5
sleep 0.5
play [:a6,:A3], sustain: 0.5
sleep 0.5
play [:gs5,:A3], sustain: 0.2
sleep 0.5
play [:fs5,:A3], sustain: 0.2
sleep 0.5

play [:ds5,:b3], sustain: 0.3
sleep 0.5
play [:ds5,:b3], sustain: 0.1
sleep 0.5
play [:e5,:b3], sustain: 0.25
sleep 0.5
play [:fs5,:b3], sustain: 0.25
sleep 0.5
play [:e5,:b3], sustain: 0.15
sleep 0.5
play [:b5,:e3], sustain: 1.3
sleep 0.5
play [:gs5,:e3], sustain: 0.3
sleep 0.5
play [:a5,:e3], sustain: 0.3
sleep 0.5
play [:b5,:e3], sustain: 0.3
sleep 0.5

play [:ds5,:cs3], sustain: 1.3
sleep 0.5
play [:e5,:cs3], sustain: 1.3
sleep 0.5

play [:b5,:a3], sustain: 0.1
sleep 0.5
play [:cs5,:a3], sustain: 0.1
sleep 0.5
play [:e5,:a3], sustain: 0.2
sleep 0.5
play [:a6,:a3], sustain: 0.1
sleep 0.5
play [:gs6,:a3], sustain: 0.1
sleep 0.5
play [:ds6,:a3], sustain: 0.1
sleep 0.5

play [:b6,:b3], sustain: 0.15
sleep 0.5
play [:a6,:b3], sustain: 0.15
sleep 0.5
play [:gs6,:b3], sustain: 0.15
sleep 0.5
3.times do
  play [:e5,:e3], sustain: 0.15
  sleep 0.5
end
3.times do
  play [:fs5,:e3], sustain: 0.15
  sleep 0.5
end
3.times do
  play [:gs5,:cs3], sustain: 0.15
  sleep 0.5
end
2.times do
  play [:ds5,:cs3], sustain: 0.15
  sleep 0.5
end
play [:ds5,:cs3], sustain: 0.1
sleep 0.5
play [:ds5,:a3], sustain: 0.4
sleep 0.5
play [:e4,:a3], sustain: 0.25
sleep 0.5
play [:cs5,:a3], sustain: 0.25
sleep 0.5
play [:b5,:a3], sustain: 0.2
sleep 0.5