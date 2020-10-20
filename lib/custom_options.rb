class CustomOptions

  def get_requested_input(continue_key, break_key)
    loop do
      input = gets.chomp.upcase
      if input == continue_key
        return :continue
        break
      elsif input == break_key
        return :break
        break
      else
        puts "Please enter a valid option."
      end
    end
  end

  def query_custom
    puts "Enter 'd' to play with default settings,  or enter 'c' to create a custom board and ships."
    if get_requested_input("C","D") == :continue
      print "Choose board size? (y/n) "
      if get_requested_input("Y", "N") == :continue
        custom_board
      else
        @board_width = 4
        @board_height = 4
      end
      print "Create custom ships? (y/n) "
      if get_requested_input("Y", "N") == :continue
        custom_ships
      end
    end
  end

  def custom_board
    print "Enter custom board width: "
    @board_width = get_integer(2,10, "Width")
    print "Enter custom board width: "
    @board_height = get_integer(2, 26, "Height")
  end

  def custom_ships
    @ships = []
    input = ""
    until input == :continue do
      print "Enter custom ship name: "
      name = gets.chomp.to_s.capitalize
      print "Enter #{name} length: "
      length = get_integer(1,[@board_width, @board_height].max, "Length")
      if (length + @ships.sum {|ship| ship[1]}) > (@board_width * @board_height)
        puts "There is not enough space left on the board for a ship of this length. #{name} cannot be created."
      else
        @ships << [name, length]
        puts "Created custom ship #{name} with length #{length} units"
      end
      puts "Enter 'c' to create another ship, or press 'd' for done."
      input = get_requested_input("D","C")
    end
    @ships.sort_by! {|ship| -ship[-1]}
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
