require 'pp'
require './lib/machine.rb'

m = Machine.new('rbrrb') do
  node :start, :read_red_blue, {
    red: :red_case,
    blue: :blue_case,
    empty: :accept
  }
  
  node :red_case, :write_red, :accept

  node :blue_case, :write_blue, :accept
  
end

puts m.run
grid = m.layout(10,10)

grid.pretty_print
