

class Scails::Clock
  include Singleton

  def initialize
    @resolution = 0.01
    @queue = []

    Thread.new do
      loop do
        begin
          dispatch
          sleep @resolution
        rescue Exception => e
          puts e.class
          puts e.message
          puts $@
        end
      end
    end
  end

  attr_accessor :resolution

  def at time, &block
    @queue << [time,block]
  end

  def before time, &block
    @queue << [time - @resolution, block]
  end

  def flush
    @queue = []
  end

  private

  def dispatch
    now = Time.now
    ready, @queue = @queue.partition{|time, event| time <= now}
    ready.each{|time, event| event.call(time)}
  end
end
