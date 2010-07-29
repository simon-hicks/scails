# encoding: utf-8

class Scails::Live::Session
  include HighLine::SystemExtensions
  include Scails::Shortcuts::Music
  include Scails::Shortcuts::Scheduling
  
  # Starts a live session using a named pipe to receive code from a remote source and evaluates it within a context, a bit like an IRB session but evaluates code sent from a text editor
  def initialize
    return p( Exception.new("Another session seems to be running: #{Dir.tmpdir}/ruby_live.pipe") ) if File.exist?( "#{Dir.tmpdir}/ruby_live.pipe" )
    p Scails::Live::Notice.new("Live Session")
    get_binding
    init_pipe
    expect_input
    serve
  end
  
  def init_pipe
    @pipe_path = Scails::Live::Pipe.new('').path
    `rm #{@pipe_path}; mkfifo #{@pipe_path}`
  end
  
  # Starts a loop that checks the named pipe and evaluate its contents, will be called on initialize
  def serve
    File.open( @pipe_path, File::RDONLY | File::NONBLOCK) do |f|
      loop { p evaluate( f.gets.to_s.gsub("∂", "\n") ) }
    end
  end

  # Starts a new Thread that will loop capturing keystrokes and evaluating the bound block within the @context Binding, will be called on initialize
  def expect_input
    Thread.new do
      loop do
        char = get_character
        @bindings ||= []
        bind = @bindings[ char ]
        p evaluate( bind ) if bind
      end
    end
  end
  
  # Expects a one char Symbol or String which will bind to a passed block so it can be called later with a keystroke
  def bind key, &block
    @bindings = [] unless @bindings.instance_of?(Array)
    block ||= Proc.new{}
    @bindings[ key.to_s[0] ] = Ruby2Ruby.new.process( [:block, block.to_sexp.last] )
    Scails::Live::Notice.new( "Key '#{key}' is bound to an action")
  end
  
  # Evaluates a ruby expression within the @context Binding
  def evaluate string = nil
    return resilient_eval( string, @context ) if string
  end
  
  def clear
    print "\e[2J\e[f"
  end
  
  def get_binding #:nodoc:
    @context = binding
  end
  
  def run_updates code
    source = ParseTree.new.parse_tree_for_string( code ).first
    final = []
    while iter = source.assoc(:iter)
      source -= [iter]
      final << [:block, iter.last] if iter[1].include?(:update)
    end
    evaluate( final.collect{ |exp| Ruby2Ruby.new.process(exp) }.join("\n") )
    Scails::Live::Notice.new('Update blocks evaluated')
  end
  
  def update; yield end
  
  alias :reaload! :get_binding
end
