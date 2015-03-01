require_relative './node.rb'
require_relative './grid.rb'

class Machine

  END_STATES = [:accept, :reject, :doesnotterminate]

  def initialize tape, &program
    @tape = tape
    @states = {}
    @current_state = :start
    @past_states = {}
    self.instance_eval &program
  end
  
  def run(debug=false)
    while !END_STATES.member? @current_state do
      step(debug)
    end
    [@current_state, @tape]
  end

  def step debug
    raise "No such node #{@current_state}" if !@states[@current_state] 
    node = @states[@current_state]
    @current_state, @tape = node.apply @tape
    @current_state = :doesntotterminate if @past_states[[@current_state, @tape]]
    @past_states[[@current_state, @tape]] = true
    pp [@current_state, @tape] if debug
  end
  
  def node name, type, transition=nil
    new_node = nil
    case type
    when :read_red_blue
      new_node = Node::ReadRedBlue.new(transition[:red] || :impossible, transition[:blue] || :impossible, transition[:empty] || :impossible)
    when :read_yellow_green
      new_node = Node::ReadYellowGreen.new(transition[:yellow] || :impossible, transition[:green] || :impossible, transition[:empty] || :impossible)
    when :write_red
      new_node = Node::WriteRed.new(transition)
    when :write_blue
      new_node = Node::WriteBlue.new(transition)
    when :write_yellow
      new_node = Node::WriteYellow.new(transition)
    when :write_green
      new_node = Node::WriteGreen.new(transition)
    when :accept
      new_node = Node::Accept.new
    end
    @states[name] = new_node
  end
  
  def layout width, height
    grid = Grid.new(width, height, @states)
    grid.layout
    grid
  end
  
  
end