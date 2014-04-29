module Node
  
  class Accept
    def apply tape
      [:accept, tape]
    end
  end
  
  class Writer 
    def initialize next_state
      @next_state = next_state
    end
  end
  
  class WriteBlue < Writer
    def apply tape
      [@next_state, tape+'b']
    end
  end

  class WriteRed < Writer
    def apply tape
      [@next_state, tape+'r']
    end
  end

  class WriteYellow < Writer
    def apply tape
      [@next_state, tape+'y']
    end
  end

  class WriteGreen < Writer
    def apply tape
      [@next_state, tape+'g']
    end
  end
  
  class ReadRedBlue
    def initialize red_state, blue_state, other_state
      @red_state = red_state
      @blue_state = blue_state
      @other_state = other_state
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
  end

  class ReadYellowGreen
    def initialize yellow_state, green_state, other_state
      @yellow_state = yellow_state
      @green_state = green_state
      @other_state = other_state
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
  end

end