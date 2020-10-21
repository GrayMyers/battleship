class CustomOptions
  attr_reader :board_width, :board_height, :ships

  def initialize
    @board_width = 4
    @board_height = 4
    @ships = []
    query_board
    query_ships
  end

  def get_requested_input(continue_key, break_key)
    until (input = gets.chomp.to_s.upcase) == break_key
      if input == continue_key
        return :continue
        break
      else
        puts "Please enter a valid option."
      end
    end
  end

  def query_board
    print "Choose board size? (y/n) "
    if get_requested_input("Y", "N") == :continue
      choose_custom_board
    end
  end

  def choose_custom_board
    print "Enter custom board width: "
    @board_width = get_integer(2,10, "Width")
    print "Enter custom board height: "
    @board_height = get_integer(2, 26, "Height")
  end

  def query_ships
    print "Create custom ships? (y/n) "
    if get_requested_input("Y", "N") == :continue
      choose_ships
    end
  end

  def choose_ships
    input = ""
    until input == :continue do
      ships_input
      puts "Enter 'c' to create another ship, or press 'd' for done."
      input = get_requested_input("D","C")
    end
    @ships.sort_by! {|ship| -ship[-1]}
  end

  def ships_input
    print "Enter custom ship name: "
    name = gets.chomp.to_s.capitalize
    print "Enter #{name} length: "
    length = get_integer(1,[@board_width, @board_height].max, "Length")
    create_ship(name, length, (@board_width * @board_height))
  end

  def create_ship(name, length, board_size)
    if (length + @ships.sum {|ship| ship[1]}) > board_size
      puts "There is not enough space left on the board for a ship of this length. #{name} cannot be created."
    else
      @ships << [name, length]
      puts "Created custom ship #{name} with length #{length} units"
    end
  end

  def get_integer(min, max, description)
    input = gets.chomp.to_i
    until input >= min && input <= max do
      if input <= min
        print "#{description} cannot be smaller than #{min}. Please enter another value: "
      elsif input >= max
        print "#{description} cannot be greater than #{max}. Please enter another value: "
      end
      input = gets.chomp.to_i
    end
    input
  end
end
