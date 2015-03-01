require "pp"
require 'json'
class Grid
  
  def initialize(width, height, data)
    @width = width
    @height = height
    @nodes = data
    wipe_board
  end
  
  def wipe_board
    @board = Array.new(@width){Array.new(@height)}
  end
  
  def layout
    wipe_board
#    pp @nodes
    @board[0][@width/2] = :in
    @board[@height -1][@width/2] = :accept
    constraints = {} #maps coordinates to targets
    order = (0..(@width-1)).to_a.product((0..(@height-1)).to_a).shuffle
    order = order.delete_if{|o| o == [@height -1, (@width/2).to_i]}
    order = order.delete_if{|o| o == [0, (@width/2).to_i]}
    
    # place each node
    @nodes.each do |identifier, node|
      begin
        # choose a candidate position
        candidate_position = order.shift
        node_constraints = {}
        #calucalte the constraints for the node in boardpace
        node.constraints.each do |coords, node|
          node_constraints[[coords[0]+candidate_position[0],coords[1]+candidate_position[1]]] = node
        end

        node_constraints.each do |pos, target|
          if pos[0] < 0 || pos[0] > @width || pos[1] < 0 || pos[1] > @height
            raise
          end
        end
        constraints.merge!(node_constraints)
        @board[candidate_position[0]][candidate_position[1]] = node

      rescue Exception => e
        pp e
        pp e.backtrace
        order << candidate_position
      end
    end
  end

  def dump
    @board.map{|l|
      l.map{|element|
        if element == :in
          's'
        elsif element == :accept
          'a'
        elsif element == nil
          ' '
        else
          element.to_s
        end
      }
    }.to_json
  end
  
  def pretty_print
    puts '+' + ('-' * @width) + '+'
    @board.each do |line|
      puts '|' + line.map{|element|
        if element == :in
          's'
        elsif element == :accept
          'a'
        elsif element == nil
          ' '
        else
          element.symbol
        end
      }.join + '|'
    end
    puts '+' + ('-' * @width) + '+'
  end
  
end