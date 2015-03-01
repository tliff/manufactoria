module Node
  
  ORIENTATIONS = [:left, :up, :right, :down, :flipfleft, :flipup, :flipright, :flipdown]
  TRANSLATION = {
    'a'  => '.',    # End of program; do nothing
    'cf0'=> '→',    # Conveyor moving right
    'cf2' => '←',    # Conveyor moving left
    'cf3' => '↑',    # Conveyor moving up
    'cf1' => '↓',    # Conveyor moving down
    'fixme' => '#',    # Bridge: continue in same direction
    'rf2' => 'r',    # Red writer, right
    'rf1' => 'c',    # Red writer, up*
    'rf0' => 'R',    # Red writer, left
    'rf3' => 'C',    # Red writer, down*
    'bf2' => 'b',    # Blue writer, right
    'bf1' => 'd',    # Blue writer, up*
    'bf0' => 'B',    # Blue writer, left
    'bf3' => 'D',    # Blue writer, down*
    'gf2' => 'g',    # Green writer, right
    'gf1' => 'q',    # Green writer, up*
    'gf0' => 'G',    # Green writer, left
    'gf3' => 'Q',    # Green writer, down*
    'yf2' => 'y',    # Yellow writer, right
    'yf1' => 't',    # Yellow writer, up
    'yf0' => 'Y',    # Yellow writer, left
    'yf3' => 'T',    # Yellow writer, down
    'pf2' => 'h',    # b/r branch, left
    'pf1' => 'j',    # b/r branch, down
    'pf0' => 'k',    # b/r branch, up
    'pf3' => 'l',    # b/r branch, right
    'pf6' => 'H',    # r/b branch, left
    'pf5' => 'J',    # r/b branch, down
    'pf4' => 'K',    # r/b branch, up
    'pf7' => 'L',    # r/b branch, right
    'qf2' => 'u',    # g/y branch, left
    'qf1' => 'i',    # g/y branch, down
    'qf0' => 'o',    # g/y branch, up
    'qf3' => 'p',    # g/y branch, right
    'qf6' => 'U',    # y/g branch, left
    'qf5' => 'I',    # y/g branch, down
    'qf4' => 'O',    # y/g branch, up
    'qf7' => 'P',    # y/g branch, right     
  }
  
  
  class BaseNode
    attr_accessor :orientation
    def initialize
      @orientation = :left
    end
    
    def constraints
      # FIXME: rotations
      local_constraints
    end
    
    def symbol
      TRANSLATION[to_s]
    end
  end
  
  class Accept< BaseNode
    def initialize
      super()
    end
    
    def next_state
      :accept
    end
    
    def local_constraints
      {}
    end
    
    def to_s
      'a'
    end
    
    def apply tape
      [:accept, tape]
    end
  end

  # f0: ←
  # f1: ↑
  # f2: →
  # f3: ↓
  
  class Writer < BaseNode
    attr_reader :next_state
    def initialize next_state
      super()
      @next_state = next_state
    end
    
    def local_constraints
      {[-1,0] => @next_state}
    end
    
  end
  
  class WriteBlue < Writer
    
    def apply tape
      [@next_state, tape+'b']
    end
    def to_s
      'bf'+ORIENTATIONS.index(@orientation).to_s
    end
  end

  class WriteRed < Writer
    
    def apply tape
      [@next_state, tape+'r']
    end
    def to_s
      'rf'+ORIENTATIONS.index(@orientation).to_s
    end
    
  end

  class WriteYellow < Writer
    
    def apply tape
      [@next_state, tape+'y']
    end
    def to_s
      'yf'+ORIENTATIONS.index(@orientation).to_s
    end
    
  end

  class WriteGreen < Writer
    
    def apply tape
      [@next_state, tape+'g']
    end
    def to_s
      'gf'+ORIENTATIONS.index(@orientation).to_s
    end
    
  end
  
  
  # f0: r    f4: b
  #    ←←       ←←
  #     b        r
  #
  # f1: ↑    f5: ↑
  #    b↑r      r↑b
  #
  # f2: b    f6: r
  #     →→       →→
  #     r        b
  #
  # f3: r↓b  f7: b↓r
  #      ↓        ↓
  #
  
  class ReadRedBlue< BaseNode
    def initialize red_state, blue_state, other_state
      super()
      @red_state = red_state
      @blue_state = blue_state
      @other_state = other_state
    end
    
    def local_constraints
      {
        [0,-1] => @other_state,
        [1,0] => @red_state,
        [-1,0] => @blue_state,
      }
    end

    def apply tape
      if tape.length > 0
        if tape[0] == 'r'
          return [@red_state, tape[1,(tape.length-1)]]
        end
        if tape[0] == 'b'
          return [@blue_state, tape[1,(tape.length-1)]]
        end
      end
      [@other_state, tape]
    end
    
    def to_s
      'pf'+ORIENTATIONS.index(@orientation).to_s
    end
  end

  
  # f0: y    f4: g
  #    ←←       ←←
  #     g        y
  #
  # f1: ↑    f5: ↑
  #    g↑y      y↑g
  #
  # f2: g    f6: y
  #     →→       →→
  #     y        g
  #
  # f3: y↓g  f7: g↓y
  #      ↓        ↓
  #
  
  class ReadYellowGreen< BaseNode
    def initialize yellow_state, green_state, other_state
      super()
      @yellow_state = yellow_state
      @green_state = green_state
      @other_state = other_state
    end

    def local_constraints
      {
        [0,-1] => @other_state,
        [1,0] => @green_state,
        [-1,0] => @yellow_state,
      }
    end

    def apply tape
      if tape.length > 0
        if tape[0] == 'y'
          return [@yellow_state, tape[1,(tape.length-1)]]
        end
        if tape[0] == 'g'
          return [@green_state, tape[1,(tape.length-1)]]
        end
      end
      [@other_state, tape]
    end
    
    def to_s
      'qf'+ORIENTATIONS.index(@orientation).to_s
    end
  end
  
end