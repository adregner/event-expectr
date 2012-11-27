require 'expectr'
require 'timeout'

class EventExpectr
  # hash of patterns mapping to code blocks to execute when they match
  attr_reader :patterns

  # Expectr instance this class wraps
  attr_reader :expectr

  # boolean value that keeps the run! method running.  set to false to bail out.
  attr_accessor :running

  def initialize(cmd, args={})
    @timeout = args.delete(:timeout) || 30
    
    @expectr = Expectr.new(cmd, args)
    @expectr.timeout = 0.01

    @patterns = {}
  end

  def expect(pattern, &block)
    if not [String, Regexp].include? pattern.class
      raise TypeError, "Pattren class should be String or Regexp"
    end

    @patterns[pattern] = block
  end

  def run!
    if @patterns.count == 0
      raise RuntimeError, "No patterns have been defined yet, this would just look forever"
    end

    @running = true

    begin
      Timeout::timeout(@timeout) do
        while @running
          @patterns.each_pair do |pattern, block|
            match = @expectr.expect(pattern, true)
            if match
              # run the code provided with this pattern
              block.call(match)

              # remove it so we don't try to match again
              @patterns.delete(pattern)

              # the code block may have turned this off
              break unless @running
            end

            @running = false if @patterns.count == 0
          end

          sleep 0.1
        end
      end
    rescue Timeout::Error
      # haven't found all the matches in the time given.  oh well.
      return false
    end

    # this is an intentional end of the run process
    return true
  end

end
