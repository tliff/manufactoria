require 'pp'
require './lib/machine.rb'
require './lib/node.rb'

m = Machine.new('rbrbrbbbrb') do
  node :start, :write_yellow, :case
  #eat a character, if we're empty, accept
  node :case, :read_red_blue, {
    red: :red_case,
    blue: :blue_case,
    empty: :end
  }
  
  #look for a blue and remove it
  node :red_case, :read_red_blue, {
    red: :red_case_writeback,
    blue: :ffw, 
    empty: :reject
  }
  node :red_case_writeback, :write_red, :red_case
  
  #look for a red and remove it
  node :blue_case, :read_red_blue, {
    red: :ffw,
    blue: :blue_case_writeback,
    empty: :reject
  }
  
  node :blue_case_writeback, :write_blue, :blue_case
  
  #Ye olde forwart to the end
  node :ffw, :read_red_blue, {
    red: :ffw_red,
    blue: :ffw_blue,
    empty: :ffw_remove_yellow
  }
  node :ffw_blue, :write_blue, :ffw
  node :ffw_red, :write_red, :ffw
  
  #remove the yellow and jump to start
  node :ffw_remove_yellow, :read_yellow_green, {
    yellow: :start
  }
  node :end, :accept
end

pp m.run true