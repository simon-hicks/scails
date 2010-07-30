# don't finish at the same time but they should
time = now + 2
midi_ramp(time, 1, 10, 10){|i| puts "a #{i}"}
midi_ramp(time, 127, 1, 10){|i| puts i} 

exit
