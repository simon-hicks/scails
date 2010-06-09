puts "hello"

@midi = Scails::MIDIator::Interface.new
@midi.autodetect_driver

exit
