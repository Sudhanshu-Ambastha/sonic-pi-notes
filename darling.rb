#Darling by Leokarl
use_bpm 60
set_volume! 3.5
synth :piano
define :e1 do
  play :d5
  sleep 0.5
  play :b4
  sleep 0.5
end
2.times do
  e1()
end
define :c1 do
  play :c5
  sleep 0.5
  play :d5
  sleep 0.5
end
c1()
play :f5
sleep 0.5
define :f1 do
  2.times do
    play :e5
    sleep 1
  end
end
c1()
play :e5
sleep 0.5
e1()
c1()
play :g5
sleep 0.5
play :f5
sleep 0.5
f1()

define :a1 do
  c1()
  play :e5
  sleep 0.5
  play :d5
  sleep 0.5
end
a1()
define :d1 do
  play :b4
  sleep 0.5
  play :d5
  sleep 0.5
end
2.times do
  d1()
end
c1()

define :d1 do
  play :g5
  sleep 0.5
  play :f5
  sleep 0.5
  play :e5
  sleep 1
end
d1()
play :e5
sleep 0.5
a1()
sleep 0.5
d1()
play :b4
sleep 0.5
play :c5
sleep 1
d1()
c1()