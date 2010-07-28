require 'scails'
require 'scails/midiator/drivers/audio_unit.rb'

class Scails::MIDIator::Driver::Reaktor < Scails::MIDIator::Driver::AudioUnit
  module AudioToolbox
    AudioUnitManufacturer          = '-NI-'.to_bytes
    AudioUnitSubType               = 'NiR5'.to_bytes
  end
end
